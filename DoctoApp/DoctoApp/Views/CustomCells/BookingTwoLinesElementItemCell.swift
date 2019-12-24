//
//  BookingTwoLinesElementItemCell.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 19/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

enum TwoLinesElementState {
    case warningMessage
    case paymentOptions
    case pricesAndRefunds
}

class BookingTwoLinesElementItemCell: UITableViewCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var content: UILabel!
    
    private var state: TwoLinesElementState = TwoLinesElementState.warningMessage
    
    private static let icons: [TwoLinesElementState: [String: String]] = [
        TwoLinesElementState.warningMessage: ["title": Strings.APPOINTMENT_SUMMARY_WARNING_MSG_TITLE, "icon": "ic_error"],
        TwoLinesElementState.paymentOptions: ["title": Strings.APPOINTMENT_SUMMARY_PAYMENT_OPTIONS_TITLE, "icon": "ic_payment"],
        TwoLinesElementState.pricesAndRefunds: ["title": Strings.APPOINTMENT_SUMMARY_PRICES_REFUNDS_TITLE, "icon": "ic_money"],
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
    func setData(content: String, state: TwoLinesElementState) {
        switch(state) {
            case TwoLinesElementState.warningMessage:
                self.title.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_WARNING_MSG_TITLE)
                self.content.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_WARNING_MSG_CONTENT)
                break
            case TwoLinesElementState.paymentOptions:
                self.title.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_PAYMENT_OPTIONS_TITLE)
                self.content.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_PAYMENT_OPTIONS_CONTENT)
            case TwoLinesElementState.pricesAndRefunds:
                self.title.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_PRICES_REFUNDS_TITLE)
                self.content.textColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_PRICES_REFUNDS_CONTENT)
                break
        }
        
        self.title.text = BookingTwoLinesElementItemCell.icons[state]!["title"]!
        self.icon.image = UIImage(named: BookingTwoLinesElementItemCell.icons[state]!["icon"]!)
        self.setupIcon()
        self.content.text = content
    }
}
