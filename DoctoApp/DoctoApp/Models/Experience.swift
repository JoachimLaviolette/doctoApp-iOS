//
//  Experience.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

class Experience {
    private var year: String
    private var doctor: Doctor?
    private var description: String
    
    init(
        year: String,
        doctor: Doctor?,
        description: String
        ) {
        self.year = year
        self.doctor = doctor
        self.description = description
    }
    
    func getYear() -> String { return self.year }
    func getDoctor() -> Doctor? { return self.doctor }
    func getDescription() -> String { return self.description }
    
    func setYear(year: String) { self.year = year }
    func setDoctor(doctor: Doctor) { self.doctor = doctor }
    func setDescription(description: String) { self.description = description }
}

extension Experience: Equatable {
    static func == (e1: Experience, e2: Experience) -> Bool {
        if e1.getDoctor() != nil && e2.getDoctor() != nil {
            if e1.getDoctor() != e2.getDoctor() { return false }
        }
        
        if (e1.getDoctor() == nil && e2.getDoctor() != nil)
            || (e1.getDoctor() != nil && e2.getDoctor() == nil) {
            return false
        }
        
        if e1.getYear() != e2.getYear() { return false }
        
        return e1.getDescription() == e2.getDescription()
    }
}
