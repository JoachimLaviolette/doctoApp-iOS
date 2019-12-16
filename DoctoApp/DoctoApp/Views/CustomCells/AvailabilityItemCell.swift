//
//  AvailabilityItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class AvailabilityItemCell: UITableViewCell {
    var chooseAvailabilityDelegate: ChooseAvailabilityDelegator! // must be set by the calling view
    
    @IBOutlet weak var availabilityTime: UILabel!
    
    var availability: Availability! // must be set by the calling view
    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view
    var reason: Reason! // must be set by the calling view

    func setData(availability: Availability, reason: Reason, doctor: Doctor, patient: Patient) {
        self.availability = availability
        self.reason = reason
        self.doctor = doctor
        self.patient = patient
        self.availabilityTime.text = self.availability.getTime()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.confirmBooking()
    }

    // Display booking confirmation
    private func confirmBooking() {
        self.chooseAvailabilityDelegate.confirmBooking(booking: Booking(
                id: -1,
                patient: self.patient,
                doctor: self.doctor,
                reason: self.reason,
                fullDate: self.availability.getDate(),
                date: self.availability.getDate(),
                time: self.availability.getTime(),
                bookingDate: DateTimeService.GetCurrentDateTime()
            )
        )
    }
}
