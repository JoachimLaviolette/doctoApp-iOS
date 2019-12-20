//
//  AvailabilityItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class AvailabilityItemCell: UICollectionViewCell {
    @IBOutlet weak var availabilityTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Set cell data
    func setData(availability: Availability) {
        self.availabilityTime.text = availability.getTime()
    }
}
