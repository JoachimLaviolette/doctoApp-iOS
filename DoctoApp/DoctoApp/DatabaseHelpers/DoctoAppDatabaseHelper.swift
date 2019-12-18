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
    let addressDbHelper: AddressDatabaseHelper = AddressDatabaseHelper()
    let doctorDbHelper: DoctorDatabaseHelper = DoctorDatabaseHelper()
    let availabilityDbHelper: AvailabilityDatabaseHelper = AvailabilityDatabaseHelper()
    let educationDbHelper: EducationDatabaseHelper = EducationDatabaseHelper()
    let experienceDbHelper: ExperienceDatabaseHelper = ExperienceDatabaseHelper()
    let languageDbHelper: LanguageDatabaseHelper = LanguageDatabaseHelper()
    let patientDbHelper: PatientDatabaseHelper = PatientDatabaseHelper()
    let paymentOptionDbHelper: PaymentOptionDatabaseHelper = PaymentOptionDatabaseHelper()
    let reasonDbHelper: ReasonDatabaseHelper = ReasonDatabaseHelper()
    let bookingDbHelper: BookingDatabaseHelper = BookingDatabaseHelper()
    
    init() {
        self.initTables()
        // self.dropTables()
        self.createTables()
    }
    
    private func initTables() {
        self.addressDbHelper.initTableConfig()
        self.doctorDbHelper.initTableConfig()
        self.availabilityDbHelper.initTableConfig()
        self.educationDbHelper.initTableConfig()
        self.experienceDbHelper.initTableConfig()
        self.languageDbHelper.initTableConfig()
        self.patientDbHelper.initTableConfig()
        self.paymentOptionDbHelper.initTableConfig()
        self.reasonDbHelper.initTableConfig()
        self.bookingDbHelper.initTableConfig()
    }
    
    private func dropTables() {
        self.addressDbHelper.dropTable()
        self.doctorDbHelper.dropTable()
        self.availabilityDbHelper.dropTable()
        self.educationDbHelper.dropTable()
        self.experienceDbHelper.dropTable()
        self.languageDbHelper.dropTable()
        self.patientDbHelper.dropTable()
        self.paymentOptionDbHelper.dropTable()
        self.reasonDbHelper.dropTable()
        self.bookingDbHelper.dropTable()
    }
    
    private func createTables() {
        self.addressDbHelper.createTable()
        self.doctorDbHelper.createTable()
        self.availabilityDbHelper.createTable()
        self.educationDbHelper.createTable()
        self.experienceDbHelper.createTable()
        self.languageDbHelper.createTable()
        self.patientDbHelper.createTable()
        self.paymentOptionDbHelper.createTable()
        self.reasonDbHelper.createTable()
        self.bookingDbHelper.createTable()
    }
}
