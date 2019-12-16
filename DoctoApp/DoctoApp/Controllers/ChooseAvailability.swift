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
}

class ChooseAvailabilityVC: UIViewController {
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var availabilityPerDayList: UITableView!
    
    private var availabilitiesPerDay: [Int: [String: [Availability]]] = [Int: [String: [Availability]]]()

    var reason: Reason! // must be set by the calling view
    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view
    private var booking: Booking? 

    private static let weeksNumber: Int = 1
    private static let availabilitiesForDayItemCellIdentifer: String = "availabilities_for_day_item_cell"
    private static let confirmBookingSegueIdentifier: String = "confirm_booking_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {        
        self.availabilityPerDayList.delegate = self
        self.availabilityPerDayList.dataSource = self
        self.availabilitiesPerDay = self.doctor.getAvailabilitiesPerDay(weeksNumber: ChooseAvailabilityVC.weeksNumber)
        self.doctorFullname.text = self.doctor.getFullname()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChooseAvailabilityVC.confirmBookingSegueIdentifier
            && segue.destination is ConfirmBookingVC {
            let confirmBookingVC = segue.destination as! ConfirmBookingVC
            confirmBookingVC.booking = self.booking
        }
    }
}

extension ChooseAvailabilityVC: UITableViewDelegate, UITableViewDataSource, ChooseAvailabilityDelegator {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availabilitiesPerDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let availabilitiesForDay: [String: [Availability]] = self.availabilitiesPerDay[indexPath.row]!
        let availabilitiesForDayItemCell = tableView.dequeueReusableCell(withIdentifier: ChooseAvailabilityVC.availabilitiesForDayItemCellIdentifer) as! AvailabilitiesForDayItemCell
        availabilitiesForDayItemCell.chooseAvailabilityDelegate = self
        availabilitiesForDayItemCell.setData(
            availabilitiesForDay: availabilitiesForDay,
            reason: self.reason, 
            doctor: self.doctor, 
            patient: self.patient
        )
        
        return availabilitiesForDayItemCell
    }
    
    func confirmBooking(booking: Booking) {
        self.booking = booking
        self.performSegue(withIdentifier: ChooseAvailabilityVC.confirmBookingSegueIdentifier, sender: nil)
    }
}
