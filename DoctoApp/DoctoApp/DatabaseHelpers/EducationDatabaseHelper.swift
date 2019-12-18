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
    
    // Insert all the educations of the given doctor in the database
    func insertEducations(doctor: Doctor) -> Doctor {
        for education: Education in doctor.getEducations()! {
            self.insertEducation(education: education, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new education in the database related to the given doctor
    private func insertEducation(education: Education, doctor: Doctor) {
        self.initTableConfig()
        
        let query = EducationDatabaseHelper.table.insert(
            self.doctorId <- Int64(doctor.getId()),
            self.year <- education.getYear(),
            self.degree <- education.getDegree()
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
        self.initTableConfig()
        
        if self.dropEducations(doctor: doctor) {
            let _ = self.insertEducations(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the educations related to the given doctor from the database
    private func dropEducations(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let filter = EducationDatabaseHelper.table.filter(self.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
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
        
        self.initTableConfig()
        
        let query = EducationDatabaseHelper.table
            .select(EducationDatabaseHelper.table[*])
            .filter(self.doctorId == Int64(doctor.getId()))
        
        do {
            for education in try self.database.prepare(query) {
                educations.append(
                    Education(
                        doctor: doctor,
                        year: try education.get(self.year),
                        degree: try education.get(self.degree)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching educations data.")
        }
        
        return educations
    }
}
