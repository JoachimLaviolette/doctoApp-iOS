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
    
    var booking: Booking! // must be set by the calling view
    
    private static let updateIcon = "ic_update"
    private static let cancelIcon = "ic_cancel"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupButtonsIconsColors()
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
    func setData(booking: Booking) {
        self.booking = booking
    }
}
