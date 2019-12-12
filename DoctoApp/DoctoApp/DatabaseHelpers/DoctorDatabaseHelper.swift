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
    private let addressId = Expression<Int64>("address_id")
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
                    references: AddressDatabaseHelper.table, AddressDatabaseHelper.id,
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
}
