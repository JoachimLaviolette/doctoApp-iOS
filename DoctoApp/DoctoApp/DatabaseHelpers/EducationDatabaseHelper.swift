//
//  EducationDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class EducationDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "education"
    static let table = Table("education")
    
    // Fields
    private let doctorId = Expression<Int64>("doctor_id")
    private let year = Expression<String>("year")
    private let degree = Expression<String>("degree")
    
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
                .appendingPathComponent(EducationDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
                        
            let createTable = EducationDatabaseHelper.table.create { table in
                table.column(self.doctorId)
                table.column(self.year)
                table.column(self.degree)
                
                // Alter table
                table.primaryKey(
                    self.doctorId,
                    self.year,
                    self.degree
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
                print (EducationDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(EducationDatabaseHelper.table.drop())
        } catch {}
    }
}
