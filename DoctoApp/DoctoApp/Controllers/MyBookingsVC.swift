//
//  MyBookingsVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 13/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class MyBookingsVC: UIViewController {

    @IBOutlet weak var AppointmentTableView: UITableView!
    @IBOutlet weak var headerSubtitle: HeaderSubtitleView!
    
    static let patientCellIdentifer: String = "appointment_patient_TVC"
    private static let headerTitle: String = "My Bookings"
    private static let headerSubtitle: String = "See all the appointments"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.AppointmentTableView.delegate = self
        self.AppointmentTableView.dataSource = self
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.headerSubtitle.headerTitle.text = MyBookingsVC.headerTitle
        self.headerSubtitle.headerSubtitle.text = MyBookingsVC.headerSubtitle
    }



}

extension MyBookingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyBookingsVC.patientCellIdentifer) as! BookingPatientItemCell
        // cell.patientLastname.text = "Name"
        return cell
        
    }
    
    
    
}
