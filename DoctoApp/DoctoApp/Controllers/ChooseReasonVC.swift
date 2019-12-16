//
//  ChooseReasonVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol ChooseReasonDelegator {
    func chooseReason(reason: Reason)
}

class ChooseReasonVC: UIViewController {
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var reasonList: UITableView!
    
    private var reasons: [Reason] = []

    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view
    private var reason: Reason?

    private static let reasonItemCellIdentifer: String = "reason_item_cell"
    private static let chooseAvailabilitySegueIdentifier: String = "choose_availability_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {        
        self.reasonList.delegate = self
        self.reasonList.dataSource = self
        self.reasons = self.doctor.getReasons()!
        self.doctorFullname.text = self.doctor.getFullname()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChooseReasonVC.chooseAvailabilitySegueIdentifier
            && segue.destination is ChooseAvailabilityVC {
            let chooseAvailabilityVC = segue.destination as! ChooseAvailabilityVC
            chooseAvailabilityVC.reason = self.reason
            chooseAvailabilityVC.doctor = self.doctor
            chooseAvailabilityVC.patient = self.patient
        }
    }
}

extension ChooseReasonVC: UITableViewDelegate, UITableViewDataSource, ChooseReasonDelegator {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reason: Reason = self.reasons[indexPath.row]
        let reasonItemCell = tableView.dequeueReusableCell(withIdentifier: ChooseReasonVC.reasonItemCellIdentifer) as! ReasonItemCell
        reasonItemCell.chooseReasonDelegate = self
        reasonItemCell.setData(
            reason: reason, 
            doctor: self.doctor, 
            patient: self.patient
        )
        
        return reasonItemCell
    }
    
    func chooseReason(reason: Reason) {
        self.reason = reason
        self.performSegue(withIdentifier: ChooseReasonVC.chooseAvailabilitySegueIdentifier, sender: nil)
    }
}
