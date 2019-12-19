//
//  ConfirmBookingVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol ConfirmBookingVCDelegator {
    func showDoctorProfile(doctor: Doctor)
}

class ConfirmBookingVC: UIViewController, ConfirmBookingVCDelegator {
    @IBOutlet weak var headerDashboard: HeaderDashboardView!
    @IBOutlet weak var bookingFeedbackMessage: FeedbackMessageView!
    @IBOutlet weak var bookingDetailsView: BookingDetailsView!
    @IBOutlet weak var myBookingsBtn: UIButton!
    
    var booking: Booking! // must be set by the calling view
    var doctor: Doctor!
    
    private static let doctorProfileSegueIdentifier = "doctor_profile_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.setBookingDetailsViewData()
        self.setHeaderData()
        self.setContent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConfirmBookingVC.doctorProfileSegueIdentifier && segue.destination is DoctorProfileVC {
            let doctorProfileVC = segue.destination as! DoctorProfileVC
            doctorProfileVC.doctor = self.doctor
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
            delegator: self
        )
    }
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboard.headerTitle.text = Strings.CONFIRM_APPOINTMENT_HEADER_TITLE
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
            isErrorMsg: false
        )
        
        self.myBookingsBtn.isHidden = true
    }
    
    // Set error content
    private func setErrorContent() {
        self.bookingFeedbackMessage.setData(
            title: Strings.CONFIRM_APPOINTMENT_ERROR_MSG_TITLE,
            content: Strings.CONFIRM_APPOINTMENT_ERROR_MSG_CONTENT,
            isErrorMsg: true
        )
        
        self.bookingDetailsView.removeFromSuperview()
    }
}
