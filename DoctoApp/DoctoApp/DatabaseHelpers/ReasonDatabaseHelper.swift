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

class ReasonDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "reason"
    static let table = Table("reason")
    
    // Fields
    static let id = Expression<Int64>("id")
    static let doctorId = Expression<Int64>("doctor_id")
    static let description = Expression<String>("description")
    
    override init() {}
    
    // Insert all the reasons of the given doctor in the database
    func insertReasons(doctor: Doctor) -> Doctor {
        for reason: Reason in doctor.getReasons()! {
            self.insertReason(reason: reason, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new reason in the database related to the given doctor
    private func insertReason(reason: Reason, doctor: Doctor) -> Bool {
        self.initDb()
        
        let query = ReasonDatabaseHelper.table.insert(
            ReasonDatabaseHelper.doctorId <- Int64(doctor.getId()),
            ReasonDatabaseHelper.description <- reason.getDescription()
        )
        
        do {
            let reasonId: Int = Int(try self.database.run(query))
            reason.setId(id: reasonId)
            doctor.SetReasonId(reason: reason, reasonId: reasonId)
                
            if reasonId != -1 {
                print("Reason insertion succeeded for doctor: " + doctor.getFullname())
                
                return true
            }
            
            print("Reason insertion failed for doctor: " + doctor.getFullname())
        } catch {
            print("Reason insertion failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Update the reasons of the given doctor in the database
    func updateReasons(doctor: Doctor) -> Bool {
        self.initDb()
        
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
        self.initDb()

        let filter = ReasonDatabaseHelper.table.filter(ReasonDatabaseHelper.id == Int64(reason.getId()))
        let query = filter.update(
            ReasonDatabaseHelper.description <- reason.getDescription()
        )
        
        do {
            if self.getReason(reasonId: reason.getId()) != nil {
                if try self.database.run(query) > 0 {
                    print("Reason update succeeded.")
                    
                    return true
                }
            }
            
            print("Reason update succeeded.")
        } catch {
            print("Reason update succeeded.")
        }
        
        return false
    }
    
    // Drop all the reasons related to the given doctor from the database
    private func dropReasons(doctor: Doctor) -> Bool {
        self.initDb()
        
        let filter = ReasonDatabaseHelper.table.filter(ReasonDatabaseHelper.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            let doctorReasonsCount: Int = self.getReasons(doctor: doctor).count
            let queryResult: Int = try self.database.run(query)
            
            if (doctorReasonsCount > 0 && queryResult > 0)
                || (doctorReasonsCount == 0 && queryResult == 0)  {
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
        
        self.initDb()
        
        let query = ReasonDatabaseHelper.table
            .select(ReasonDatabaseHelper.table[*])
            .filter(ReasonDatabaseHelper.doctorId == Int64(doctor.getId()))
        
        do {
            for reason in try self.database.prepare(query) {
                reasons.append(
                    Reason(
                        id: Int(try reason.get(ReasonDatabaseHelper.id)),
                        doctor: doctor,
                        description: try reason.get(ReasonDatabaseHelper.description)
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
        self.initDb()
        
        let query = ReasonDatabaseHelper.table
            .select(ReasonDatabaseHelper.table[*])
            .filter(ReasonDatabaseHelper.id == Int64(reasonId))
        
        do {
            for reason in try self.database.prepare(query) {
                return Reason(
                    id: Int(try reason.get(ReasonDatabaseHelper.id)),
                    doctor: nil,
                    description: try reason.get(ReasonDatabaseHelper.description)
                )
            }
        } catch {
            print("Something went wrong when fetching reason data.")
        }
        
        return nil
    }
}
