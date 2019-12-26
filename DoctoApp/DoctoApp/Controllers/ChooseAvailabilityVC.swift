//
//  ChooseAvailabilityVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol ChooseAvailabilityDelegator {
    func confirmBooking(booking: Booking)
    func updateBooking(booking: Booking)
}

class ChooseAvailabilityVC: UIViewController, ChooseAvailabilityDelegator {
    @IBOutlet weak var headerDashboardSubtitle: HeaderDashboardSubtitleView!
    @IBOutlet weak var availabilityPerDayList: UITableView!
    
    private var availabilitiesPerDay: [Int: [String: [Availability]]] = [Int: [String: [Availability]]]()
    private var availabilitiesForDay: [String: [Availability]] = [String: [Availability]]()

    private var reason: Reason! // must be set by the calling view
    private var doctor: Doctor! // must be set by the calling view
    private var patient: Patient! // must be set by the calling view
    private var booking: Booking?
    private var isBookingUpdate: Bool? = false
    private var loggedUser: Resident! // must be retrieved from the user defaults

    private static let weeksNumber: Int = 2
    
    private static let availabilitiesForDayItemCellXibFile: String = "AvailabilitiesForDayItemCell"
    private static let confirmBookingSegueIdentifier: String = "confirm_booking_segue"
    private static let myBookingsSegueIdentifier: String = "my_bookings_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.tryGetLoggedUser()
        
        self.availabilityPerDayList.delegate = self
        self.availabilityPerDayList.dataSource = self
        self.availabilityPerDayList.separatorColor = UIColor(hex: Colors.MY_BOOKINGS_BODY)
        
        if self.isBookingUpdate! { self.availabilitiesForDay = self.doctor.getAvailabilitiesForDay(bookingFullDate: self.booking!.getFullDate()) }
        else { self.availabilitiesPerDay = self.doctor.getAvailabilitiesPerDay(weeksNumber: ChooseAvailabilityVC.weeksNumber) }
        
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
        if segue.identifier == ChooseAvailabilityVC.confirmBookingSegueIdentifier
            && segue.destination is ConfirmBookingVC {
            let confirmBookingVC = segue.destination as! ConfirmBookingVC
            confirmBookingVC.setData(booking: self.booking!)
        }
    }
    
    // Set header data
    func setHeaderData() {
        self.headerDashboardSubtitle.setData(
            headerDelegator: self,
            headerTitle: Strings.CHOOSE_DATE_TIME_TITLE_1,
            headerSubtitle: self.doctor.getFullname()
        )
    }
    
    // Set view data
    func setData(doctor: Doctor? = nil, reason: Reason? = nil, booking: Booking? = nil, isBookingUpdate: Bool? = false) {
        if doctor != nil { self.doctor = doctor }
        if reason != nil { self.reason = reason! }
        
        self.booking = booking
        self.isBookingUpdate = isBookingUpdate ?? false
        
        if self.isBookingUpdate! { self.doctor = self.booking?.getDoctor() }
    }
    
    // Jump to confirm booking view
    func confirmBooking(booking: Booking) {
        self.booking = booking
        performSegue(withIdentifier: ChooseAvailabilityVC.confirmBookingSegueIdentifier, sender: nil)
    }
    
    // Jump to my bookings view
    func updateBooking(booking: Booking) {
        self.booking = booking
        BookingDatabaseHelper().updateBooking(booking: self.booking!)
        performSegue(withIdentifier: ChooseAvailabilityVC.myBookingsSegueIdentifier, sender: nil)
    }
}

extension ChooseAvailabilityVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.isBookingUpdate! { return self.availabilitiesPerDay.count }
        return self.availabilitiesForDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.isBookingUpdate! {
            let availabilitiesForDay: [String: [Availability]] = self.availabilitiesPerDay[indexPath.row]!
            let availabilitiesForDayItemCell = Bundle.main.loadNibNamed(ChooseAvailabilityVC.availabilitiesForDayItemCellXibFile, owner: self, options: nil)?.first as! AvailabilitiesForDayItemCell
            availabilitiesForDayItemCell.setData(
                availabilitiesForDay: availabilitiesForDay,
                reason: self.reason,
                doctor: self.doctor,
                delegator: self
            )
            
            return availabilitiesForDayItemCell
        }
        
        let availabilitiesForDayItemCell = Bundle.main.loadNibNamed(ChooseAvailabilityVC.availabilitiesForDayItemCellXibFile, owner: self, options: nil)?.first as! AvailabilitiesForDayItemCell
        availabilitiesForDayItemCell.setData(
            availabilitiesForDay: self.availabilitiesForDay,
            reason: self.booking!.getReason(),
            doctor: self.doctor,
            delegator: self,
            isBookingUpdate: true,
            booking: self.booking
        )
        
        return availabilitiesForDayItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
