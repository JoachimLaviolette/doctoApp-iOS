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
    
    static let patientCellIdentifer: String = "appointment_patient_TVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.AppointmentTableView.delegate = self
        self.AppointmentTableView.dataSource = self
        
    }


}

extension MyBookingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyBookingsVC.patientCellIdentifer) as! AppointmentPatientItemTVC
        // cell.patientLastname.text = "Name"
        print("LA")
        return cell
        
    }
    
    
    
}
