//
//  SearchVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchList: UITableView!
    
    private var doctorDbHelper: DoctorDatabaseHelper = DoctorDatabaseHelper()
    private var doctors: [Doctor] = []
    private var doctor: Doctor?

    private static let xibFile: String = "DoctorPreviewItemCell"
    private static let doctorPreviewItemCellIdentifer: String = "doctor_preview_item_cell"
    private static let doctorProfileSegueIdentifier: String = "doctor_profile_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    // Initialize controller properties
    private func initialize() {
        self.searchList.delegate = self
        self.searchList.dataSource = self
        
        // Register cell and setup
        self.searchList.register(UINib.init(nibName: SearchVC.xibFile, bundle: nil), forCellReuseIdentifier: SearchVC.doctorPreviewItemCellIdentifer)
        self.searchList.rowHeight = UITableView.automaticDimension
        self.searchList.separatorColor = UIColor.clear
        
        // UI setup
        self.searchBar.backgroundImage = UIImage()
        
        // Feed models
        self.doctors.append(Doctor(id: 0, lastname: "LAVIOLETTE", firstname: "Joachim", email: "joachim.laviolete@gmail.com", pwd: "Test", pwdSalt: "Test2X", lastLogin: "2019-12-16", picture: "", address: Address(id: 0, street1: "8 rue de la plaine", street2: "Bat A26", city: "Paris", zip: "75008", country: "France"), speciality: "Pediatrician", description: "Specialized in children auscultation", contactNumber: "0660170694", underAgreement: true, healthInsuranceCard: true, thirdPartyPayment: true, header: ""))
        
        self.doctors.append(Doctor(id: 0, lastname: "LAVIOLETTE", firstname: "Joachim", email: "joachim.laviolete@gmail.com", pwd: "Test", pwdSalt: "Test2X", lastLogin: "2019-12-16", picture: "", address: Address(id: 0, street1: "8 rue de la plaine", street2: "Bat A26", city: "Paris", zip: "75008", country: "France"), speciality: "Pediatrician", description: "Specialized in children auscultation", contactNumber: "0660170694", underAgreement: true, healthInsuranceCard: true, thirdPartyPayment: true, header: ""))
        
        self.doctors.append(Doctor(id: 0, lastname: "LAVIOLETTE", firstname: "Joachim", email: "joachim.laviolete@gmail.com", pwd: "Test", pwdSalt: "Test2X", lastLogin: "2019-12-16", picture: "", address: Address(id: 0, street1: "8 rue de la plaine", street2: "Bat A26", city: "Paris", zip: "75008", country: "France"), speciality: "Pediatrician", description: "Specialized in children auscultation", contactNumber: "0660170694", underAgreement: true, healthInsuranceCard: true, thirdPartyPayment: true, header: ""))
    
        self.searchList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SearchVC.doctorProfileSegueIdentifier
            && segue.destination is DoctorProfileVC {
            let doctorProfileVC = segue.destination as! DoctorProfileVC
            doctorProfileVC.doctor = self.doctor
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let doctorPreviewItemCell = Bundle.main.loadNibNamed(SearchVC.xibFile, owner: self, options: nil)?.first as! DoctorPreviewItemCell
        doctorPreviewItemCell.selectionStyle = .none
        doctorPreviewItemCell.setData(doctor: self.doctors[indexPath.row])
        
        return doctorPreviewItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.doctor = self.doctors[indexPath.row]
        performSegue(withIdentifier: SearchVC.doctorProfileSegueIdentifier, sender: nil)
    }
}
