//
//  PopUpBookingCancellationVC.swift
//  DoctoApp
//
//  Created by Joachim on 25/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class PopUpBookingCancellationVC: UIViewController {
    @IBOutlet weak var bookingFullDate: UILabel!
    @IBOutlet weak var bookingTime: UILabel!
    @IBOutlet weak var doctorFullname: UILabel!
    
    private var booking: Booking! // must be set by the calling view
    
    private var delegator: PopUpBookingCancellationActionDelegator! // must be set by the calling  view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize view components and properties
    private func initialize() {
        self.bookingFullDate.text = self.bookingFullDate.text!.replacingOccurrences(of: Strings.SHOW_BOOKING_CANCEL_BOOKING_POPUP_CONTENT_BOOKING_FULLDATE, with: self.booking.getFullDate())
        self.bookingTime.text = self.bookingTime.text!.replacingOccurrences(of: Strings.SHOW_BOOKING_CANCEL_BOOKING_POPUP_CONTENT_BOOKING_TIME, with: self.booking.getTime())
        self.doctorFullname.text = self.doctorFullname.text!.replacingOccurrences(of: Strings.SHOW_BOOKING_CANCEL_BOOKING_POPUP_CONTENT_DOCTOR_FULLNAME, with: self.booking.getDoctor().getFullname())
    }
    
    // Set view data
    func setData(booking: Booking, delegator: PopUpBookingCancellationActionDelegator) {
        self.delegator = delegator
        self.booking = booking
    }
    
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirm(_ sender: Any) {
        self.delegator.confirmBookingCancellation()
    }
}
