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
    
    private var booking: Booking! // must be set by the calling view
    private var doctor: Doctor!
    private var loggedUser: Resident! // must be retrieved from the user defaults
    
    private static let doctorProfileSegueIdentifier = "doctor_profile_segue"
    private static let myBookingsVCSegueIdentifier = "my_bookings_segue"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.tryGetLoggedUser()
        self.doctor = self.booking.getDoctor()
        self.setBookingDetailsViewData()
        self.setHeaderData()
        self.setContent()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConfirmBookingVC.doctorProfileSegueIdentifier && segue.destination is DoctorProfileVC {
            let doctorProfileVC = segue.destination as! DoctorProfileVC
            doctorProfileVC.setData(doctor: self.doctor)
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
            showDoctorProfileDelegator: self
        )
    }
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboard.setData(
            headerDelegator: self,
            headerTitle: Strings.CONFIRM_APPOINTMENT_HEADER_TITLE
        )
    }
    
    // Set view data
    func setData(booking: Booking) {
        self.booking = booking
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
