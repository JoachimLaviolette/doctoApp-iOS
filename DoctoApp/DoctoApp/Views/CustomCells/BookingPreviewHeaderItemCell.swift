//
//  BookingPreviewHeaderItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 15/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class BookingPreviewHeaderItemCell: UITableViewCell {
    @IBOutlet weak var bookingFulldate: UILabel!
    @IBOutlet weak var bookingTime: UILabel!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var gotoIcon: UILabel!
    
    private var loggedUser: Resident! // must be retrieved from the user defaults
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tryGetLoggedUser()
        self.picture.layer.masksToBounds = true
        self.picture.layer.cornerRadius = self.picture.frame.height / 2
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set header data
    private func setHeaderData(booking: Booking) {
        self.bookingFulldate.text = booking.getFullDate()
        self.bookingTime.text = booking.getTime()
    }
    
    
    // Setup content font style
    private func setContentFontStyle(loggedUser: Resident? = nil) {
        if loggedUser is Doctor {
            self.content.font = UIFont.preferredFont(forTextStyle: .footnote).italic()  }
    }

    // Set cell data
    func setData(booking: Booking, picture: UIImage?, fullname: String?, description: String?) {
        self.tryGetLoggedUser()
        self.setHeaderData(booking: booking)
        if picture != nil { self.picture.image = picture }
        self.fullname.text = fullname ?? Strings.APPOINTMENT_SUMMARY_PATIENT_TITLE
        self.content.text = description == nil ? fullname :
            self.loggedUser is Doctor ? Strings.SHOW_BOOKING_APPOINTMENT_PATIENT_BIRTHDATE_PREFIX + description! : description!
        if fullname == nil { self.gotoIcon.isHidden = true }
        
        self.setContentFontStyle(loggedUser: loggedUser)
    }
}
