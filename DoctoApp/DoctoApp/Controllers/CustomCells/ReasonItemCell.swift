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
    
    var reason: Reason! // must be set by the calling view
    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view
    
    private static let chooseAvailabilitySegueIdentifier: String = "choose_availability_segue"

    func setData(reason: Reason, doctor: Doctor, patient: Patient) {   
        self.reason = reason   
        self.doctor = doctor
        self.patient = patient
        self.reasonDescription.text = self.reason.getDescription()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.chooseAvailabilities()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == chooseAvailabilitySegueIdentifier
            && segue.destination is ChooseAvailabilityVC {
            let chooseAvailabilityVC = segue.destination as! ChooseAvailabilityVC
            chooseAvailabilityVC.reason = self.reason
            chooseAvailabilityVC.doctor = self.doctor
            chooseAvailabilityVC.patient = self.patient
        }
    }

    // Display availabilities
    private func chooseAvailability() {
        performSegueWithIdentifier(chooseAvailabilitySegueIdentifier, sender: self)
    }
}
