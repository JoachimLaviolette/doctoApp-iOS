//
//  AvailabilityItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class AvailabilityItemCell: UITableViewCell {
    @IBOutlet weak var availabilityTime: UILabel!
    
    var availability: Availability! // must be set by the calling view
    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view
    
    private static let confirmBookingSegueIdentifier: String = "confirm_booking_segue"

    func setData(availability: Availability, doctor: Doctor, patient: Patient) {   
        self.availability = availability   
        self.doctor = doctor
        self.patient = patient
        self.availabilityTime.text = self.availability.getTime()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.showAvailabilities()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == confirmBookingSegueIdentifier
            && segue.destination is ConfirmBookingVC {
            let confirmBookingVC = segue.destination as! ConfirmBookingVC
            confirmBookingVC.booking = Booking(
                id: -1,
                patient: self.patient,
                doctor: self.doctor,
                reason: self.reason,
                fullDate: self.availability.getFullDate(),
                date: self.availability.getDate(),
                time: self.availability.getTime(),
                bookingDate: DateTimeService.GetCurrentDateTime()
            )
        }
    }

    // Display availabilities
    private func confirmBooking() {
        performSegueWithIdentifier(confirmBookingSegueIdentifier, sender: self)
    }
}
