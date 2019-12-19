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

class DoctorDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "doctor"
    static let table = Table("doctor")
    
    // Fields
    static let id = Expression<Int64>("id")
    static let lastname = Expression<String>("lastname")
    static let firstname = Expression<String>("firstname")
    static let speciality = Expression<String>("speciality")
    static let email = Expression<String>("email")
    static let pwd = Expression<String>("pwd")
    static let pwdSalt = Expression<String>("pwd_salt")
    static let description = Expression<String>("description")
    static let contactNumber = Expression<String>("contact_number")
    static let isUnderAgreement = Expression<Bool>("is_under_agreement")
    static let isHealthInsuranceCard = Expression<Bool>("is_health_insurance_card")
    static let isThirdPartyPayment = Expression<Bool>("is_third_party_payment")
    static let addressId = Expression<Int64>("address_id")
    static let lastLogin = Expression<String>("last_login")
    static let picture = Expression<String>("picture")
    static let header = Expression<String>("header")
    
    override init() {}
    
    // Create a new doctor in the database
    func createDoctor(doctor: Doctor) -> Bool {
        var d: Doctor = AddressDatabaseHelper().insertAddress(resident: doctor) as! Doctor
        
        // Check if the address was correctly added to the database
        if d.GetAddressId() == -1 { return false }
        
        d = self.insertDoctor(doctor: d)
        
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
    private func insertDoctor(doctor: Doctor) -> Doctor {
        self.initDb()
        
        let query = DoctorDatabaseHelper.table.insert(
            DoctorDatabaseHelper.lastname <- doctor.getLastname(),
            DoctorDatabaseHelper.firstname <- doctor.getFirstname(),
            DoctorDatabaseHelper.speciality <- doctor.getSpeciality(),
            DoctorDatabaseHelper.email <- doctor.getEmail(),
            DoctorDatabaseHelper.description <- doctor.getDescription(),
            DoctorDatabaseHelper.contactNumber <- doctor.getContactNumber(),
            DoctorDatabaseHelper.pwd <- doctor.getPwd(),
            DoctorDatabaseHelper.pwdSalt <- doctor.getPwdSalt(),
            DoctorDatabaseHelper.isUnderAgreement <- doctor.isUnderAgreement(),
            DoctorDatabaseHelper.isHealthInsuranceCard <- doctor.isHealthInsuranceCard(),
            DoctorDatabaseHelper.isThirdPartyPayment <- doctor.isThirdPartyPayment(),
            DoctorDatabaseHelper.addressId <- Int64(doctor.GetAddressId()),
            DoctorDatabaseHelper.lastLogin <- doctor.getLastLogin(),
            DoctorDatabaseHelper.picture <- doctor.getPicture() == nil ? "" : doctor.getPicture()!,
            DoctorDatabaseHelper.header <- doctor.getHeader() == nil ? "" : doctor.getHeader()!
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
        self.initDb()
        
        let filter = DoctorDatabaseHelper.table.filter(DoctorDatabaseHelper.id == Int64(doctor.getId()))
        let query = filter.update(
            DoctorDatabaseHelper.lastname <- doctor.getLastname(),
            DoctorDatabaseHelper.firstname <- doctor.getFirstname(),
            DoctorDatabaseHelper.speciality <- doctor.getSpeciality(),
            DoctorDatabaseHelper.email <- doctor.getEmail(),
            DoctorDatabaseHelper.description <- doctor.getDescription(),
            DoctorDatabaseHelper.contactNumber <- doctor.getContactNumber(),
            DoctorDatabaseHelper.pwd <- doctor.getPwd(),
            DoctorDatabaseHelper.pwdSalt <- doctor.getPwdSalt(),
            DoctorDatabaseHelper.isUnderAgreement <- doctor.isUnderAgreement(),
            DoctorDatabaseHelper.isHealthInsuranceCard <- doctor.isHealthInsuranceCard(),
            DoctorDatabaseHelper.isThirdPartyPayment <- doctor.isThirdPartyPayment(),
            DoctorDatabaseHelper.addressId <- Int64(doctor.GetAddressId()),
            DoctorDatabaseHelper.lastLogin <- doctor.getLastLogin(),
            DoctorDatabaseHelper.picture <- doctor.getPicture() == nil ? "" : doctor.getPicture()!,
            DoctorDatabaseHelper.header <- doctor.getHeader() == nil ? "" : doctor.getHeader()!
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
        self.initDb()
        
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
        let keyword = needle == nil ? "" : needle!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if keyword.isEmpty { return [] }
        
        self.initDb()
        
        let query = "SELECT doctor.id FROM doctor JOIN address ON address.id = doctor.address_id WHERE doctor.firstname LIKE '%\(keyword)%' OR doctor.lastname LIKE '%\(keyword)%' OR address.city LIKE '%\(keyword)%' OR address.street1 LIKE '%\(keyword)%' OR address.street2 LIKE '%\(keyword)%' OR address.country LIKE '%\(keyword)%'"
        
        do {
            let stmt = try self.database.prepare(query)
            for row in stmt {
                for (index, name) in stmt.columnNames.enumerated() {
                    if name == "id" {
                        doctors.append(self.getDoctor(doctorId: Int(row[index]! as! Int64), email: nil, fromPatient: false)!)
                    }
                }
            }
        } catch {
            print("Something went wrong when fetching doctors according to the following keyword: " + keyword)
        }
        
        return doctors
    }
    
    // Retrieve a doctor by its id
    func getDoctor(doctorId: Int?, email: String?, fromPatient: Bool) -> Doctor? {
        self.initDb()
        
        var query: Table? = nil
        
        if doctorId != nil {
            query = DoctorDatabaseHelper.table
                .select(DoctorDatabaseHelper.table[*])
                .filter(DoctorDatabaseHelper.id == Int64(doctorId!))
        } else if email != nil {
            query = DoctorDatabaseHelper.table
                .select(DoctorDatabaseHelper.table[*])
                .filter(DoctorDatabaseHelper.email == email!)
        }
        
        do {
            for d in try self.database.prepare(query!) {
                var dId: Int
                var dEmail: String
                
                if doctorId == nil { dId = try Int(d.get(DoctorDatabaseHelper.id)) } else { dId = doctorId! }
                if email == nil { dEmail = try d.get(DoctorDatabaseHelper.email) } else { dEmail = email! }
                
                let doctor: Doctor = Doctor(
                    id: dId,
                    lastname: try d.get(DoctorDatabaseHelper.lastname),
                    firstname: try d.get(DoctorDatabaseHelper.firstname),
                    email: dEmail,
                    pwd: try d.get(DoctorDatabaseHelper.pwd),
                    pwdSalt: try d.get(DoctorDatabaseHelper.pwdSalt),
                    lastLogin: try d.get(DoctorDatabaseHelper.lastLogin),
                    picture: try d.get(DoctorDatabaseHelper.picture),
                    address: nil,
                    speciality: try d.get(DoctorDatabaseHelper.speciality),
                    description: try d.get(DoctorDatabaseHelper.description),
                    contactNumber: try d.get(DoctorDatabaseHelper.contactNumber),
                    underAgreement: try d.get(DoctorDatabaseHelper.isUnderAgreement),
                    healthInsuranceCard: try d.get(DoctorDatabaseHelper.isHealthInsuranceCard),
                    thirdPartyPayment: try d.get(DoctorDatabaseHelper.isThirdPartyPayment),
                    header: try d.get(DoctorDatabaseHelper.header)
                )
                
                let address: Address? = AddressDatabaseHelper().getAddress(addressId: Int(try d.get(DoctorDatabaseHelper.addressId)))
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
