//
//  Experience.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

class Experience {
    private var doctor: Doctor?
    private var year: String
    private var description: String
    
    init(
        doctor: Doctor?,
        year: String,
        description: String
    ) {
        self.doctor = doctor
        self.year = year
        self.description = description
    }
    
    func getDoctor() -> Doctor? { return self.doctor }
    func getYear() -> String { return self.year }
    func getDescription() -> String { return self.description }
    
    func setDoctor(doctor: Doctor) { self.doctor = doctor }
    func setYear(year: String) { self.year = year }
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
