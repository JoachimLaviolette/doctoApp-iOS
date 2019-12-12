//
//  PaymentOptionDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class PaymentOptionDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "payment_option"
    static let table = Table("payment_option")
    
    // Fields
    private let doctorId = Expression<Int64>("doctor_id")
    private let paymentOption = Expression<String>("payment_option")
    
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
                .appendingPathComponent(PaymentOptionDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
            
            let createTable = PaymentOptionDatabaseHelper.table.create { table in
                table.column(self.doctorId)
                table.column(self.paymentOption)
                
                // Alter table
                table.primaryKey(
                    self.doctorId,
                    self.paymentOption
                )
                
                table.foreignKey(
                    self.doctorId,
                    references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
            }
            
            do {
                try self.database.run(createTable)
                print (PaymentOptionDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(PaymentOptionDatabaseHelper.table.drop())
        } catch {}
    }
}
