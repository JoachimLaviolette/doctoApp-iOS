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

class ExperienceDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "experience"
    static let table = Table("experience")
    
    // Fields
    static let doctorId = Expression<Int64>("doctor_id")
    static let year = Expression<String>("year")
    static let description = Expression<String>("description")
    
    override init() {}
    
    // Insert all the experiences of the given doctor in the database
    func insertExperiences(doctor: Doctor) -> Doctor {
        for experience: Experience in doctor.getExperiences()! {
            self.insertExperience(experience: experience, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new experience in the database related to the given doctor
    private func insertExperience(experience: Experience, doctor: Doctor) {
        self.initDb()
        
        let query = ExperienceDatabaseHelper.table.insert(
            ExperienceDatabaseHelper.doctorId <- Int64(doctor.getId()),
            ExperienceDatabaseHelper.year <- experience.getYear(),
            ExperienceDatabaseHelper.description <- experience.getDescription()
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
        self.initDb()
        
        if self.dropExperiences(doctor: doctor) {
            let _ = self.insertExperiences(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the experiences related to the given doctor from the database
    private func dropExperiences(doctor: Doctor) -> Bool {
        self.initDb()
        
        let filter = ExperienceDatabaseHelper.table.filter(ExperienceDatabaseHelper.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            let doctorExperiencesCount: Int = self.getExperiences(doctor: doctor).count
            let queryResult: Int = try self.database.run(query)
            
            if (doctorExperiencesCount > 0 && queryResult > 0)
                || (doctorExperiencesCount == 0 && queryResult == 0)  {
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
        
        self.initDb()
        
        let query = ExperienceDatabaseHelper.table
            .select(ExperienceDatabaseHelper.table[*])
            .filter(ExperienceDatabaseHelper.doctorId == Int64(doctor.getId()))
        
        do {
            for experience in try self.database.prepare(query) {
                experiences.append(
                    Experience(
                        doctor: doctor,
                        year: try experience.get(ExperienceDatabaseHelper.year),
                        description: try experience.get(ExperienceDatabaseHelper.description)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching experiences data.")
        }
        
        return experiences
    }
}
