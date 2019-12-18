//
//  ChooseReasonVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ChooseReasonVC: UIViewController {
    @IBOutlet weak var headerDashboardSubtitle: HeaderDashboardSubtitleView!
    @IBOutlet weak var reasonList: UITableView!
    
    private var reasons: [Reason] = []

    var doctor: Doctor! // must be set by the calling view
    var patient: Patient! // must be set by the calling view
    private var reason: Reason?

    private static let headerTitle: String = "Book an appointment"
    private static let reasonItemCellIdentifer: String = "reason_item_cell"
    private static let chooseAvailabilitySegueIdentifier: String = "choose_availability_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        // Update doctor model to get most recent changes
        self.doctor = self.doctor.update() as? Doctor
        
        // Retrieve reasons
        self.reasons = self.doctor.getReasons() ?? []
        
        self.reasonList.delegate = self
        self.reasonList.dataSource = self

        // Setup cell
        self.reasonList.rowHeight = UITableView.automaticDimension
        self.reasonList.separatorColor = UIColor(hex: Colors.FORGOT_PASSWORD_BACKGROUND)
        
        self.setHeaderData()

        // Setup patient test model
        self.patient = Patient(id: 0, lastname: "FRANCO", firstname: "James", email: "james.franco@gmail.com", pwd: "Test", pwdSalt: "Test3X", lastLogin: "2019-12-16", picture: "pp4", address: Address(id: -1, street1: "3 place Henry IV", street2: "", city: "Paris", zip: "75016", country: "France"), birthdate: "1996-05-23", insuranceNumber: "02153562365602")
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
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboardSubtitle.headerTitle.text = ChooseReasonVC.headerTitle
        self.headerDashboardSubtitle.headerSubtitle.text = self.doctor.getFullname()
    }
}

extension ChooseReasonVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reasonItemCell = tableView.dequeueReusableCell(withIdentifier: ChooseReasonVC.reasonItemCellIdentifer, for: indexPath) as! ReasonItemCell
        reasonItemCell.selectionStyle = .none
        reasonItemCell.setData(reason: self.reasons[indexPath.row])
        
        return reasonItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reason = self.reasons[indexPath.row]
    }
}
