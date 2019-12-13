//
//  Education.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import UIKit

class Education {
    private var doctor: Doctor?
    private var year: String
    private var degree: String
    
    init(
        doctor: Doctor?,
        year: String,
        degree: String
    ) {
        self.doctor = doctor
        self.year = year
        self.degree = degree
    }
    
    func getDoctor() -> Doctor? { return self.doctor }
    func getYear() -> String { return self.year }
    func getDegree() -> String { return self.degree }
    
    func setDoctor(doctor: Doctor) { self.doctor = doctor }
    func setYear(year: String) { self.year = year }
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

