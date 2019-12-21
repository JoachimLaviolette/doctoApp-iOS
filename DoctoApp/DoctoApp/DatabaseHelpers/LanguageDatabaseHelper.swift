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

class LanguageDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "language"
    static let table = Table("language")
    
    // Fields
    static let doctorId = Expression<Int64>("doctor_id")
    static let language = Expression<String>("language")
    
    override init() {}
    
    // Insert all the languages of the given doctor in the database
    func insertLanguages(doctor: Doctor) -> Doctor {
        for language: Language in doctor.getLanguages()! {
            self.insertLanguage(language: language, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new language in the database related to the given doctor
    private func insertLanguage(language: Language, doctor: Doctor) {
        self.initDb()
        
        let query = LanguageDatabaseHelper.table.insert(
            LanguageDatabaseHelper.doctorId <- Int64(doctor.getId()),
            LanguageDatabaseHelper.language <- language.rawValue
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
        self.initDb()
        
        if self.dropLanguages(doctor: doctor) {
            let _ = self.insertLanguages(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the languages related to the given doctor from the database
    private func dropLanguages(doctor: Doctor) -> Bool {
        self.initDb()
        
        let filter = LanguageDatabaseHelper.table.filter(LanguageDatabaseHelper.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            let doctorLanguagesCount: Int = self.getLanguages(doctor: doctor).count
            let queryResult: Int = try self.database.run(query)
            
            if (doctorLanguagesCount > 0 && queryResult > 0)
                || (doctorLanguagesCount == 0 && queryResult == 0)  {
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
        
        self.initDb()
        
        let query = LanguageDatabaseHelper.table
            .select(LanguageDatabaseHelper.table[*])
            .filter(LanguageDatabaseHelper.doctorId == Int64(doctor.getId()))
        
        do {
            for language in try self.database.prepare(query) {
                languages.append(Language.getValueOf(languageName: try language.get(LanguageDatabaseHelper.language))!)
            }
        } catch {
            print("Something went wrong when fetching languages data.")
        }
        
        return languages
    }
}
