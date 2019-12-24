//
//  DoctorSecondaryDataItemCell.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 17/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class DoctorSecondaryDataItemCell: UITableViewCell {
    @IBOutlet var sectionIcon: UIImageView!
    @IBOutlet var sectionTitle: UILabel!
    @IBOutlet var sectionMore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupIcon()
    }
    
    // Setup the section icon
    private func setupIcon() {
        self.sectionIcon.image = self.sectionIcon.image?.withRenderingMode(.alwaysTemplate)
        self.sectionIcon.tintColor = UIColor(hex: Colors.APPOINTMENT_SUMMARY_ICON_TINT)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set cell data
    func setData(doctorSecondaryData: DoctorSecondaryData) {
        self.sectionIcon.image = UIImage(named: doctorSecondaryData.sectionIcon)
        self.setupIcon()
        self.sectionTitle.text = doctorSecondaryData.sectionTitle
    }
}
