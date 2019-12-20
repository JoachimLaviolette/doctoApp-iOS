//
//  DoctoAppDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class DoctoAppDatabaseHelper {
    var database: Connection!
    private static let dbName = "DoctoAppDatabase"
    
    init() {}
    
    func initDatabase() {
        self.dropTables()
        self.createTables()
    }
    
    func initDb() {
        if self.database != nil { return }
        
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            let fileUrl = documentDirectory
                .appendingPathComponent(DoctoAppDatabaseHelper.dbName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    private func dropTables() {
        self.initDb()
        
        do {
            try self.database.run(AddressDatabaseHelper.table.drop())
            try self.database.run(DoctorDatabaseHelper.table.drop())
            try self.database.run(AvailabilityDatabaseHelper.table.drop())
            try self.database.run(EducationDatabaseHelper.table.drop())
            try self.database.run(ExperienceDatabaseHelper.table.drop())
            try self.database.run(LanguageDatabaseHelper.table.drop())
            try self.database.run(PatientDatabaseHelper.table.drop())
            try self.database.run(PaymentOptionDatabaseHelper.table.drop())
            try self.database.run(ReasonDatabaseHelper.table.drop())
            try self.database.run(BookingDatabaseHelper.table.drop())
            print("All the tables were successfully dropped.")
        } catch {
            print("One of the table was not dropped (inexistant ?)")
        }
    }
    
    private func createTables() {
        self.initDb()
        
        let createTableAddress = AddressDatabaseHelper.table.create { table in
            table.column(AddressDatabaseHelper.id, primaryKey: .autoincrement)
            table.column(AddressDatabaseHelper.street1)
            table.column(AddressDatabaseHelper.street2)
            table.column(AddressDatabaseHelper.city)
            table.column(AddressDatabaseHelper.zip)
            table.column(AddressDatabaseHelper.country)
        }
        
        let createTableDoctor = DoctorDatabaseHelper.table.create { table in
            table.column(DoctorDatabaseHelper.id, primaryKey: .autoincrement)
            table.column(DoctorDatabaseHelper.lastname)
            table.column(DoctorDatabaseHelper.firstname)
            table.column(DoctorDatabaseHelper.speciality)
            table.column(DoctorDatabaseHelper.email)
            table.column(DoctorDatabaseHelper.pwd)
            table.column(DoctorDatabaseHelper.pwdSalt)
            table.column(DoctorDatabaseHelper.description)
            table.column(DoctorDatabaseHelper.contactNumber)
            table.column(DoctorDatabaseHelper.isUnderAgreement)
            table.column(DoctorDatabaseHelper.isHealthInsuranceCard)
            table.column(DoctorDatabaseHelper.isThirdPartyPayment)
            table.column(DoctorDatabaseHelper.addressId, unique: true)
            table.column(DoctorDatabaseHelper.lastLogin)
            table.column(DoctorDatabaseHelper.picture)
            table.column(DoctorDatabaseHelper.header)
            
            // Alter table
            table.foreignKey(
                DoctorDatabaseHelper.addressId,
                references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        let createTableAvailability = AvailabilityDatabaseHelper.table.create { table in
            table.column(AvailabilityDatabaseHelper.doctorId)
            table.column(AvailabilityDatabaseHelper.date)
            table.column(AvailabilityDatabaseHelper.time)
            
            // Alter table
            table.primaryKey(
                AvailabilityDatabaseHelper.doctorId,
                AvailabilityDatabaseHelper.date,
                AvailabilityDatabaseHelper.time
            )
            
            table.foreignKey(
                AvailabilityDatabaseHelper.doctorId,
                references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        let createTableEducation = EducationDatabaseHelper.table.create { table in
            table.column(EducationDatabaseHelper.doctorId)
            table.column(EducationDatabaseHelper.year)
            table.column(EducationDatabaseHelper.degree)
            
            // Alter table
            table.primaryKey(
                EducationDatabaseHelper.doctorId,
                EducationDatabaseHelper.year,
                EducationDatabaseHelper.degree
            )
            
            table.foreignKey(
                EducationDatabaseHelper.doctorId,
                references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        let createTableExperience = ExperienceDatabaseHelper.table.create { table in
            table.column(ExperienceDatabaseHelper.doctorId)
            table.column(ExperienceDatabaseHelper.year)
            table.column(ExperienceDatabaseHelper.description)
            
            // Alter table
            table.primaryKey(
                ExperienceDatabaseHelper.doctorId,
                ExperienceDatabaseHelper.year,
                ExperienceDatabaseHelper.description
            )
            
            table.foreignKey(
                ExperienceDatabaseHelper.doctorId,
                references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        let createTableLanguage = LanguageDatabaseHelper.table.create { table in
            table.column(LanguageDatabaseHelper.doctorId)
            table.column(LanguageDatabaseHelper.language)
            
            // Alter table
            table.primaryKey(
                LanguageDatabaseHelper.doctorId,
                LanguageDatabaseHelper.language
            )
            
            table.foreignKey(
                LanguageDatabaseHelper.doctorId,
                references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        let createTablePatient = PatientDatabaseHelper.table.create { table in
            table.column(PatientDatabaseHelper.id, primaryKey: .autoincrement)
            table.column(PatientDatabaseHelper.lastname)
            table.column(PatientDatabaseHelper.firstname)
            table.column(PatientDatabaseHelper.birthdate)
            table.column(PatientDatabaseHelper.email)
            table.column(PatientDatabaseHelper.pwd)
            table.column(PatientDatabaseHelper.pwdSalt)
            table.column(PatientDatabaseHelper.insuranceNumber)
            table.column(PatientDatabaseHelper.addressId, unique: true)
            table.column(PatientDatabaseHelper.lastLogin)
            table.column(PatientDatabaseHelper.picture)
            
            // Alter table
            table.foreignKey(
                PatientDatabaseHelper.addressId,
                references: AddressDatabaseHelper.table, AddressDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        let createTablePaymentOption = PaymentOptionDatabaseHelper.table.create { table in
            table.column(PaymentOptionDatabaseHelper.doctorId)
            table.column(PaymentOptionDatabaseHelper.paymentOption)
            
            // Alter table
            table.primaryKey(
                PaymentOptionDatabaseHelper.doctorId,
                PaymentOptionDatabaseHelper.paymentOption
            )
            
            table.foreignKey(
                PaymentOptionDatabaseHelper.doctorId,
                references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        let createTableReason = ReasonDatabaseHelper.table.create { table in
            table.column(ReasonDatabaseHelper.id, primaryKey: .autoincrement)
            table.column(ReasonDatabaseHelper.doctorId)
            table.column(ReasonDatabaseHelper.description)
            
            // Alter table
            table.foreignKey(
                ReasonDatabaseHelper.doctorId,
                references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        let createTableBooking = BookingDatabaseHelper.table.create { table in
            table.column(BookingDatabaseHelper.id, primaryKey: .autoincrement)
            table.column(BookingDatabaseHelper.patientId)
            table.column(BookingDatabaseHelper.doctorId)
            table.column(BookingDatabaseHelper.reasonId)
            table.column(BookingDatabaseHelper.fullDate)
            table.column(BookingDatabaseHelper.date)
            table.column(BookingDatabaseHelper.time)
            table.column(BookingDatabaseHelper.bookingDate)
            
            // Alter table
            table.unique([
                BookingDatabaseHelper.patientId,
                BookingDatabaseHelper.doctorId,
                BookingDatabaseHelper.reasonId,
                BookingDatabaseHelper.date,
                BookingDatabaseHelper.time
                ])
            
            table.foreignKey(
                BookingDatabaseHelper.patientId,
                references: PatientDatabaseHelper.table, PatientDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
            
            table.foreignKey(
                BookingDatabaseHelper.doctorId,
                references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
            
            table.foreignKey(
                BookingDatabaseHelper.reasonId,
                references: ReasonDatabaseHelper.table, ReasonDatabaseHelper.id,
                update: .cascade,
                delete: .cascade
            )
        }
        
        do {
            try self.database.run(createTableAddress)
            print (AddressDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTableDoctor)
            print (DoctorDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTableAvailability)
            print (AvailabilityDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTableEducation)
            print (EducationDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTableExperience)
            print (ExperienceDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTableLanguage)
            print (LanguageDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTablePatient)
            print (PatientDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTablePaymentOption)
            print (PaymentOptionDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTableReason)
            print (ReasonDatabaseHelper.tableName + " table was successfully created.")
            
            try self.database.run(createTableBooking)
            print (BookingDatabaseHelper.tableName + " table was successfully created.")
        } catch {
            print(error)
        }
    }
}
