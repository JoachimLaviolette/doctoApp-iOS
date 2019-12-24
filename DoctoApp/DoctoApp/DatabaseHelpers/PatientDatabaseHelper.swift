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

class PatientDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "patient"
    static let table = Table("patient")
    
    // Fields
    static let id = Expression<Int64>("id")
    static let lastname = Expression<String>("lastname")
    static let firstname = Expression<String>("firstname")
    static let birthdate = Expression<String>("birthdate")
    static let email = Expression<String>("email")
    static let pwd = Expression<String>("pwd")
    static let pwdSalt = Expression<String>("pwd_salt")
    static let insuranceNumber = Expression<String>("insurance_number")
    static let addressId = Expression<Int64>("address_id")
    static let lastLogin = Expression<String>("last_login")
    static let picture = Expression<String>("picture")
    
    override init() {}

    // Create a new patient in the database
    func createPatient(patient: Patient) -> Bool {
        var p: Patient = AddressDatabaseHelper().insertAddress(resident: patient) as! Patient
        
        // Check if the address was correctly added to the database
        if p.GetAddressId() == -1 { return false }
        
        p = self.insertPatient(patient: p)
        
        // Check if the patient was correctly added to the database
        if p.getId() == -1 { return false }
        
        p = BookingDatabaseHelper().insertBookings(resident: p) as! Patient
        
        return true
    }
    
    // Insert a new patient in the database
    private func insertPatient(patient: Patient) -> Patient {
        self.initDb()
        
        let query = PatientDatabaseHelper.table.insert(
            PatientDatabaseHelper.lastname <- patient.getLastname(),
            PatientDatabaseHelper.firstname <- patient.getFirstname(),
            PatientDatabaseHelper.birthdate <- patient.getBirthdate(),
            PatientDatabaseHelper.email <- patient.getEmail(),
            PatientDatabaseHelper.pwd <- patient.getPwd(),
            PatientDatabaseHelper.pwdSalt <- patient.getPwdSalt(),
            PatientDatabaseHelper.insuranceNumber <- patient.getInsuranceNumber(),
            PatientDatabaseHelper.addressId <- Int64(patient.GetAddressId()),
            PatientDatabaseHelper.lastLogin <- patient.getLastLogin(),
            PatientDatabaseHelper.picture <- patient.getPicture() == nil ? "" : patient.getPicture()!
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
        self.initDb()
        
        let filter = PatientDatabaseHelper.table.filter(PatientDatabaseHelper.id == Int64(patient.getId()))
        let query = filter.update(
            PatientDatabaseHelper.lastname <- patient.getLastname(),
            PatientDatabaseHelper.firstname <- patient.getFirstname(),
            PatientDatabaseHelper.birthdate <- patient.getBirthdate(),
            PatientDatabaseHelper.email <- patient.getEmail(),
            PatientDatabaseHelper.pwd <- patient.getPwd(),
            PatientDatabaseHelper.pwdSalt <- patient.getPwdSalt(),
            PatientDatabaseHelper.insuranceNumber <- patient.getInsuranceNumber(),
            PatientDatabaseHelper.addressId <- Int64(patient.GetAddressId()),
            PatientDatabaseHelper.lastLogin <- patient.getLastLogin(),
            PatientDatabaseHelper.picture <- patient.getPicture() == nil ? "" : patient.getPicture()!
        )
        
        do {
            if self.getPatient(patientId: patient.getId(), email: nil, fromDoctor: false) != nil {
                if try self.database.run(query) > 0 {
                    print("Patient update succeeded.")
                    
                    return true
                }
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
        self.initDb()
        
        let filter = PatientDatabaseHelper.table.filter(PatientDatabaseHelper.id == Int64(patient.getId()))
        let query = filter.delete()
        
        do {
            if self.getPatient(patientId: patient.getId(), email: nil, fromDoctor: false) != nil {
                if try self.database.run(query) > 0 {
                    print("Patient removal succeeded for patient: " + patient.getFullname())
                    
                    return true
                }
            }
            
            print("Patient removal failed for patient: " + patient.getFullname())
        } catch {
            print("Patient removal failed for patient: " + patient.getFullname())
        }
        
        return false
    }
    
    // Retrieve a patient by its id
    func getPatient(patientId: Int?, email: String?, fromDoctor: Bool) -> Patient? {
        self.initDb()
        
        var query: Table? = nil
        
        if patientId != nil {
            query = PatientDatabaseHelper.table
                .select(PatientDatabaseHelper.table[*])
                .filter(PatientDatabaseHelper.id == Int64(patientId!))
        } else if email != nil {
            query = PatientDatabaseHelper.table
                .select(PatientDatabaseHelper.table[*])
                .filter(PatientDatabaseHelper.email == email!)
        }
        
        do {
            for p in try self.database.prepare(query!) {
                var pId: Int
                var pEmail: String
                
                if patientId == nil { pId = try Int(p.get(PatientDatabaseHelper.id)) } else { pId = patientId! }
                if email == nil { pEmail = try p.get(PatientDatabaseHelper.email) } else { pEmail = email! }
                
                let patient: Patient = Patient(
                    id: pId,
                    lastname: try p.get(PatientDatabaseHelper.lastname),
                    firstname: try p.get(PatientDatabaseHelper.firstname),
                    email: pEmail,
                    pwd: try p.get(PatientDatabaseHelper.pwd),
                    pwdSalt: try p.get(PatientDatabaseHelper.pwdSalt),
                    lastLogin: try p.get(PatientDatabaseHelper.lastLogin),
                    picture: try p.get(PatientDatabaseHelper.picture),
                    address: nil,
                    birthdate: try p.get(PatientDatabaseHelper.birthdate),
                    insuranceNumber: try p.get(PatientDatabaseHelper.insuranceNumber)
                )
                
                let address: Address? = AddressDatabaseHelper().getAddress(addressId: Int(try p.get(PatientDatabaseHelper.addressId)))
                
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
