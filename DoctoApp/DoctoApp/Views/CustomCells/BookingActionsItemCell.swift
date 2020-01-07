//
//  BookingActionsItemCellTableViewCell.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 19/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class BookingActionsItemCell: UITableViewCell {
    @IBOutlet var updateBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    private var booking: Booking! // must be set by the calling view
    private var delegator: MyBookingDetailsActionsDelegator!
    private var loggedUser: Resident? = nil // can be retrieved from the user defaults
    
    private static let updateIcon = "ic_update"
    private static let cancelIcon = "ic_cancel"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tryGetLoggedUser()
        self.setupButtonsIconsColors()
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
    
    // Setup actions buttons
    private func setupButtonsIconsColors() {
        var updateBtnIcon: UIImage? = UIImage(named: BookingActionsItemCell.updateIcon)
        var cancelBtnIcon: UIImage? = UIImage(named: BookingActionsItemCell.cancelIcon)
        
        updateBtnIcon = updateBtnIcon?.withRenderingMode(.alwaysTemplate)
        cancelBtnIcon = cancelBtnIcon?.withRenderingMode(.alwaysTemplate)

        self.updateBtn.setImage(updateBtnIcon, for: .normal)
        self.cancelBtn.setImage(cancelBtnIcon, for: .normal)
        
        self.updateBtn.tintColor = UIColor(hex: Colors.SHOW_BOOKING_APPOINTMENT_UPDATE_APPOINTMENT)
        self.cancelBtn.tintColor = UIColor(hex: Colors.SHOW_BOOKING_APPOINTMENT_CANCEL_APPOINTMENT)
        
        self.updateBtn.imageView?.contentMode = .scaleAspectFit
        self.cancelBtn.imageView?.contentMode = .scaleAspectFit
        
        self.updateBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.cancelBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set cell data
    func setData(booking: Booking, delegator: MyBookingDetailsActionsDelegator) {
        self.booking = booking
        self.delegator = delegator
    }
    
    @IBAction func updateBooking(_ sender: UIButton) {
        self.delegator.updateBooking(booking: self.booking)
    }
    
    @IBAction func cancelBooking(_ sender: UIButton) {
        self.delegator.cancelBooking(booking: self.booking)
    }
}
