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
    
    var loggedUser: Resident! // must be set by the calling view or got from user defaults
    var booking: Booking! // must be set by the calling view
    var doctor: Doctor? // set when clicked on doctor section of the booking details subview
    
    private static let doctorProfileSegueIdentifier = "doctor_profile_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.loggedUser = self.loggedUser.update()
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
            delegator: self,
            isConfirmBooking: false,
            loggedUser: loggedUser
        )
    }
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboardSubtitle.headerTitle.text = Strings.SHOW_BOOKING_TITLE
        self.headerDashboardSubtitle.headerSubtitle.text = Strings.SHOW_BOOKING_SUBTITLE
    }
    
    // Set view data
    func setData(booking: Booking, loggedUser: Resident? = nil) {
        self.booking = booking
        if loggedUser != nil { self.loggedUser = loggedUser }
    }
    
    // Show doctor profile
    func showDoctorProfile(doctor: Doctor) {
        self.doctor = doctor
        performSegue(withIdentifier: MyBookingDetailsVC.doctorProfileSegueIdentifier, sender: nil)
    }
}
