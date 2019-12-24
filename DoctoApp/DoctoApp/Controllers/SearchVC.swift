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
    private var loggedUser: Resident? = nil // can be retrieved from the user defaults

    private static let xibFile: String = "DoctorPreviewItemCell"
    private static let doctorPreviewItemCellIdentifer: String = "doctor_preview_item_cell"
    private static let doctorProfileSegueIdentifier: String = "doctor_profile_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    // Initialize controller properties
    private func initialize() {
        self.tryGetLoggedUser()
        
        self.searchBar.delegate = self
        
        self.searchList.delegate = self
        self.searchList.dataSource = self
        
        // Register cell and setup
        self.searchList.register(UINib.init(nibName: SearchVC.xibFile, bundle: nil), forCellReuseIdentifier: SearchVC.doctorPreviewItemCellIdentifer)
        self.searchList.rowHeight = UITableView.automaticDimension
        self.searchList.separatorColor = UIColor.clear
        
        // UI setup
        self.searchBar.backgroundImage = UIImage()
        
        // Get the doctors from the database according to the bar content
        self.updateDoctorResults(needle: self.searchBar.text)
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
        if segue.identifier == SearchVC.doctorProfileSegueIdentifier
            && segue.destination is DoctorProfileVC {
            let doctorProfileVC = segue.destination as! DoctorProfileVC
            doctorProfileVC.setData(doctor: self.doctor!)
        }
    }
    
    // Search action triggered by the search button
    @IBAction func search(_ sender: UIButton) {
        self.updateDoctorResults(needle: self.searchBar.text)
    }
    
    // Update the list of doctors
    private func updateDoctorResults(needle: String?) {
        self.doctors = self.doctorDbHelper.getDoctors(needle: needle)
        self.searchList.reloadData()
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateDoctorResults(needle: searchText)
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
