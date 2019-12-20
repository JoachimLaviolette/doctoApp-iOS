//
//  ChooseAvailabilityVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol ChooseAvailabilityDelegator {
    func confirmBooking(booking: Booking, loggedUser: Resident?)
    func updateBooking(booking: Booking, loggedUser: Resident?)
}

class ChooseAvailabilityVC: UIViewController, ChooseAvailabilityDelegator {
    @IBOutlet weak var headerDashboardSubtitle: HeaderDashboardSubtitleView!
    @IBOutlet weak var availabilityPerDayList: UITableView!
    
    private var availabilitiesPerDay: [Int: [String: [Availability]]] = [Int: [String: [Availability]]]()
    private var availabilitiesForDay: [String: [Availability]] = [String: [Availability]]()

    var reason: Reason! // must be set by the calling view
    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view
    var booking: Booking?
    var isBookingUpdate: Bool? = false
    
    var loggedUser: Resident! // must be set by the calling view or go from the user defaults

    private static let weeksNumber: Int = 1
    
    private static let headerTitle: String = "Book an appointment"
    private static let availabilitiesForDayItemCellXibFile: String = "AvailabilitiesForDayItemCell"
    private static let confirmBookingSegueIdentifier: String = "confirm_booking_segue"
    private static let myBookingsSegueIdentifier: String = "my_bookings_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.loggedUser = self.loggedUser.update()
        
        self.availabilityPerDayList.delegate = self
        self.availabilityPerDayList.dataSource = self
        self.availabilityPerDayList.separatorColor = UIColor(hex: Colors.MY_BOOKINGS_BODY)
        
        if self.isBookingUpdate! { self.availabilitiesForDay = self.doctor.getAvailabilitiesForDay(bookingFullDate: self.booking!.getFullDate()) }
        else { self.availabilitiesPerDay = self.doctor.getAvailabilitiesPerDay(weeksNumber: ChooseAvailabilityVC.weeksNumber) }
        
        self.headerDashboardSubtitle.headerTitle.text = ChooseAvailabilityVC.headerTitle
        self.headerDashboardSubtitle.headerSubtitle.text = self.doctor.getFullname()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChooseAvailabilityVC.confirmBookingSegueIdentifier
            && segue.destination is ConfirmBookingVC {
            let confirmBookingVC = segue.destination as! ConfirmBookingVC
            confirmBookingVC.setData(
                booking: self.booking!,
                loggedUser: self.loggedUser
            )
        } else if segue.identifier == ChooseAvailabilityVC.myBookingsSegueIdentifier
        && segue.destination is MyBookingsVC {
            let myBookingsVC = segue.destination as! MyBookingsVC
            myBookingsVC.setData(loggedUser: self.loggedUser)
        }
    }
    
    // Set view data
    func setData(doctor: Doctor? = nil, reason: Reason? = nil, loggedUser: Resident? = nil, booking: Booking? = nil, isBookingUpdate: Bool? = false) {
        if doctor != nil { self.doctor = doctor }
        if reason != nil { self.reason = reason! }
        
        self.loggedUser = loggedUser
        self.booking = booking
        self.isBookingUpdate = isBookingUpdate ?? false
        
        if self.isBookingUpdate! { self.doctor = self.booking?.getDoctor() }
    }
    
    // Jump to confirm booking view
    func confirmBooking(booking: Booking, loggedUser: Resident? = nil) {
        self.booking = booking
        self.loggedUser = loggedUser
        performSegue(withIdentifier: ChooseAvailabilityVC.confirmBookingSegueIdentifier, sender: nil)
    }
    
    // Jump to my bookings view
    func updateBooking(booking: Booking, loggedUser: Resident? = nil) {
        self.booking = booking
        self.loggedUser = loggedUser
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
                loggedUser: self.loggedUser,
                delegator: self
            )
            
            return availabilitiesForDayItemCell
        }
        
        let availabilitiesForDayItemCell = Bundle.main.loadNibNamed(ChooseAvailabilityVC.availabilitiesForDayItemCellXibFile, owner: self, options: nil)?.first as! AvailabilitiesForDayItemCell
        availabilitiesForDayItemCell.setData(
            availabilitiesForDay: self.availabilitiesForDay,
            reason: self.booking!.getReason(),
            doctor: self.doctor,
            loggedUser: self.loggedUser,
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
