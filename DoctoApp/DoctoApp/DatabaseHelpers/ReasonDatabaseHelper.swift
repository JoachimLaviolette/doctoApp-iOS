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
    
    // Insert all the reasons of the given doctor in the database
    func insertReasons(doctor: Doctor) -> Doctor {
        for reason: Reason in doctor.getReasons()! {
            self.insertReason(reason: reason, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new reason in the database related to the given doctor
    private func insertReason(reason: Reason, doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let query = ReasonDatabaseHelper.table.insert(
            self.doctorId <- Int64(doctor.getId()),
            self.description <- reason.getDescription()
        )
        
        do {
            let reasonId: Int = Int(try self.database.run(query))
            doctor.SetReasonId(reason: reason, reasonId: reasonId)
            print("Reason insertion succeeded for doctor: " + doctor.getFullname())
            
            return true
        } catch {
            print("Reason insertion failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Update the reasons of the given doctor in the database
    func updateReasons(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        for reason in doctor.getReasons()! {
            if !self.updateReason(reason: reason) {
                if !self.insertReason(reason: reason, doctor: doctor) {
                    return false
                }
            }
        }
        
        return true
    }
    
    // Update the given reason in the database
    private func updateReason(reason: Reason) -> Bool {
        self.initTableConfig()

        let filter = ReasonDatabaseHelper.table.filter(ReasonDatabaseHelper.id == Int64(reason.getId()))
        let query = filter.update(
            self.description <- reason.getDescription()
        )
        
        do {
            if try self.database.run(query) > 0 {
                print("Reason update succeeded.")
                
                return true
            }
            
            print("Reason update succeeded.")
        } catch {
            print("Reason update succeeded.")
        }
        
        return false
    }
    
    // Drop all the reasons related to the given doctor from the database
    private func dropReasons(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let filter = ReasonDatabaseHelper.table.filter(self.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
                print("Reasons removal succeeded for doctor: " + doctor.getFullname())
                
                return true
            }
            
            print("Reasons removal failed for doctor: " + doctor.getFullname())
        } catch {
            print("Reasons removal failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Retrieve all reasons related to the given doctor
    func getReasons(doctor: Doctor) -> [Reason] {
        var reasons: [Reason] = []
        
        self.initTableConfig()
        
        let query = ReasonDatabaseHelper.table
            .select(ReasonDatabaseHelper.table[*])
            .filter(self.doctorId == Int64(doctor.getId()))
        
        do {
            for reason in try self.database.prepare(query) {
                reasons.append(
                    Reason(
                        id: Int(try reason.get(ReasonDatabaseHelper.id)),
                        doctor: doctor,
                        description: try reason.get(self.description)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching reasons data.")
        }
        
        return reasons
    }
    
    // Retrieve an reason by its id
    func getReason(reasonId: Int) -> Reason? {
        self.initTableConfig()
        
        let query = ReasonDatabaseHelper.table
            .select(ReasonDatabaseHelper.table[*])
            .filter(ReasonDatabaseHelper.id == Int64(reasonId))
        
        do {
            for reason in try self.database.prepare(query) {
                return Reason(
                    id: Int(try reason.get(ReasonDatabaseHelper.id)),
                    doctor: nil,
                    description: try reason.get(self.description)
                )
            }
        } catch {
            print("Something went wrong when fetching reason data.")
        }
        
        return nil
    }
}
