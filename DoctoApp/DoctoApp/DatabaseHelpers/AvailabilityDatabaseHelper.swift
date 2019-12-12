//
//  AvailabilityDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class AvailabilityDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "availability"
    static let table = Table("availability")
    
    // Fields
    private let doctorId = Expression<Int64>("doctor_id")
    private let date = Expression<String>("date")
    private let time = Expression<String>("time")
    
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
                .appendingPathComponent(AvailabilityDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
                        
            let createTable = AvailabilityDatabaseHelper.table.create { table in
                table.column(self.doctorId)
                table.column(self.date)
                table.column(self.time)
                
                // Alter table
                table.primaryKey(
                    self.doctorId,
                    self.date,
                    self.time
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
                print (AvailabilityDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(AvailabilityDatabaseHelper.table.drop())
        } catch {}
    }
}
