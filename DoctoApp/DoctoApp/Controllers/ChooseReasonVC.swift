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

    private var doctor: Doctor! // must be set by the calling view
    private var patient: Patient! // must be retrieved from the user defaults
    private var reason: Reason?
    private var loggedUser: Resident? = nil

    private static let headerTitle: String = "Book an appointment"
    private static let reasonItemCellIdentifer: String = "reason_item_cell"
    private static let chooseAvailabilitySegueIdentifier: String = "choose_availability_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.tryGetLoggedUser()
        
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
    }
    
    // Try to get a logged user id from the user defaults
    private func tryGetLoggedUser() {
        if self.loggedUser == nil {
            if UserDefaults.standard.string(forKey: Strings.USER_TYPE_KEY) == Strings.USER_TYPE_PATIENT {
                let patientId = UserDefaults.standard.integer(forKey: Strings.USER_ID_KEY)
                let patient: Patient = PatientDatabaseHelper().getPatient(patientId: patientId, email: nil, fromDoctor: false)!
                self.loggedUser = patient
            } else if UserDefaults.standard.string(forKey: Strings.USER_TYPE_KEY) == Strings.USER_TYPE_DOCTOR {
                let doctorId = UserDefaults.standard.integer(forKey: Strings.USER_ID_KEY)
                let doctor: Doctor = DoctorDatabaseHelper().getDoctor(doctorId: doctorId, email: nil, fromPatient: false)!
                self.loggedUser = doctor
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChooseReasonVC.chooseAvailabilitySegueIdentifier
            && segue.destination is ChooseAvailabilityVC {
            let chooseAvailabilityVC = segue.destination as! ChooseAvailabilityVC
            chooseAvailabilityVC.setData(
                doctor: self.doctor,
                reason: self.reason!
            )
        }
    }
    
    // Set view data
    func setData(doctor: Doctor) {
        self.doctor = doctor
    }
    
    // Set header data
    func setHeaderData() {
        self.headerDashboardSubtitle.setData(
            headerDelegator: self,
            headerTitle: Strings.CHOOSE_REASON_TITLE_1,
            headerSubtitle: self.doctor.getFullname()
        )
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
        performSegue(withIdentifier: ChooseReasonVC.chooseAvailabilitySegueIdentifier, sender: nil)
    }
}
