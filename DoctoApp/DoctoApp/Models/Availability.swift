//
//  Availability.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

class Availability {
    private var doctor: Doctor?
    private var date: String
    private var time: String
    
    init(
        doctor: Doctor?,
        date: String,
        time: String
    ) {
        self.doctor = doctor
        self.date = date
        self.time = time
    }
    
    func getDoctor() -> Doctor? { return self.doctor }
    func getDate() -> String { return self.date }
    func getTime() -> String { return self.time }
    
    func setDoctor(doctor: Doctor) { self.doctor = doctor }
    func setDate(date: String) { self.date = date }
    func setTime(time: String) { self.time = time }
}

extension Availability: Equatable {
    static func == (a1: Availability, a2: Availability) -> Bool {
        if a1.getDoctor() != nil && a2.getDoctor() != nil {
            if a1.getDoctor() != a2.getDoctor() {
                return false
            }
        }
        
        if (a1.getDoctor() == nil && a2.getDoctor() != nil)
            || (a1.getDoctor() != nil && a2.getDoctor() == nil) {
            return false
        }
        
        if a1.getDate() != a2.getDate() { return false }
        
        return a1.getTime() == a2.getTime()
    }
}
