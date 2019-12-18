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

class AvailabilityDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "availability"
    static let table = Table("availability")
    
    // Fields
    static let doctorId = Expression<Int64>("doctor_id")
    static let date = Expression<String>("date")
    static let time = Expression<String>("time")
    
    override init() {}
    
    // Insert all the availabilities of the given doctor in the database
    func insertAvailabilities(doctor: Doctor) -> Doctor {
        for availability: Availability in (doctor.getAvailabilities())! {
            self.insertAvailability(availability: availability, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new availability in the database related to the given doctor
    private func insertAvailability(availability: Availability, doctor: Doctor) {
        self.initDb()
        
        let query = AvailabilityDatabaseHelper.table.insert(
            AvailabilityDatabaseHelper.doctorId <- Int64(doctor.getId()),
            AvailabilityDatabaseHelper.date <- availability.getDate(),
            AvailabilityDatabaseHelper.time <- availability.getTime()
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
        self.initDb()
        
        if self.dropAvailabilities(doctor: doctor) {
            let _ = self.insertAvailabilities(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the availabilities related to the given doctor from the database
    private func dropAvailabilities(doctor: Doctor) -> Bool {
        self.initDb()
        
        let filter = AvailabilityDatabaseHelper.table.filter(AvailabilityDatabaseHelper.doctorId == Int64(doctor.getId()))
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
        
        self.initDb()
        
        let query = AvailabilityDatabaseHelper.table
            .select(AvailabilityDatabaseHelper.table[*])
            .filter(AvailabilityDatabaseHelper.doctorId == Int64(doctor.getId()))
        
        do {
            for availability in try self.database.prepare(query) {
                availabilities.append(
                    Availability(
                        doctor: doctor,
                        date: try availability.get(AvailabilityDatabaseHelper.date),
                        time: try availability.get(AvailabilityDatabaseHelper.time)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching availabilities data.")
        }
        
        return availabilities
    }
}
