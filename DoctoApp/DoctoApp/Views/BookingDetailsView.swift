//
//  BookingDetailsView.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 15/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class BookingDetailsView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var bookingFulldate: UILabel!
    @IBOutlet weak var bookingTime: UILabel!

    @IBOutlet weak var doctorPicture: UIImageView!
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!

    @IBOutlet weak var updateBooking: UIButton! // must be displayed on my bookings details view only
    @IBOutlet weak var cancelBooking: UIButton! // must be displayed on my bookings details view only

    @IBOutlet weak var bookingReason: UILabel!

    @IBOutlet weak var patientPicture: UIImageView! // must be displayed on booking confirmation view only
    @IBOutlet weak var patientFullname: UILabel! // must be displayed on booking confirmation view only

    @IBOutlet weak var warningMessageContent: UILabel!

    @IBOutlet weak var doctorContactNumber: UILabel!
    
    @IBOutlet weak var doctorAddress: UILabel!
    
    @IBOutlet weak var doctorPaymentOptions: UILabel!
    
    @IBOutlet weak var doctorPricesAndRefunds: UILabel!

    private static let bookingDetailsViewXib: String = "BookingDetailsView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    // Initialize controller properties
    private func initialize() {
        Bundle.main.loadNibNamed(BookingDetailsView.bookingDetailsViewXib, owner: nil, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // Set view data
    func setData(booking: Booking) {
        // Retrieve the models to work with
        let doctor: Doctor = booking.getDoctor()
        let patient: Patient = booking.getPatient()
        let reason: Reason = booking.getReason()

        // Set the view components values
        self.bookingFulldate.text = booking.getFullDate()
        self.bookingTime.text = booking.getTime()
        
        if !doctor.getPicture()!.isEmpty { self.doctorPicture.image = UIImage(named: doctor.getPicture()!) }
        self.doctorFullname.text = doctor.getFullname()
        self.doctorFullname.text = doctor.getFullname()
        self.doctorFullname.text = doctor.getFullname()

        self.bookingReason.text = reason.getDescription()

        if !patient.getPicture()!.isEmpty { self.patientPicture.image = UIImage(named: patient.getPicture()!) }
        self.patientFullname.text = patient.getFullname()
        
        self.warningMessageContent.text = doctor.getWarningMessage()

        self.doctorContactNumber.text = doctor.getContactNumber()

        self.doctorAddress.text = doctor.GetFullAddress()

        self.doctorPaymentOptions.text = doctor.getPaymentOptionsAsString()

        self.doctorPricesAndRefunds.text = doctor.getPricesAndRefundsAsString()
    }
}
