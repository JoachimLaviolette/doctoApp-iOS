//
//  MyBookingDetailsVC.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 19/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol MyBookingDetailsActionsDelegator {
    func updateBooking(booking: Booking, loggedUser: Resident?)
    func cancelBooking(booking: Booking, loggedUser: Resident?)
}

class MyBookingDetailsVC: UIViewController, ShowDoctorProfileDelegator, MyBookingDetailsActionsDelegator {
    @IBOutlet weak var headerDashboardSubtitle: HeaderDashboardSubtitleView!
    @IBOutlet weak var bookingDetailsView: BookingDetailsView!
    
    private var loggedUser: Resident! // must be retrieved from the user defaults
    private var booking: Booking! // must be set by the calling view
    private var doctor: Doctor? // set when clicked on doctor section of the booking details subview
    
    private static let doctorProfileSegueIdentifier = "doctor_profile_segue"
    private static let updateBookingSegueIdentifier = "update_booking_segue"
    private static let cancelBookingSegueIdentifier = "cancel_booking_segue"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.tryGetLoggedUser()
        self.setBookingDetailsViewData()
        self.setHeaderData()
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
        if segue.identifier == MyBookingDetailsVC.doctorProfileSegueIdentifier && segue.destination is DoctorProfileVC {
            let doctorProfileVC = segue.destination as! DoctorProfileVC
            doctorProfileVC.setData(doctor: self.doctor!)
        } else if segue.identifier == MyBookingDetailsVC.updateBookingSegueIdentifier && segue.destination is ChooseAvailabilityVC {
            let chooseAvailabilityVC = segue.destination as! ChooseAvailabilityVC
            chooseAvailabilityVC.setData(booking: self.booking, isBookingUpdate: true)
        } else if segue.identifier == MyBookingDetailsVC.cancelBookingSegueIdentifier && segue.destination is ChooseAvailabilityVC {
            let popupVC = segue.destination as! PopUpVC
            /*popupVC.setData(
                title: Strings.PATIENT_APPOINTMENT_ITEM_CANCEL_APPOINTMENT,
                content: Strings.SHOW_BOOKING_APPOINTMENT_CANCEL_APPOINTMENT,
                delegate: self
            )*/
        }
    }
    
    // Set booking details view data
    private func setBookingDetailsViewData() {
        self.bookingDetailsView.setData(
            booking: self.booking,
            showDoctorProfileDelegator: self,
            isConfirmBooking: false,
            myBookingDetailsActionsDelegator: self
        )
    }
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboardSubtitle.headerTitle.text = Strings.SHOW_BOOKING_TITLE
        self.headerDashboardSubtitle.headerSubtitle.text = Strings.SHOW_BOOKING_SUBTITLE
    }
    
    // Set view data
    func setData(booking: Booking) {
        self.booking = booking
    }
    
    // Show doctor profile
    func showDoctorProfile(doctor: Doctor) {
        self.doctor = doctor
        performSegue(withIdentifier: MyBookingDetailsVC.doctorProfileSegueIdentifier, sender: nil)
    }
    
    // Update the given booking
    func updateBooking(booking: Booking, loggedUser: Resident? = nil) {
        self.booking = booking
        self.loggedUser = loggedUser
        performSegue(withIdentifier: MyBookingDetailsVC.updateBookingSegueIdentifier, sender: nil)
    }
    
    // Cancel the given booking
    func cancelBooking(booking: Booking, loggedUser: Resident? = nil) {
        self.booking = booking
        self.loggedUser = loggedUser
        performSegue(withIdentifier: MyBookingDetailsVC.cancelBookingSegueIdentifier, sender: nil)
    }
}
