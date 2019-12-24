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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.picture.layer.masksToBounds = true
        self.picture.layer.cornerRadius = self.picture.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Setup content font style
    private func setContentFontStyle(loggedUser: Resident? = nil) {
        if loggedUser is Doctor {
            self.content.font = UIFont.preferredFont(forTextStyle: .footnote).italic()  }
    }

    // Set cell data
    func setData(picture: String?, fullname: String?, description: String?, loggedUser: Resident? = nil) {
        self.picture.image = UIImage(named: picture ?? "")
        self.fullname.text = fullname ?? Strings.APPOINTMENT_SUMMARY_PATIENT_TITLE
        self.content.text = description == nil ? fullname :
            loggedUser is Doctor ? Strings.SHOW_BOOKING_APPOINTMENT_PATIENT_BIRTHDATE_PREFIX + description! : description!
        if fullname == nil || loggedUser is Doctor { self.gotoIcon.isHidden = true }
        
        self.setContentFontStyle(loggedUser: loggedUser)
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
