//
//  Education.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import UIKit

class Education {
    private var year: String
    private var doctor: Doctor?
    private var degree: String
    
    init(
        year: String,
        doctor: Doctor?,
        degree: String
        ) {
        self.year = year
        self.doctor = doctor
        self.degree = degree
    }
    
    func getYear() -> String { return self.year }
    func getDoctor() -> Doctor? { return self.doctor }
    func getDegree() -> String { return self.degree }
    
    func setYear(year: String) { self.year = year }
    func setDoctor(doctor: Doctor) { self.doctor = doctor }
    func setDegree(degree: String) { self.degree = degree }
}

extension Education: Equatable {
    static func == (e1: Education, e2: Education) -> Bool {
        if e1.getDoctor() != nil && e2.getDoctor() != nil {
            if e1.getDoctor() != e2.getDoctor() { return false }
        }
        
        if (e1.getDoctor() == nil && e2.getDoctor() != nil)
            || (e1.getDoctor() != nil && e2.getDoctor() == nil) {
            return false
        }
        
        if e1.getYear() != e2.getYear() { return false }
        
        return e1.getDegree() == e2.getDegree()
    }
}

