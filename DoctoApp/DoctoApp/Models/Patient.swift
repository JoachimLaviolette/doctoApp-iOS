//
//  Patient.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import UIKit

class Patient: Resident {
    private var birthdate: String
    private var insuranceNumber: String
    
    init(
        id: Int,
        lastname: String,
        firstname: String,
        email: String,
        pwd: String,
        pwdSalt: String,
        lastLogin: String,
        picture: String?,
        address: Address?,
        birthdate: String,
        insuranceNumber: String
    ) {
        self.birthdate = birthdate
        self.insuranceNumber = insuranceNumber
        
        super.init(
            id: id,
            lastname: lastname,
            firstname: firstname,
            email: email,
            pwd: pwd,
            pwdSalt: pwdSalt,
            lastLogin: lastLogin,
            picture: picture,
            address: address
        )
    }
    
    init(
        id: Int,
        lastname: String,
        firstname: String,
        email: String,
        pwd: String,
        pwdSalt: String,
        lastLogin: String,
        picture: String?,
        address: Address?,
        birthdate: String,
        insuranceNumber: String,
        bookings: [Booking]?
    ) {
        self.birthdate = birthdate
        self.insuranceNumber = insuranceNumber
        
        super.init(
            id: id,
            lastname: lastname,
            firstname: firstname,
            email: email,
            pwd: pwd,
            pwdSalt: pwdSalt,
            lastLogin: lastLogin,
            picture: picture,
            address: address,
            bookings: bookings
        )
    }
    
    func getBirthdate() -> String { return self.birthdate }
    func getInsuranceNumber() -> String { return self.insuranceNumber }
    
    func setBirthdate(birthdate: String) { self.birthdate = birthdate }
    func setInsuranceNumber(insuranceNumber: String) { self.insuranceNumber = insuranceNumber }

    // Update patient data
    override func update() -> Resident {
        return PatientDatabaseHelper().getPatient(
            patientId: self.id,
            email: nil,
            fromDoctor: false
        ); 
    }
}
