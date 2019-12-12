//
//  Address.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import UIKit

class Address {
    private var id: Int
    private var street1: String
    private var street2: String
    private var city: String
    private var zip: String
    private var country: String

    init(
        id: Int,
        street1: String,
        street2: String,
        city: String,
        zip: String,
        country: String
    ) {
        self.id = id
        self.street1 = street1
        self.street2 = street2
        self.city = city
        self.zip = zip
        self.country = country
    }

    func getId() -> Int { return self.id }
    func getStreet1() -> String { return self.street1 }
    func getStreet2() -> String { return self.street2 }
    func getCity() -> String { return self.city }
    func getZip() -> String { return self.zip }
    func getCountry() -> String { return self.country }
    
    func setId(id: Int) { self.id = id }
    func setStreet1(street1: String) { self.street1 = street1 }
    func setStreet2(street2: String) { self.street2 = street2 }
    func setCity(city: String) { self.city = city }
    func setZip(zip: String) { self.zip = zip }
    func setCountry(country: String) { self.country = country }
}
