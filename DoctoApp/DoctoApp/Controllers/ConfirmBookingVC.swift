//
//  ConfirmBookingVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ConfirmBookingVC: UIViewController {
    @IBOutlet weak var bookingErrorMessage: UIView!
    @IBOutlet weak var bookingSuccessMessage: UIView!
    @IBOutlet weak var bookingDetailsView: BookingDetailsView!

    var booking: Booking! // must be set by the calling view
    var doctor: Doctor!
    var patient: Patient! 
    
    private static let chooseReasonSegueIdentifier: String = "choose_reason_segue"
    private static let loginSegueIdentifier: String = "login_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {        
        // Retrieve most recent changes updating the doctor and the patient models
        self.doctor = self.booking.getDoctor().update() as? Doctor
        self.patient = self.booking.getPatient().update() as? Patient

        self.setContent()
    }

    // Set view content
    private func setContent() {
        if BookingDatabaseHelper().insertBooking(booking: self.booking) { self.setSuccessContent() }
        else { self.setErrorContent() }
    }

    // Set success content
    private func setSuccessContent() {
        self.bookingDetailsView.setData(booking: booking)
    }
    
    // Set error content
    private func setErrorContent() {
        
    }
}
