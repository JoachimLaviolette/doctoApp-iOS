//
//  Resident.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import UIKit

class Resident {
    private var id: Int
    private var lastname: String
    private var firstname: String
    private var email: String
    private var pwd: String
    private var pwdSalt: String
    private var lastLogin: String
    private var picture: String?
    private var address: Address?
    private var bookings: [Booking]?
    
    init(
        id: Int,
        lastname: String,
        firstname: String,
        email: String,
        pwd: String,
        pwdSalt: String,
        lastLogin: String,
        picture: String?,
        address: Address?
    ) {
        self.id = id
        self.lastname = lastname
        self.firstname = firstname
        self.email = email
        self.pwd = pwd
        self.pwdSalt = pwdSalt
        self.address = address
        self.lastLogin = lastLogin
        self.picture = picture
        self.bookings = [Booking]()
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
        bookings: [Booking]?
    ) {
        self.id = id
        self.lastname = lastname
        self.firstname = firstname
        self.email = email
        self.pwd = pwd
        self.pwdSalt = pwdSalt
        self.address = address
        self.lastLogin = lastLogin
        self.picture = picture
        self.bookings = bookings
    }
    
    func getId() -> Int { return self.id }
    func getLastname() -> String { return self.lastname }
    func getFirstname() -> String { return self.firstname }
    func getFullname() -> String { return self.firstname + " " + self.lastname.uppercased() }
    func getEmail() -> String { return self.email }
    func getPwd() -> String { return self.pwd }
    func getPwdSalt() -> String { return self.pwdSalt }
    func getLastLogin() -> String { return self.lastLogin }
    func getPicture() -> String? { return self.picture }
    func getAddress() -> Address? { return self.address }
    func getBookings() -> [Booking]? { return self.bookings }

    func setId(id: Int) { self.id = id }
    func setLastname(lastname: String) { self.lastname = lastname }
    func setFirstname(firstname: String) { self.firstname = firstname }
    func setEmail(email: String) { self.email = email }
    func setPwd(pwd: String) { self.pwd = pwd }
    func setPwdSalt(pwdSalt: String) { self.pwdSalt = pwdSalt }
    func setLastLogin(lastLogin: String) { self.lastLogin = lastLogin }
    func setPicture(picture: String?) { self.picture = picture }
    func setAddress(address: Address?) { self.address = address }
    func setBookings(bookings: [Booking]?) { self.bookings = bookings }

    // Add methods
    func addBooking(b: Booking) {
        self.bookings!.append(b)
    }

    // Remove methods
    /*func removeBooking(b: Booking) {
        if self.bookings.contains(where: b) {
            self.bookings.index(of: b).map {
                self.bookings.remove(at: $0)
            }
        }
    }*/

    // Update resident data
    func update() -> Resident { return self }
    
    // Transitive getters and setters
    func GetZip() -> String {
        return self.address!.getZip()
    }

    func GetStreet2() -> String {
        return self.address!.getStreet2()
    }

    func GetStreet1() -> String {
        return self.address!.getStreet1()
    }

    func GetCountry() -> String {
        return self.address!.getCountry()
    }

    func GetCity() -> String {
        return self.address!.getCity()
    }

    func GetAddressId() -> Int {
        return self.address!.getId()
    }

    func SetAddressId(id: Int) {
        self.address!.setId(id: id)
    }

    func GetCityCountry() -> String {
        return self.GetCity() + ", " + self.GetCountry().uppercased()
    }

    func GetFullAddress() -> String {
        return self.GetStreet1()
                + (self.GetStreet2().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "" : ", " + self.GetStreet2()) + "\n"
                + self.GetZip() + " " + self.GetCity() + "\n"
                + self.GetCountry()
    }
}

extension Resident: Equatable {
    static func == (r1: Resident, r2: Resident) -> Bool {
        return r1.getId() == r2.getId()
    }
}
