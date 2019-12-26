//
//  BookingDetailsView.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 15/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class BookingPreviewItemCell: UITableViewCell {  
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var gotoIcon: UILabel!
    
    private var loggedUser: Resident! // must be retrieved from the user defaults
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    // Setup content font style
    private func setContentFontStyle() {
        if self.loggedUser is Doctor { self.content.font = UIFont.preferredFont(forTextStyle: .footnote).italic()  }
    }

    // Set cell data
    func setData(picture: UIImage?, fullname: String?, description: String?) {
        self.tryGetLoggedUser()
        if picture != nil { self.picture.image = picture }
        self.fullname.text = fullname ?? Strings.APPOINTMENT_SUMMARY_PATIENT_TITLE
        self.content.text = description == nil ? fullname :
            self.loggedUser is Doctor ? Strings.SHOW_BOOKING_APPOINTMENT_PATIENT_BIRTHDATE_PREFIX + description! : description!
        if fullname == nil || self.loggedUser is Doctor { self.gotoIcon.isHidden = true }
        
        self.setContentFontStyle()
    }
}

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
