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
    
    // Insert all the availabilities of the given doctor in the database
    func insertAvailabilities(doctor: Doctor) -> Doctor {
        for availability: Availability in (doctor.getAvailabilities())! {
            self.insertAvailability(availability: availability, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new availability in the database related to the given doctor
    private func insertAvailability(availability: Availability, doctor: Doctor) {
        self.initTableConfig()
        
        let query = AvailabilityDatabaseHelper.table.insert(
            self.doctorId <- Int64(doctor.getId()),
            self.date <- availability.getDate(),
            self.time <- availability.getTime()
        )
        
        do {
            try self.database.run(query)
            print("Availability insertion succeeded for doctor: " + doctor.getFullname())
        } catch {
            print("Availability insertion failed for doctor: " + doctor.getFullname())
        }
    }
    
    // Update the availabilities of the given doctor in the database
    func updateAvailabilities(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        if self.dropAvailabilities(doctor: doctor) {
            let _ = self.insertAvailabilities(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the availabilities related to the given doctor from the database
    private func dropAvailabilities(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let filter = AvailabilityDatabaseHelper.table.filter(self.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
                print("Availabilities removal succeeded for doctor: " + doctor.getFullname())
                
                return true
            }
            
            print("Availabilities removal failed for doctor: " + doctor.getFullname())
        } catch {
            print("Availabilities removal failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Retrieve all availabilities related to the given doctor
    func getAvailabilities(doctor: Doctor) -> [Availability] {
        var availabilities: [Availability] = []
        
        self.initTableConfig()
        
        let query = AvailabilityDatabaseHelper.table
            .select(AvailabilityDatabaseHelper.table[*])
            .filter(self.doctorId == Int64(doctor.getId()))
        
        do {
            for availability in try self.database.prepare(query) {
                availabilities.append(
                    Availability(
                        doctor: doctor,
                        date: try availability.get(self.date),
                        time: try availability.get(self.time)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching availabilities data.")
        }
        
        return availabilities
    }
}
