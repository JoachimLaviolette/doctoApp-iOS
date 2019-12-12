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
}
