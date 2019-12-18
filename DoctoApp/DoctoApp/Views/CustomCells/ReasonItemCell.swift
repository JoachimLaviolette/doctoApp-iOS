//
//  ReasonItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ReasonItemCell: UITableViewCell {    
    @IBOutlet weak var reasonDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(reason: Reason) {
        self.reasonDescription.text = reason.getDescription()
    }
}
