//
//  PopupSectionItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 27/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class PopupSectionItemCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set cell data
    func setData(title: String, content: String) {
        self.title.text = title
        self.content.text = content
    }
}
