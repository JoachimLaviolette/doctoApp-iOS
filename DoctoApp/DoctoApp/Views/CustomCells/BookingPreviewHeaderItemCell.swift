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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.picture.layer.masksToBounds = true
        self.picture.layer.cornerRadius = self.picture.frame.height / 2
        
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
    func setData(booking: Booking, picture: String?, fullname: String?, description: String?, loggedUser: Resident? = nil) {
        self.setHeaderData(booking: booking)
        self.picture.image = UIImage(named: picture ?? "")
        self.fullname.text = fullname ?? Strings.APPOINTMENT_SUMMARY_PATIENT_TITLE
        self.content.text = description == nil ? fullname :
            loggedUser is Doctor ? Strings.SHOW_BOOKING_APPOINTMENT_PATIENT_BIRTHDATE_PREFIX + description! : description!
        if fullname == nil { self.gotoIcon.isHidden = true }
        
        self.setContentFontStyle(loggedUser: loggedUser)
    }
}
