//
//  ExperienceDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class ExperienceDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "experience"
    static let table = Table("experience")
    
    // Fields
    private let doctorId = Expression<Int64>("doctor_id")
    private let year = Expression<String>("year")
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
                .appendingPathComponent(ExperienceDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
            
            let createTable = ExperienceDatabaseHelper.table.create { table in
                table.column(self.doctorId)
                table.column(self.year)
                table.column(self.description)
                
                // Alter table
                table.primaryKey(
                    self.doctorId,
                    self.year,
                    self.description
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
                print (ExperienceDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(ExperienceDatabaseHelper.table.drop())
        } catch {}
    }
    
    // Insert all the experiences of the given doctor in the database
    func insertExperiences(doctor: Doctor) -> Doctor {
        for experience: Experience in doctor.getExperiences()! {
            self.insertExperience(experience: experience, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new experience in the database related to the given doctor
    private func insertExperience(experience: Experience, doctor: Doctor) {
        self.initTableConfig()
        
        let query = ExperienceDatabaseHelper.table.insert(
            self.doctorId <- Int64(doctor.getId()),
            self.year <- experience.getYear(),
            self.description <- experience.getDescription()
        )
        
        do {
            try self.database.run(query)
            print("Experience insertion succeeded for doctor: " + doctor.getFullname())
        } catch {
            print("Experience insertion failed for doctor: " + doctor.getFullname())
        }
    }
    
    // Update the experiences of the given doctor in the database
    func updateExperiences(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        if self.dropExperiences(doctor: doctor) {
            let _ = self.insertExperiences(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the experiences related to the given doctor from the database
    private func dropExperiences(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let filter = ExperienceDatabaseHelper.table.filter(self.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
                print("Experiences removal succeeded for doctor: " + doctor.getFullname())
                
                return true
            }
            
            print("Experiences removal failed for doctor: " + doctor.getFullname())
        } catch {
            print("Experiences removal failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Retrieve all experiences related to the given doctor
    func getExperiences(doctor: Doctor) -> [Experience] {
        var experiences: [Experience] = []
        
        self.initTableConfig()
        
        let query = ExperienceDatabaseHelper.table
            .select(ExperienceDatabaseHelper.table[*])
            .filter(self.doctorId == Int64(doctor.getId()))
        
        do {
            for experience in try self.database.prepare(query) {
                experiences.append(
                    Experience(
                        doctor: doctor,
                        year: try experience.get(self.year),
                        description: try experience.get(self.description)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching experiences data.")
        }
        
        return experiences
    }
}
