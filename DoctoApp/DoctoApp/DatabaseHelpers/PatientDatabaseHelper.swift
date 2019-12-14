//
//  PatientDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class PatientDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "patient"
    static let table = Table("patient")
    
    // Fields
    static let id = Expression<Int64>("id")
    private let lastname = Expression<String>("lastname")
    private let firstname = Expression<String>("firstname")
    private let birthdate = Expression<String>("birthdate")
    private let email = Expression<String>("email")
    private let pwd = Expression<String>("pwd")
    private let pwdSalt = Expression<String>("pwd_salt")
    private let insuranceNumber = Expression<String>("insurance_number")
    private let addressId = Expression<Int64>("address_id")
    private let lastLogin = Expression<String>("last_login")
    private let picture = Expression<String>("picture")
    
    private static var pk = 0
    private var tableExist = false
    
    init() {}
    
    func initTableConfig() {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            let fileUrl = documentDirectory
                .appendingPathComponent(PatientDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
            
            let createTable = PatientDatabaseHelper.table.create { table in
                table.column(PatientDatabaseHelper.id, primaryKey: .autoincrement)
                table.column(self.lastname)
                table.column(self.firstname)
                table.column(self.birthdate)
                table.column(self.email)
                table.column(self.pwd)
                table.column(self.pwdSalt)
                table.column(self.insuranceNumber)
                table.column(self.addressId, unique: true)
                table.column(self.lastLogin)
                table.column(self.picture)
                
                // Alter table
                table.foreignKey(
                    self.addressId,
                    references: AddressDatabaseHelper.table, AddressDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
            }
            
            do {
                try self.database.run(createTable)
                print (PatientDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(PatientDatabaseHelper.table.drop())
        } catch {}
    }

    // Create a new patient in the database
    func createPatient(patient: Patient) -> Bool {
        var p: Patient = AddressDatabaseHelper().insertAddress(resident: patient) as! Patient
        
        // Check if the address was correctly added to the database
        if p.GetAddressId() == -1 { return false }
        
        p = self.insertPatient(patient: p) as! Patient
        
        // Check if the patient was correctly added to the database
        if p.getId() == -1 { return false }
        
        p = BookingDatabaseHelper().insertBookings(resident: p) as! Patient
        
        return true
    }
    
    // Insert a new patient in the database
    private func insertPatient(patient: Patient) -> Patient {
        self.initTableConfig()
        
        let query = PatientDatabaseHelper.table.insert(
            PatientDatabaseHelper.id <- Int64(patient.getId()),
            self.lastname <- patient.getLastname(),
            self.firstname <- patient.getFirstname(),
            self.birthdate <- patient.getBirthdate(),
            self.email <- patient.getEmail(),
            self.pwd <- patient.getPwd(),
            self.pwdSalt <- patient.getPwdSalt(),
            self.insuranceNumber <- patient.getInsuranceNumber(),
            self.addressId <- Int64(patient.GetAddressId()),
            self.lastLogin <- patient.getLastLogin(),
            self.picture <- patient.getPicture() == nil ? "" : patient.getPicture()!,
        )
        
        do {
            let patientId: Int = Int(try self.database.run(query))
            patient.setId(id: patientId)
            print("Patient insertion succeeded for patient: " + patient.getFullname())
        } catch {
            print("Patient insertion failed for patient: " + patient.getFullname())
        }
        
        return patient
    }
    
    // Update the given patient data in the database
    private func updatePatientData(patient: Patient) -> Bool {
        self.initTableConfig()
        
        let filter = PatientDatabaseHelper.table.filter(PatientDatabaseHelper.id == Int64(patient.getId()))
        let query = filter.update(
            self.lastname <- patient.getLastname(),
            self.firstname <- patient.getFirstname(),
            self.birthdate <- patient.getBirthdate(),
            self.email <- patient.getEmail(),
            self.pwd <- patient.getPwd(),
            self.pwdSalt <- patient.getPwdSalt(),
            self.insuranceNumber <- patient.getInsuranceNumber(),
            self.addressId <- Int64(patient.GetAddressId()),
            self.lastLogin <- patient.getLastLogin(),
            self.picture <- patient.getPicture() == nil ? "" : patient.getPicture()!,
        )
        
        do {
            if try self.database.run(query) > 0 {
                print("Patient update succeeded.")
                
                return true
            }
            
            print("Patient update failed.")
        } catch {
            print("Patient update failed.")
        }
        
        return false
    }
    
    // Update the given patient in the database
    func updatePatient(patient: Patient) -> Bool {
        if !AddressDatabaseHelper().updateAddress(resident: patient) { return false }
        
        return self.updatePatientData(patient: patient)
    }
    
    // Delete the given patient from the database
    func deletePatient(patient: Patient) -> Bool {
        self.initTableConfig()
        
        let filter = PatientDatabaseHelper.table.filter(PatientDatabaseHelper.id == Int64(patient.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
                print("Patient removal succeeded for patient: " + patient.getFullname())
                
                return true
            }
            
            print("Patient removal failed for patient: " + patient.getFullname())
        } catch {
            print("Patient removal failed for patient: " + patient.getFullname())
        }
        
        return false
    }
    
    // Retrieve a patient by its id
    func getPatient(patientId: Int?, email: String?, fromDoctor: Bool) -> Patient? {
        self.initTableConfig()
        
        var query: Table? = nil
        
        if patientId != nil {
            query = PatientDatabaseHelper.table
                .select(PatientDatabaseHelper.table[*])
                .filter(PatientDatabaseHelper.id == Int64(patientId!))
        } else if email != nil {
            query = PatientDatabaseHelper.table
                .select(PatientDatabaseHelper.table[*])
                .filter(self.email == email!)
        }
        
        do {
            for p in try self.database.prepare(query!) {
                let patient: Patient = Patient(
                    id: patientId!,
                    lastname: try p.get(self.lastname),
                    firstname: try p.get(self.firstname),
                    email: try p.get(self.email),
                    pwd: try p.get(self.pwd),
                    pwdSalt: try p.get(self.pwdSalt),
                    lastLogin: try p.get(self.lastLogin),
                    picture: try p.get(self.picture),
                    address: nil,
                    birthdate: try p.get(self.birthdate),
                    insuranceNumber: try p.get(self.insuranceNumber)
                )
                
                let address: Address? = AddressDatabaseHelper().getAddress(addressId: Int(try p.get(self.addressId)))
                
                patient.setAddress(address: address)
                
                if !fromDoctor {
                    let bookings: [Booking] = BookingDatabaseHelper().getBookings(patient: patient)
                    patient.setBookings(bookings: bookings)
                }
                
                return patient
            }
        } catch {
            print("Something went wrong when fetching patient data.")
        }
        
        return nil
    }
}
