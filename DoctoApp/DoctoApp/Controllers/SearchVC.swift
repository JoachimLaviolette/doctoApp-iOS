//
//  SearchVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol SearchDelegator {
    func showDoctorProfile(doctor: Doctor)
}

class SearchVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchList: UITableView!
    
    private var doctorDbHelper: DoctorDatabaseHelper = DoctorDatabaseHelper()
    private var doctors: [Doctor] = []
    private var doctor: Doctor?

    private static let searchItemCellIdentifer: String = "search_item_cell"
    private static let doctorProfileSegueIdentifier: String = "doctor_profile_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    // Initialize controller properties
    private func initialize() {        
        self.searchList.delegate = self
        self.searchList.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SearchVC.doctorProfileSegueIdentifier
            && segue.destination is DoctorProfileVC {
            let doctorProfileVC = segue.destination as! DoctorProfileVC
            doctorProfileVC.doctor = self.doctor
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource, SearchDelegator {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let doctor: Doctor = self.doctors[indexPath.row]
        let searchItemCell = tableView.dequeueReusableCell(withIdentifier: SearchVC.searchItemCellIdentifer) as! SearchItemCell
        searchItemCell.searchDelegate = self
        searchItemCell.setData(doctor: doctor)
        
        return searchItemCell
    }
    
    func showDoctorProfile(doctor: Doctor) {
        self.doctor = doctor
        self.performSegue(withIdentifier: SearchVC.doctorProfileSegueIdentifier, sender: nil)
    }
}
