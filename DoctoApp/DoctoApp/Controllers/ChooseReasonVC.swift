//
//  ChooseReasonVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ChooseReasonVC: UIViewController {
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var reasonList: UITableView!
    
    private var reasons: [Reason] = []

    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view

    private static let reasonItemCellIdentifer: String = "reason_item_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {        
        self.reasonList.delegate = self
        self.reasonList.dataSource = self
        self.reasons = self.doctor.getReasons()
        self.doctorFullname.text = self.doctor.getFullname()
    }
}

extension ChooseReasonVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reason: Reason = self.reasons[indexPath.row]
        let reasonItemCell = tableView.dequeueReusableCell(withIdentifier: reasonItemCellIdentifer) as! ReasonItemCell
        reasonItemCell.setData(
            reason: reason, 
            doctor: self.doctor, 
            patient: self.patient
        )
        
        return reasonItemCell
    }
}
