//
//  BookingOneLineElementItemCell.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 19/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

enum OneLineElementState {
    case reason
    case contactNumber
    case address
}

class BookingOneLineElementItemCell: UITableViewCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var content: UILabel!
    
    private var state: OneLineElementState = OneLineElementState.reason
    
    private static let icons: [OneLineElementState: String] = [
        OneLineElementState.reason: "ic_info",
        OneLineElementState.contactNumber: "ic_contact",
        OneLineElementState.address: "ic_dialog_map",
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupIcon()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Setup icon
    private func setupIcon() {
        self.icon.image = self.icon.image?.withRenderingMode(.alwaysTemplate)
        self.icon.tintColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_ICON_TINT)
    }
    
    // Set cell data
    func setData(content: String, state: OneLineElementState) {
        switch(state) {
            case OneLineElementState.reason:
                self.content.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_REASON)
                break
            case OneLineElementState.contactNumber:
                self.content.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_CONTACT_NUMBER)
                break
            case OneLineElementState.address:
                self.content.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_ADDRESS_CONTENT)
                break
        }
        
        self.icon.image = UIImage(named: BookingOneLineElementItemCell.icons[state]!)
        self.setupIcon()
        self.content.text = content
    }
}
