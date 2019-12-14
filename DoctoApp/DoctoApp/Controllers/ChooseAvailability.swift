//
//  ChooseAvailabilityVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ChooseAvailabilityVC: UIViewController {
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var availabilityPerDayList: UITableView!
    
    private var availabilitiesPerDay: [Int: [String: [Availability]]] = [Int: [String: [Availability]]]()

    var reason: Reason! // must be set by the calling view
    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view

    private static let weeksNumber: Int = 1
    private static let availabilitiesForDayItemCellIdentifer: String = "availabilities_for_day_item_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {        
        self.availabilityPerDayList.delegate = self
        self.availabilityPerDayList.dataSource = self
        self.availabilitiesPerDay = self.doctor.getAvailabilitiesPerDay(weeksNumber: weeksNumber)
        self.doctorFullname.text = self.doctor.getFullname()
    }
}

extension ChooseAvailabilityVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availabilitiesPerDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let availabilitiesForDay: [String: [Availability]] = self.availabilitiesPerDay[indexPath.row]
        let availabilitiesForDayItemCell = tableView.dequeueReusableCell(withIdentifier: availabilitiesForDayItemCellIdentifer) as! AvailabilityItemCell
        availabilitiesForDayItemCell.setData(
            availabilitiesForDay: availabilitiesForDay, 
            reason: self.reason, 
            doctor: self.doctor, 
            patient: self.patient
        )
        
        return availabilitiesForDayItemCell
    }
}
