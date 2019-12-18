//
//  HomeVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 26/11/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    static let searchSegueIdentifier: String = "search_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    private func initialize() {
        self.searchBar.delegate = self
        // Remove seach bar borders
        self.searchBar.backgroundImage = UIImage()
        let _ = DoctoAppDatabaseHelper()
        // self.createDoctors()
    }
    
    private func createDoctors() {
        let pwd = "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
        let pwdSalt = "7e240de74fb1ed08fa08d38063f6a6a91462a815" // aaa
        
        let d1 = Doctor(id: -1, lastname: "LAVIOLETTE", firstname: "Joachim", email: "joachim.laviolete@gmail.com", pwd: pwd, pwdSalt: pwdSalt, lastLogin: DateTimeService.GetCurrentDateTime(), picture: "pp1", address: Address(id: -1, street1: "8 rue de la plaine", street2: "Bat A26", city: "Paris", zip: "75008", country: "France"), speciality: "Pediatrician", description: "Specialized in children auscultation", contactNumber: "0660170694", underAgreement: true, healthInsuranceCard: true, thirdPartyPayment: true, header: "wallp1")
        
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
        d1.setAvailabilities(availabilities: availD2)
        d1.setAvailabilities(availabilities: availD3)

        d1.setLanguages(languages: lanD1)
        d1.setLanguages(languages: lanD2)
        d1.setLanguages(languages: lanD3)

        d1.setPaymentOptions(paymentOptions: poD1)
        d1.setPaymentOptions(paymentOptions: poD2)
        d1.setPaymentOptions(paymentOptions: poD3)

        d1.setReasons(reasons: reasonsD1)
        d1.setReasons(reasons: reasonsD2)
        d1.setReasons(reasons: reasonsD3)

        d1.setEducations(educations: eduD1)
        d1.setEducations(educations: eduD2)
        d1.setEducations(educations: eduD3)

        d1.setExperiences(experiences: expD1)
        d1.setExperiences(experiences: expD2)
        d1.setExperiences(experiences: expD3)

        if !DoctorDatabaseHelper().createDoctor(doctor: d1) { return }
        if !DoctorDatabaseHelper().createDoctor(doctor: d2) { return }
        if !DoctorDatabaseHelper().createDoctor(doctor: d3) { return }
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        performSegue(withIdentifier: HomeVC.searchSegueIdentifier, sender: nil)
    }
}
