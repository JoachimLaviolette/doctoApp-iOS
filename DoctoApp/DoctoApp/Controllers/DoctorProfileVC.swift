//
//  DoctorProfileVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class DoctorProfileVC: UITableViewCell {
    @IBOutlet weak var doctorPicture: UIImageView!
    @IBOutlet weak var doctorHeader: UIImageView!
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    
    var doctor: Doctor! // must be set by the calling view
    
    private static let chooseReasonSegueIdentifier: String = "choose_reason_segue"
    private static let loginSegueIdentifier: String = "login_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {        
        // Retrieve most recent changes updating the doctor model
        self.doctor = doctor.update() as! Doctor
    }
}
