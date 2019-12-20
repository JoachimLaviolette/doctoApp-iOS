//
//  SignUpProOneColumnElementItemCell.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 19/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit


class SignUpProOneColumnElementItemCell: UITableViewCell {
    
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var deleteIcon: UIButton!
    
    var index: Int! // must be set by the calling view
    var itemType: ItemType! // must be set by the calling view
    
    var delegator: SignUpProVCDelegator! // must be set by the calling view

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
    func setData(item: String, index: Int, itemType: ItemType, delegator: SignUpProVCDelegator) {
        self.item.text = item
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
