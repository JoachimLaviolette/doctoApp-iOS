//
//  AvailabilitiesForDayItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class AvailabilitiesForDayItemCell: UITableViewCell {
    var chooseAvailabilityDelegate: ChooseAvailabilityDelegator! // must be set by the calling view
    
    @IBOutlet weak var availabilitiesFullDate: UILabel!
    @IBOutlet weak var timesList: UITableView!

    var availabilitiesForDay: [String: [Availability]]! // must be set by the calling view
    var reason: Reason! // must be set by the calling view
    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view

    private static let availabilityItemCellIdentifer: String = "availability_item_cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timesList.delegate = self
        self.timesList.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(availabilitiesForDay: [String: [Availability]], reason: Reason, doctor: Doctor, patient: Patient) {   
        self.availabilitiesForDay = availabilitiesForDay
        self.reason = reason   
        self.doctor = doctor
        self.patient = patient
        self.availabilitiesFullDate.text = availabilitiesForDay.first?.key
    }
}

extension AvailabilitiesForDayItemCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fullDateKey: String = (availabilitiesForDay.first?.key)!
        
        return self.availabilitiesForDay[fullDateKey]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fullDateKey: String = (self.availabilitiesForDay.first?.key)!
        let availabilitiesForDay: [Availability] = self.availabilitiesForDay[fullDateKey]!
        let availability: Availability = availabilitiesForDay[indexPath.row]
        let availabilityItemCell = tableView.dequeueReusableCell(withIdentifier: AvailabilitiesForDayItemCell.availabilityItemCellIdentifer) as! AvailabilityItemCell
        availabilityItemCell.chooseAvailabilityDelegate = self.chooseAvailabilityDelegate
        
        availabilityItemCell.setData(
            availability: availability, 
            reason: self.reason, 
            doctor: self.doctor, 
            patient:self.patient
        )
        
        return availabilityItemCell
    }
}
