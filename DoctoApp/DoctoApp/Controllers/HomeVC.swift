//
//  HomeVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 26/11/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol HeaderDelegator {
    func home()
    func dashboard()
}

class HomeVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var loggedUser: Resident? = nil // can be retrieved from the user defaults
    
    static let searchSegueIdentifier: String = "search_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    private func initialize() {
        self.tryGetLoggedUser()
        
        self.searchBar.delegate = self
        // Remove seach bar borders
        self.searchBar.backgroundImage = UIImage()
        
        // DoctoAppDatabaseHelper().initDatabase()
        // self.createModels()
        // self.removeUserFromUserDefaults()
    }
    
    // Remove the logged user from the user defaults
    private func removeUserFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Strings.USER_ID_KEY)
        UserDefaults.standard.removeObject(forKey: Strings.USER_TYPE_KEY)
    }
    
    // Try to get a logged user id from the user defaults
    private func tryGetLoggedUser() {
        if self.loggedUser == nil {
            if UserDefaults.standard.string(forKey: Strings.USER_TYPE_KEY) == Strings.USER_TYPE_PATIENT {
                let patientId = UserDefaults.standard.integer(forKey: Strings.USER_ID_KEY)
                let patient: Patient = PatientDatabaseHelper().getPatient(patientId: patientId, email: nil, fromDoctor: false)!
                self.loggedUser = patient
            } else if UserDefaults.standard.string(forKey: Strings.USER_TYPE_KEY) == Strings.USER_TYPE_DOCTOR {
                let doctorId = UserDefaults.standard.integer(forKey: Strings.USER_ID_KEY)
                let doctor: Doctor = DoctorDatabaseHelper().getDoctor(doctorId: doctorId, email: nil, fromPatient: false)!
                self.loggedUser = doctor
            }
        }
    }
    
    private func createModels() {
        let inputPwd = "test"
        let pwdSalt = EncryptionService.SALT()
        let pwd = EncryptionService.SHA1(string: inputPwd + pwdSalt)
        
        let d1 = Doctor(id: -1, lastname: "GRAFFE", firstname: "Robert", email: "robert.graffe@gmail.com", pwd: pwd, pwdSalt: pwdSalt, lastLogin: DateTimeService.GetCurrentDateTime(), picture: "pp1", address: Address(id: -1, street1: "8 rue de la plaine", street2: "Bat A26", city: "Paris", zip: "75008", country: "France"), speciality: "Pediatrician", description: "Specialized in children auscultation", contactNumber: "0789009876", underAgreement: true, healthInsuranceCard: true, thirdPartyPayment: true, header: "wallp1")
        
        let d2 = Doctor(id: -1, lastname: "LAPLACE", firstname: "Damien", email: "damien.laplace@gmail.com", pwd: pwd, pwdSalt: pwdSalt, lastLogin: DateTimeService.GetCurrentDateTime(), picture: "pp2", address: Address(id: -1, street1: "15 rue du Fer", street2: "", city: "Toulouse", zip: "31000", country: "France"), speciality: "Surgeon", description: "Heart surgery", contactNumber: "+33785659963", underAgreement: false, healthInsuranceCard: false, thirdPartyPayment: false, header: "wallp2")
        
        let d3 = Doctor(id: -1, lastname: "PERRAT", firstname: "Stéphane", email: "stephane.perrat@gmail.com", pwd: pwd, pwdSalt: pwdSalt, lastLogin: DateTimeService.GetCurrentDateTime(), picture: "pp3", address: Address(id: -1, street1: "3 place Dugrand", street2: "Zone 4", city: "Bordeaux", zip: "33000", country: "France"), speciality: "Dentist", description: "Dentist", contactNumber: "01 05 26 02 41", underAgreement: false, healthInsuranceCard: true, thirdPartyPayment: false, header: "wallp3")
        
        let availD1 = [
            Availability(doctor: d1, date: "Monday", time: "10:00"),
            Availability(doctor: d1, date: "Monday", time: "11:00"),
            Availability(doctor: d1, date: "Tuesday", time: "12:00"),
            Availability(doctor: d1, date: "Friday", time: "13:00"),
            Availability(doctor: d1, date: "Friday", time: "15:00")
        ]

        let availD2 = [
            Availability(doctor: d2, date: "Thrusday", time: "08:00"),
            Availability(doctor: d2, date: "Thrusday", time: "09:00"),
            Availability(doctor: d2, date: "Thrusday", time: "10:00"),
            Availability(doctor: d2, date: "Friday", time: "15:00"),
            Availability(doctor: d2, date: "Friday", time: "16:00")
        ]

        let availD3 = [
            Availability(doctor: d3, date: "Tuesday", time: "18:00"),
            Availability(doctor: d3, date: "Tuesday", time: "19:00"),
            Availability(doctor: d3, date: "Tuesday", time: "20:00"),
            Availability(doctor: d3, date: "Thrusday", time: "13:00"),
            Availability(doctor: d3, date: "Thrusday", time: "14:00"),
            Availability(doctor: d3, date: "Thrusday", time: "16:00"),
            Availability(doctor: d3, date: "Friday", time: "08:00"),
            Availability(doctor: d3, date: "Friday", time: "19:00"),
            Availability(doctor: d3, date: "Friday", time: "10:00")
        ]

        let reasonsD1 = [
            Reason(id: -1, doctor: d1, description: "I want my child to be checked"),
            Reason(id: -1, doctor: d1, description: "My child feels pains in the back"),
            Reason(id: -1, doctor: d1, description: "My child is sick")
        ]

        let reasonsD2 = [
            Reason(id: -1, doctor: d2, description: "I need my heart to be checked"),
            Reason(id: -1, doctor: d2, description: "I feel pains around my heart"),
        ]

        let reasonsD3 = [
            Reason(id: -1, doctor: d3, description: "I need a descaling"),
            Reason(id: -1, doctor: d3, description: "I need my wisdom teeth to be removed"),
            Reason(id: -1, doctor: d3, description: "I have a decay")
        ]

        let expD1 = [
            Experience(doctor: d1, year: "2000", description: "Pediatrician in Paris Hospital"),
            Experience(doctor: d1, year: "2005", description: "Pediatrician in Le Havre Hospital"),
            Experience(doctor: d1, year: "2010", description: "Pediatrician in Toulouse Hospital")
        ]

        let expD2 = [
            Experience(doctor: d2, year: "2003", description: "Surgeon in Paris Hospital"),
            Experience(doctor: d2, year: "2008", description: "Surgeon in Le Havre Hospital")
        ]

        let expD3 = [
            Experience(doctor: d3, year: "2005", description: "Dentist in Paris Hospital"),
            Experience(doctor: d3, year: "2008", description: "Dentist in Nantes Hospital"),
            Experience(doctor: d3, year: "2015", description: "Dentist in Bordeaux Hospital")
        ]

        let eduD1 = [
            Education(doctor: d1, year: "1990", degree: "Certificate in Children Auscultation"),
            Education(doctor: d1, year: "1993", degree: "BSc in General Medicine"),
            Education(doctor: d1, year: "1995", degree: "MSc in Children Medicine")
        ]

        let eduD2 = [
            Education(doctor: d2, year: "1996", degree: "MSc in Heart Surgery"),
            Education(doctor: d2, year: "1993", degree: "PhD in Human Surgery")
        ]

        let eduD3 = [
            Education(doctor: d3, year: "2000", degree: "MSc in Teeth Medicine")
        ]

        let lanD1 = [
            Language.FR,
            Language.ES
        ]

        let lanD2 = [
            Language.FR,
            Language.ES,
            Language.EN,
        ]

        let lanD3 = [
            Language.FR,
            Language.ES,
            Language.IT
        ]

        let poD1 = [
            PaymentOption.CASH
        ]

        let poD2 = [
            PaymentOption.CASH,
            PaymentOption.CHEQUE
        ]

        let poD3 = [
            PaymentOption.CASH,
            PaymentOption.CREDIT_CARD,
            PaymentOption.CHEQUE            
        ]

        d1.setAvailabilities(availabilities: availD1)
        d2.setAvailabilities(availabilities: availD2)
        d3.setAvailabilities(availabilities: availD3)

        d1.setLanguages(languages: lanD1)
        d2.setLanguages(languages: lanD2)
        d3.setLanguages(languages: lanD3)

        d1.setPaymentOptions(paymentOptions: poD1)
        d2.setPaymentOptions(paymentOptions: poD2)
        d3.setPaymentOptions(paymentOptions: poD3)

        d1.setReasons(reasons: reasonsD1)
        d2.setReasons(reasons: reasonsD2)
        d3.setReasons(reasons: reasonsD3)

        d1.setEducations(educations: eduD1)
        d2.setEducations(educations: eduD2)
        d3.setEducations(educations: eduD3)

        d1.setExperiences(experiences: expD1)
        d2.setExperiences(experiences: expD2)
        d3.setExperiences(experiences: expD3)

        if !DoctorDatabaseHelper().createDoctor(doctor: d1) { return }
        if !DoctorDatabaseHelper().createDoctor(doctor: d2) { return }
        if !DoctorDatabaseHelper().createDoctor(doctor: d3) { return }
        
        let p1: Patient = Patient(id: -1, lastname: "FRANCO", firstname: "James", email: "james.franco@gmail.com", pwd: pwd, pwdSalt: pwdSalt, lastLogin: "2019-12-16", picture: "pp4", address: Address(id: -1, street1: "3 place Henry IV", street2: "", city: "Paris", zip: "75016", country: "France"), birthdate: "1996-05-23", insuranceNumber: "02153562365602")
        
        let p2: Patient = Patient(id: -1, lastname: "QUILLERY", firstname: "Marion", email: "marion.quillery@gmail.com", pwd: pwd, pwdSalt: pwdSalt, lastLogin: DateTimeService.GetCurrentDateTime(), picture: "pp5", address: Address(id: -1, street1: "10 rue des Rosières", street2: "", city: "Troyes", zip: "10000", country: "France"), birthdate: "1986-08-12", insuranceNumber: "0263563522125")
        
        if !PatientDatabaseHelper().createPatient(patient: p1) { return }
        if !PatientDatabaseHelper().createPatient(patient: p2) { return }
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        performSegue(withIdentifier: HomeVC.searchSegueIdentifier, sender: nil)
    }
}

extension UIViewController: HeaderDelegator {
    private static let loginSegueIdentifier: String = "login_segue"
    
    // Go to to root view
    func home() {
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Go to dashboard view
    func dashboard() {
        performSegue(withIdentifier: UIViewController.loginSegueIdentifier, sender: nil)
    }
}
