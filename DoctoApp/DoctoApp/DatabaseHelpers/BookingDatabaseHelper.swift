//
//  BookingDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class BookingDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "booking"
    static let table = Table("booking")
    
    // Fields
    static let id = Expression<Int64>("id")
    private let patientId = Expression<Int64>("patient_id")
    private let doctorId = Expression<Int64>("doctor_id")
    private let reasonId = Expression<Int64>("reason_id")
    private let fullDate = Expression<String>("full_date")
    private let date = Expression<String>("date")
    private let time = Expression<String>("time")
    private let bookingDate = Expression<String>("bookingDate")
    
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
                .appendingPathComponent(BookingDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
            
            let createTable = BookingDatabaseHelper.table.create { table in
                table.column(BookingDatabaseHelper.id, primaryKey: .autoincrement)
                table.column(self.patientId)
                table.column(self.doctorId)
                table.column(self.reasonId)
                table.column(self.fullDate)
                table.column(self.date)
                table.column(self.time)
                table.column(self.bookingDate)
                
                // Alter table
                table.unique([
                    self.patientId,
                    self.doctorId,
                    self.reasonId,
                    self.date,
                    self.time
                ])
                
                table.foreignKey(
                    self.patientId,
                    references: PatientDatabaseHelper.table, PatientDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
                
                table.foreignKey(
                    self.doctorId,
                    references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
                
                table.foreignKey(
                    self.reasonId,
                    references: ReasonDatabaseHelper.table, ReasonDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
            }
            
            do {
                try self.database.run(createTable)
                print (BookingDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(BookingDatabaseHelper.table.drop())
        } catch {}
    }
}
