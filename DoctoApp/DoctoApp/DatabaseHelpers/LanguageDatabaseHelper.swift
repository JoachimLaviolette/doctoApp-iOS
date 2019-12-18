//
//  LanguageDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class LanguageDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "language"
    static let table = Table("language")
    
    // Fields
    private let doctorId = Expression<Int64>("doctor_id")
    private let language = Expression<String>("language")
    
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
                .appendingPathComponent(LanguageDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
                        
            let createTable = LanguageDatabaseHelper.table.create { table in
                table.column(self.doctorId)
                table.column(self.language)
                
                // Alter table
                table.primaryKey(
                    self.doctorId,
                    self.language
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
                print (LanguageDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(LanguageDatabaseHelper.table.drop())
        } catch {}
    }
    
    // Insert all the languages of the given doctor in the database
    func insertLanguages(doctor: Doctor) -> Doctor {
        for language: Language in doctor.getLanguages()! {
            self.insertLanguage(language: language, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new language in the database related to the given doctor
    private func insertLanguage(language: Language, doctor: Doctor) {
        self.initTableConfig()
        
        let query = LanguageDatabaseHelper.table.insert(
            self.doctorId <- Int64(doctor.getId()),
            self.language <- language.rawValue
        )
        
        do {
            try self.database.run(query)
            print("Language insertion succeeded for doctor: " + doctor.getFullname())
        } catch {
            print("Language insertion failed for doctor: " + doctor.getFullname())
        }
    }
    
    // Update the languages of the given doctor in the database
    func updateLanguages(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        if self.dropLanguages(doctor: doctor) {
            let _ = self.insertLanguages(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the languages related to the given doctor from the database
    private func dropLanguages(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let filter = LanguageDatabaseHelper.table.filter(self.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
                print("Languages removal succeeded for doctor: " + doctor.getFullname())
                
                return true
            }
            
            print("Languages removal failed for doctor: " + doctor.getFullname())
        } catch {
            print("Languages removal failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Retrieve all languages related to the given doctor
    func getLanguages(doctor: Doctor) -> [Language] {
        var languages: [Language] = []
        
        self.initTableConfig()
        
        let query = LanguageDatabaseHelper.table
            .select(LanguageDatabaseHelper.table[*])
            .filter(self.doctorId == Int64(doctor.getId()))
        
        do {
            for language in try self.database.prepare(query) {
                languages.append(Language.getValueOf(languageName: try language.get(self.language))!)
            }
        } catch {
            print("Something went wrong when fetching languages data.")
        }
        
        return languages
    }
}
