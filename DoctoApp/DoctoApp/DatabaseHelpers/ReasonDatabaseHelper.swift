//
//  ReasonDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class ReasonDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "reason"
    static let table = Table("reason")
    
    // Fields
    static let id = Expression<Int64>("id")
    private let doctorId = Expression<Int64>("doctor_id")
    private let description = Expression<String>("description")
    
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
                .appendingPathComponent(ReasonDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
            
            let createTable = ReasonDatabaseHelper.table.create { table in
                table.column(ReasonDatabaseHelper.id, primaryKey: .autoincrement)
                table.column(self.doctorId)
                table.column(self.description)
                
                // Alter table
                table.foreignKey(
                    self.doctorId,
                    references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
            }
            
            do {
                try self.database.run(createTable)
                print (ReasonDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(ReasonDatabaseHelper.table.drop())
        } catch {}
    }
}
