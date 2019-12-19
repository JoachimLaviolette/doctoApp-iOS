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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateBtn.imageView?.image = self.updateBtn.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.cancelBtn.imageView?.image = self.cancelBtn.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.updateBtn.imageView?.tintColor = UIColor(hex: Colors.SHOW_BOOKING_APPOINTMENT_UPDATE_APPOINTMENT)
        self.cancelBtn.imageView?.tintColor = UIColor(hex: Colors.SHOW_BOOKING_APPOINTMENT_CANCEL_APPOINTMENT)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
