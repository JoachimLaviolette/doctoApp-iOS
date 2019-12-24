//
//  SignUpProTwoColumsElementItemCell.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 19/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

enum ItemType {
    case Availability
    case Reason
    case Education
    case Experience
    case Language
    case PaymentOption
}

class SignUpProTwoColumnsElementItemCell: UITableViewCell {
    @IBOutlet weak var item1: UILabel!
    @IBOutlet weak var item2: UILabel!
    @IBOutlet weak var deleteIcon: UIButton!
    
    private var index: Int! // must be set by the calling view
    private var itemType: ItemType! // must be set by the calling view
    private var delegator: SignUpProVCDelegator! // must be set by the calling view
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let origImage = UIImage(named: "ic_delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.deleteIcon.setImage(tintedImage, for: .normal)
        self.deleteIcon.tintColor = UIColor(hex: Colors.SIGNUP_PRO_ERROR_MSG)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set cell data
    func setData(item1: String, item2: String, index: Int, itemType: ItemType, delegator: SignUpProVCDelegator) {
        self.item1.text = item1
        self.item2.text = item2
        self.index = index
        self.itemType = itemType
        self.delegator = delegator
    }
    
    @IBAction func deleteRow(_ sender: Any) {
        self.delegator.removeItem(
            index: self.index,
            itemType: self.itemType
        )
    }
}
