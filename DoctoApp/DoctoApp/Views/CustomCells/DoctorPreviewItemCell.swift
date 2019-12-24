//
//  DoctorPreviewItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class DoctorPreviewItemCell: UITableViewCell {
    @IBOutlet var doctorPicture: UIImageView!
    @IBOutlet var doctorAddress: UILabel!
    @IBOutlet var doctorFullname: UILabel!
    @IBOutlet var doctorSpeciality: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.doctorPicture.layer.masksToBounds = true
        self.doctorPicture.layer.cornerRadius = self.doctorPicture.frame.height / 1.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set cell data
    func setData(doctor: Doctor) {
        if !doctor.getPicture()!.isEmpty { self.doctorPicture.image = UIImage(named: doctor.getPicture()!) }
         self.doctorFullname.text = doctor.getFullname()
         self.doctorSpeciality.text = doctor.getSpeciality()
         self.doctorAddress.text = doctor.GetCityCountry()
    }
}
