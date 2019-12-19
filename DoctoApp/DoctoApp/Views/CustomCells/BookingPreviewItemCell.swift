//
//  BookingDetailsView.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 15/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class BookingPreviewItemCell: UITableViewCell {    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var fullname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var gotoIcon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.picture.layer.masksToBounds = true
        self.picture.layer.cornerRadius = self.picture.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Set cell data
    func setData(picture: String?, fullname: String?, description: String?) {
        self.picture.image = UIImage(named: picture ?? "")
        self.fullname.text = fullname ?? Strings.APPOINTMENT_SUMMARY_PATIENT_TITLE
        self.content.text = description == nil ? fullname : description!
        if fullname == nil { self.gotoIcon.isHidden = true }
    }
}
