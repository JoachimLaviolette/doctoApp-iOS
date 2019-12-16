//
//  ReasonItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ReasonItemCell: UITableViewCell {
    var chooseReasonDelegate: ChooseReasonDelegator! // must be set by the caling view
    
    @IBOutlet weak var reasonDescription: UILabel!
    
    var reason: Reason! // must be set by the calling view

    func setData(reason: Reason) {
        self.reason = reason
        self.reasonDescription.text = self.reason.getDescription()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.chooseAvailability()
    }
    
    // Display availabilities
    private func chooseAvailability() {
        self.chooseReasonDelegate.chooseReason(reason: self.reason)
    }
}
