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

class EducationDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "education"
    static let table = Table("education")
    
    // Fields
    static let doctorId = Expression<Int64>("doctor_id")
    static let year = Expression<String>("year")
    static let degree = Expression<String>("degree")
    
    override init() {}
    
    // Insert all the educations of the given doctor in the database
    func insertEducations(doctor: Doctor) -> Doctor {
        for education: Education in doctor.getEducations()! {
            self.insertEducation(education: education, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new education in the database related to the given doctor
    private func insertEducation(education: Education, doctor: Doctor) {
        self.initDb()
        
        let query = EducationDatabaseHelper.table.insert(
            EducationDatabaseHelper.doctorId <- Int64(doctor.getId()),
            EducationDatabaseHelper.year <- education.getYear(),
            EducationDatabaseHelper.degree <- education.getDegree()
        )
        
        do {
            try self.database.run(query)
            print("Education insertion succeeded for doctor: " + doctor.getFullname())
        } catch {
            print("Education insertion failed for doctor: " + doctor.getFullname())
        }
    }
    
    // Update the educations of the given doctor in the database
    func updateEducations(doctor: Doctor) -> Bool {
        self.initDb()
        
        if self.dropEducations(doctor: doctor) {
            let _ = self.insertEducations(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the educations related to the given doctor from the database
    private func dropEducations(doctor: Doctor) -> Bool {
        self.initDb()
        
        let filter = EducationDatabaseHelper.table.filter(EducationDatabaseHelper.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            let doctorEducationsCount: Int = self.getEducations(doctor: doctor).count
            let queryResult: Int = try self.database.run(query)
            
            if (doctorEducationsCount > 0 && queryResult > 0)
                || (doctorEducationsCount == 0 && queryResult == 0)  {
                print("Educations removal succeeded for doctor: " + doctor.getFullname())
                
                return true
            }
            
            print("Educations removal failed for doctor: " + doctor.getFullname())
        } catch {
            print("Educations removal failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Retrieve all educations related to the given doctor
    func getEducations(doctor: Doctor) -> [Education] {
        var educations: [Education] = []
        
        self.initDb()
        
        let query = EducationDatabaseHelper.table
            .select(EducationDatabaseHelper.table[*])
            .filter(EducationDatabaseHelper.doctorId == Int64(doctor.getId()))
        
        do {
            for education in try self.database.prepare(query) {
                educations.append(
                    Education(
                        doctor: doctor,
                        year: try education.get(EducationDatabaseHelper.year),
                        degree: try education.get(EducationDatabaseHelper.degree)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching educations data.")
        }
        
        return educations
    }
}
