//
//  DoctorMainDataItemCell.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 17/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation

class DoctorMainDataItemCell: UITableViewCell {
    @IBOutlet var sectionIcon: UIImageView!
    @IBOutlet var sectionTitle: UILabel!
    @IBOutlet var sectionContent: UILabel!
    @IBOutlet var sectionMore: UILabel!
    @IBOutlet var expandIcon: UILabel!
    
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
    func setData(doctorMainData: DoctorMainData, displayExpandIcon: Bool = false) {
        self.sectionIcon.image = UIImage(named: doctorMainData.sectionIcon)
        self.setupIcon()
        self.sectionTitle.text = doctorMainData.sectionTitle
        self.sectionContent.text = doctorMainData.sectionContent
        if !displayExpandIcon { self.expandIcon.isHidden = true }
    }
}
    
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            var hexColor = String(hex[start...])
            
            if hexColor.count == 6 { hexColor += "FF" }
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
