//
//  Reason.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import UIKit

class Reason {
    private var id: Int
    private var doctor: Doctor?
    private var description: String

    init(
        id: Int,
        doctor: Doctor?,
        description: String
    ) {
        self.id = id
        self.doctor = doctor
        self.description = description
    }

    func getId() -> Int { return self.id }
    func getDoctor() -> Doctor? { return self.doctor }
    func getDescription() -> String { return self.description }
    
    func setId(id: Int) { self.id = id }
    func setDoctor(doctor: Doctor) { self.doctor = doctor }
    func setDescription(description: String) { self.description = description }
}

extension Reason: Equatable {
    static func == (r1: Reason, r2: Reason) -> Bool {
        if r1.getDoctor() != nil && r2.getDoctor() != nil {
            if r1.getDoctor() != r2.getDoctor() { return false }
        }
        
        if (r1.getDoctor() == nil && r2.getDoctor() != nil)
            || (r1.getDoctor() != nil && r2.getDoctor() == nil) {
            return false
        }
    
        return r1.getDescription() == r2.getDescription()
    }
}
    
