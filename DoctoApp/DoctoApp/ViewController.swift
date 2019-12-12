//
//  ViewController.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 26/11/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialize()
        
        self.Test()
    }
    
    private func Initialize() {
        self.searchBar.backgroundImage = UIImage()
    }
    
    private func Test() {
        /*let doctor1: Doctor = Doctor(
                id: 5,
                lastname: "Test",
                firstname: "Jean Philippe",
                email: "Test",
                pwd: "Test",
                pwdSalt: "Test",
                lastLogin: "Test",
                picture: "Test",
                address: Address(
                    id: 0,
                    street1: "Test",
                    street2: "Test",
                    city: "Test",
                    zip: "Test",
                    country: "Test"
                ),
                speciality: "Test",
                description: "Test",
                contactNumber: "Test",
                underAgreement: true,
                healthInsuranceCard: true,
                thirdPartyPayment: true,
                header: "Test"
        )

        let doctor2: Doctor = Doctor(
                id: 5,
                lastname: "Test",
                firstname: "Test",
                email: "Test",
                pwd: "Test",
                pwdSalt: "Test",
                lastLogin: "Test",
                picture: "Test",
                address: Address(
                    id: 0,
                    street1: "Test",
                    street2: "Test",
                    city: "Test",
                    zip: "Test",
                    country: "Test"
                ),
                speciality: "Test",
                description: "Test",
                contactNumber: "Test",
                underAgreement: true,
                healthInsuranceCard: true,
                thirdPartyPayment: true,
                header: "Test"
        )

        print(StringFormatterService.Capitalize(str: doctor1.getFirstname()))
        print(StringFormatterService.CapitalizeOnly(str: doctor1.getFirstname()))
        print(StringFormatterService.Capitalize(str: nil))

        let e1: Experience = Experience(year: "2010", doctor: doctor1, description: "Desc1")

        let e2: Experience = Experience(year: "2019", doctor: doctor1, description: "Desc2")

        doctor1.addExperience(e: e1)
        doctor1.addExperience(e: e2)

        print(doctor1.getExperiencesAString())

        doctor1.removeExperience(e: e1)

        print(doctor1.getExperiencesAString())*/
    }
}

