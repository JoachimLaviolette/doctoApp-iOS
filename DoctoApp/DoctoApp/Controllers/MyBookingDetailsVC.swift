//
//  MyBookingDetailsVC.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 19/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class MyBookingDetailsVC: UIViewController, ShowDoctorProfileDelegator {
    @IBOutlet weak var headerDashboardSubtitle: HeaderDashboardSubtitleView!
    @IBOutlet weak var bookingDetailsView: BookingDetailsView!
    
    var resident: Resident! // must be set by the calling view or got from user defaults
    var booking: Booking! // must be set by the calling view
    var doctor: Doctor? // set when clicked on doctor section of the booking details subview
    
    private static let doctorProfileSegueIdentifier = "doctor_profile_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.resident = self.resident.update()
        self.setBookingDetailsViewData()
        self.setHeaderData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MyBookingDetailsVC.doctorProfileSegueIdentifier && segue.destination is DoctorProfileVC {
            let doctorProfileVC = segue.destination as! DoctorProfileVC
            doctorProfileVC.doctor = self.doctor!
        }
    }
    
    // Set booking details view data
    private func setBookingDetailsViewData() {
        self.bookingDetailsView.setData(
            booking: self.booking,
            delegator: self
        )
    }
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboardSubtitle.headerTitle.text = self.resident is Doctor ? Strings.MY_BOOKINGS_TITLE_DOCTOR : Strings.MY_BOOKINGS_TITLE_PATIENT
        self.headerDashboardSubtitle.headerSubtitle.text = Strings.MY_BOOKINGS_SUBTITLE
    }
    
    // Set view data
    func setData(booking: Booking, resident: Resident) {
        self.booking = booking
        self.resident = resident
    }
    
    // Show doctor profile
    func showDoctorProfile(doctor: Doctor) {
        self.doctor = doctor
        performSegue(withIdentifier: MyBookingDetailsVC.doctorProfileSegueIdentifier, sender: nil)
    }
}
