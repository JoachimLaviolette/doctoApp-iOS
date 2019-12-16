//
//  SearchItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class SearchItemCell: UITableViewCell {
    var searchDelegate: SearchDelegator! // must be set by the calling view
    
    @IBOutlet weak var doctorPicture: UIImageView!
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var doctorAddress: UILabel!
    
    var doctor: Doctor! // must be set by the calling view

    func setData(doctor: Doctor) {   
        self.doctor = doctor   

        if !self.doctor.getPicture()!.isEmpty {
            self.doctorPicture.image = UIImage(named: self.doctor.getPicture()!)
        }

        self.doctorFullname.text = self.doctor.getFullname()
        self.doctorSpeciality.text = self.doctor.getSpeciality()
        self.doctorAddress.text = self.doctor.GetCityCountry()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.showDoctorProfile()
    }

    // Display doctor profile
    private func showDoctorProfile() {
        self.searchDelegate.showDoctorProfile(doctor: self.doctor)
    }
}
