//
//  ConfirmBookingVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol ShowDoctorProfileDelegator {
    func showDoctorProfile(doctor: Doctor)
}

class ConfirmBookingVC: UIViewController, ShowDoctorProfileDelegator {
    @IBOutlet weak var headerDashboard: HeaderDashboardView!
    @IBOutlet weak var bookingFeedbackMessage: FeedbackMessageView!
    @IBOutlet weak var bookingDetailsView: BookingDetailsView!
    @IBOutlet weak var myBookingsBtn: UIButton!
    
    var booking: Booking! // must be set by the calling view
    var doctor: Doctor!
    
    var loggedUser: Resident! // must be set by the calling view or got from user defaults
    
    private static let doctorProfileSegueIdentifier = "doctor_profile_segue"
    private static let myBookingsVCSegueIdentifier = "my_bookings_segue"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.loggedUser = self.loggedUser.update()

        self.doctor = self.booking.getDoctor()
        self.setBookingDetailsViewData()
        self.setHeaderData()
        self.setContent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConfirmBookingVC.doctorProfileSegueIdentifier && segue.destination is DoctorProfileVC {
            let doctorProfileVC = segue.destination as! DoctorProfileVC
            doctorProfileVC.setData(
                doctor: self.doctor,
                loggedUser: self.loggedUser
            )
        } else if segue.identifier == ConfirmBookingVC.myBookingsVCSegueIdentifier && segue.destination is MyBookingsVC {
            let myBookingsVC = segue.destination as! MyBookingsVC
            myBookingsVC.setData(loggedUser: self.loggedUser)
        }
    }
    
    // Show doctor profile
    func showDoctorProfile(doctor: Doctor) {
        self.doctor = doctor
        performSegue(withIdentifier: ConfirmBookingVC.doctorProfileSegueIdentifier, sender: nil)
    }
    
    // Set booking details view data
    private func setBookingDetailsViewData() {
        self.bookingDetailsView.setData(
            booking: self.booking,
            showDoctorProfileDelegator: self,
            loggedUser: self.loggedUser
        )
    }
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboard.headerTitle.text = Strings.CONFIRM_APPOINTMENT_HEADER_TITLE
    }
    
    // Set view data
    func setData(booking: Booking, loggedUser: Resident? = nil) {
        self.booking = booking
        if loggedUser != nil { self.loggedUser = loggedUser }
    }

    // Set view content
    private func setContent() {
        if BookingDatabaseHelper().insertBooking(booking: self.booking) { self.setSuccessContent() }
        else { self.setErrorContent() }
    }

    // Set success content
    private func setSuccessContent() {
        self.bookingFeedbackMessage.setData(
            title: Strings.CONFIRM_APPOINTMENT_SUCCESS_MSG_TITLE,
            content: Strings.CONFIRM_APPOINTMENT_SUCCESS_MSG_CONTENT,
            isErrorMsg: false,
            isInfoMsg: false
        )
        
        self.myBookingsBtn.isHidden = true
    }
    
    // Set error content
    private func setErrorContent() {
        self.bookingFeedbackMessage.setData(
            title: Strings.CONFIRM_APPOINTMENT_ERROR_MSG_TITLE,
            content: Strings.CONFIRM_APPOINTMENT_ERROR_MSG_CONTENT,
            isErrorMsg: true,
            isInfoMsg: false
        )
        
        self.bookingDetailsView.removeFromSuperview()
    }
}
