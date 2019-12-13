//
//  DoctorDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class DoctorDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "doctor"
    static let table = Table("doctor")
    
    // Fields
    static let id = Expression<Int64>("id")
    private let lastname = Expression<String>("lastname")
    private let firstname = Expression<String>("firstname")
    private let speciality = Expression<String>("speciality")
    private let email = Expression<String>("email")
    private let pwd = Expression<String>("pwd")
    private let pwdSalt = Expression<String>("pwd_salt")
    private let description = Expression<String>("description")
    private let contactNumber = Expression<String>("contact_number")
    private let isUnderAgreement = Expression<Bool>("is_under_agreement")
    private let isHealthInsuranceCard = Expression<Bool>("is_health_insurance_card")
    private let isThirdPartyPayment = Expression<Bool>("is_third_party_payment")
    private let addressId = Expression<Int64>("doctor_id")
    private let lastLogin = Expression<String>("last_login")
    private let picture = Expression<String>("picture")
    private let header = Expression<String>("header")
    
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
                .appendingPathComponent(DoctorDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
            
            let createTable = DoctorDatabaseHelper.table.create { table in
                table.column(DoctorDatabaseHelper.id, primaryKey: .autoincrement)
                table.column(self.lastname)
                table.column(self.firstname)
                table.column(self.speciality)
                table.column(self.email)
                table.column(self.pwd)
                table.column(self.pwdSalt)
                table.column(self.description)
                table.column(self.contactNumber)
                table.column(self.isUnderAgreement)
                table.column(self.isHealthInsuranceCard)
                table.column(self.isThirdPartyPayment)
                table.column(self.addressId, unique: true)
                table.column(self.lastLogin)
                table.column(self.picture)
                table.column(self.header)
                
                // Alter table
                table.foreignKey(
                    self.addressId,
                    references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
            }
            
            do {
                try self.database.run(createTable)
                print (DoctorDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(DoctorDatabaseHelper.table.drop())
        } catch {}
    }
    
    // Create a new doctor in the database
    func createDoctor(doctor: Doctor) -> Bool {
        var d: Doctor = AddressDatabaseHelper().insertAddress(resident: doctor) as! Doctor
        
        // Check if the address was correctly added to the database
        if d.GetAddressId() == -1 { return false }
        
        d = self.insertDoctor(doctor: d) as! Doctor
        
        // Check if the doctor was correctly added to the database
        if d.getId() == -1 { return false }
        
        d = AvailabilityDatabaseHelper().insertAvailabilities(doctor: d)
        d = EducationDatabaseHelper().insertEducations(doctor: d)
        d = ExperienceDatabaseHelper().insertExperiences(doctor: d)
        d = LanguageDatabaseHelper().insertLanguages(doctor: d)
        d = PaymentOptionDatabaseHelper().insertPaymentOptions(doctor: d)
        d = ReasonDatabaseHelper().insertReasons(doctor: d)
        d = BookingDatabaseHelper().insertBookings(resident: d) as! Doctor
        
        return true
    }
    
    // Insert a new doctor in the database
    private func insertDoctor(doctor: Doctor) -> Resident {
        self.initTableConfig()
        
        let query = DoctorDatabaseHelper.table.insert(
            DoctorDatabaseHelper.id <- Int64(doctor.getId()),
            self.lastname <- doctor.getLastname(),
            self.firstname <- doctor.getFirstname(),
            self.speciality <- doctor.getSpeciality(),
            self.email <- doctor.getEmail(),
            self.description <- doctor.getDescription(),
            self.contactNumber <- doctor.getContactNumber(),
            self.pwd <- doctor.getPwd(),
            self.pwdSalt <- doctor.getPwdSalt(),
            self.isUnderAgreement <- doctor.isUnderAgreement(),
            self.isHealthInsuranceCard <- doctor.isHealthInsuranceCard(),
            self.isThirdPartyPayment <- doctor.isThirdPartyPayment(),
            self.addressId <- Int64(doctor.GetAddressId()),
            self.lastLogin <- doctor.getLastLogin(),
            self.picture <- doctor.getPicture() == nil ? "" : doctor.getPicture()!,
            self.header <- doctor.getHeader() == nil ? "" : doctor.getHeader()!
        )
        
        do {
            let doctorId: Int = Int(try self.database.run(query))
            doctor.setId(id: doctorId)
            print("Doctor insertion succeeded for doctor: " + doctor.getFullname())
        } catch {
            print("Doctor insertion failed for doctor: " + doctor.getFullname())
        }
        
        return doctor
    }
    
    // Update the given doctor data in the database
    private func updateDoctorData(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let filter = DoctorDatabaseHelper.table.filter(DoctorDatabaseHelper.id == Int64(doctor.getId()))
        let query = filter.update(
            self.lastname <- doctor.getLastname(),
            self.firstname <- doctor.getFirstname(),
            self.speciality <- doctor.getSpeciality(),
            self.email <- doctor.getEmail(),
            self.description <- doctor.getDescription(),
            self.contactNumber <- doctor.getContactNumber(),
            self.pwd <- doctor.getPwd(),
            self.pwdSalt <- doctor.getPwdSalt(),
            self.isUnderAgreement <- doctor.isUnderAgreement(),
            self.isHealthInsuranceCard <- doctor.isHealthInsuranceCard(),
            self.isThirdPartyPayment <- doctor.isThirdPartyPayment(),
            self.addressId <- Int64(doctor.GetAddressId()),
            self.lastLogin <- doctor.getLastLogin(),
            self.picture <- doctor.getPicture() == nil ? "" : doctor.getPicture()!,
            self.header <- doctor.getHeader() == nil ? "" : doctor.getHeader()!
        )
        
        do {
            if try self.database.run(query) > 0 {
                print("Doctor update succeeded.")
                
                return true
            }
            
            print("Doctor update failed.")
        } catch {
            print("Doctor update failed.")
        }
        
        return false
    }
    
    // Update the given doctor in the database
    func updateDoctor(doctor: Doctor) -> Bool {
        if !AddressDatabaseHelper().updateAddress(resident: doctor) { return false }
        if !self.updateDoctorData(doctor: doctor) { return false }
        if !AvailabilityDatabaseHelper().updateAvailabilities(doctor: doctor) { return false }
        if !EducationDatabaseHelper().updateEducations(doctor: doctor) { return false }
        if !ExperienceDatabaseHelper().updateExperiences(doctor: doctor) { return false }
        if !LanguageDatabaseHelper().updateLanguages(doctor: doctor) { return false }
        if !PaymentOptionDatabaseHelper().updatePaymentOptions(doctor: doctor) { return false }
        return ReasonDatabaseHelper().updateReasons(doctor: doctor)
    }
    
    // Delete the given doctor from the database
    func deleteDoctor(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let filter = DoctorDatabaseHelper.table.filter(DoctorDatabaseHelper.id == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
                print("Doctor removal succeeded for doctor: " + doctor.getFullname())
                
                return true
            }
            
            print("Doctor removal failed for doctor: " + doctor.getFullname())
        } catch {
            print("Doctor removal failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Get all the doctors whose data match with the given needle
    // The search is made on the following fields:
    // - Doctor lastname
    // - Doctor firstname
    // - Doctor firstname
    // - Doctor's address city
    // - Doctor's address street1
    // - Doctor's address street2
    // - Doctor's address country
    func getDoctors(needle: String?) -> [Doctor] {
        var doctors: [Doctor] = []
        let keyword = needle == nil ? "" : needle!
        
        self.initTableConfig()
        
        let query = DoctorDatabaseHelper.table
            .join(AddressDatabaseHelper.table, on: DoctorDatabaseHelper.table[self.addressId] == AddressDatabaseHelper.id)
            .filter(
                DoctorDatabaseHelper.table[self.lastname].like("%" + keyword + "%")
                || DoctorDatabaseHelper.table[self.lastname].like("%" + keyword + "%")
                || DoctorDatabaseHelper.table[self.firstname].like("%" + keyword + "%")
                || AddressDatabaseHelper.table[AddressDatabaseHelper.city].like("%" + keyword + "%")
                || AddressDatabaseHelper.table[AddressDatabaseHelper.street1].like("%" + keyword + "%")
                || AddressDatabaseHelper.table[AddressDatabaseHelper.street2].like("%" + keyword + "%")
                || AddressDatabaseHelper.table[AddressDatabaseHelper.country].like("%" + keyword + "%")
            )
        
        do {
            for doctor in try self.database.prepare(query) {
                doctors.append(self.getDoctor(doctorId: Int(try doctor.get(DoctorDatabaseHelper.id)), email: nil, fromPatient: false)!)
            }
        } catch {
            print("Something went wrong when fetching doctors according to the following keyword: " + keyword)
        }
        
        return doctors
    }
    
    // Retrieve an doctor by its id
    func getDoctor(doctorId: Int?, email: String?, fromPatient: Bool) -> Doctor? {
        self.initTableConfig()
        
        var query: Table? = nil
        
        if doctorId != nil {
            query = DoctorDatabaseHelper.table
                .select(DoctorDatabaseHelper.table[*])
                .filter(DoctorDatabaseHelper.id == Int64(doctorId!))
        } else if email != nil {
            query = DoctorDatabaseHelper.table
                .select(DoctorDatabaseHelper.table[*])
                .filter(self.email == email!)
        }
        
        do {
            for d in try self.database.prepare(query!) {
                // let doctorData: Dictionary<String, Any> = Dictionary<String, Any>()
                let doctor: Doctor = Doctor(
                    id: doctorId!,
                    lastname: try d.get(self.lastname),
                    firstname: try d.get(self.firstname),
                    email: try d.get(self.email),
                    pwd: try d.get(self.pwd),
                    pwdSalt: try d.get(self.pwdSalt),
                    lastLogin: try d.get(self.lastLogin),
                    picture: try d.get(self.picture),
                    address: nil,
                    speciality: try d.get(self.speciality),
                    description: try d.get(self.description),
                    contactNumber: try d.get(self.contactNumber),
                    underAgreement: try d.get(self.isUnderAgreement),
                    healthInsuranceCard: try d.get(self.isHealthInsuranceCard),
                    thirdPartyPayment: try d.get(self.isThirdPartyPayment),
                    header: try d.get(self.header)
                )
                
                let address: Address? = AddressDatabaseHelper().getAddress(addressId: Int(try d.get(self.addressId)))
                let availabilities: [Availability] = AvailabilityDatabaseHelper().getAvailabilities(doctor: doctor)
                let languages: [Language] = LanguageDatabaseHelper().getLanguages(doctor: doctor)
                let paymentOptions: [PaymentOption] = PaymentOptionDatabaseHelper().getPaymentOptions(doctor: doctor)
                let reasons: [Reason] = ReasonDatabaseHelper().getReasons(doctor: doctor)
                let educations: [Education] = EducationDatabaseHelper().getEducations(doctor: doctor)
                let experiences: [Experience] = ExperienceDatabaseHelper().getExperiences(doctor: doctor)
                
                doctor.setAddress(address: address)
                doctor.setAvailabilities(availabilities: availabilities)
                doctor.setLanguages(languages: languages)
                doctor.setPaymentOptions(paymentOptions: paymentOptions)
                doctor.setReasons(reasons: reasons)
                doctor.setEducations(educations: educations)
                doctor.setExperiences(experiences: experiences)
                
                if !fromPatient {
                    let bookings: [Booking] = BookingDatabaseHelper().getBookings(doctor: doctor)
                    doctor.setBookings(bookings: bookings)
                }
                
                return doctor
            }
        } catch {
            print("Something went wrong when fetching doctor data.")
        }
        
        return nil
    }
}
