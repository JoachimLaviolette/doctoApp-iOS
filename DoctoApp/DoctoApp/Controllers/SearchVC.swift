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
    
    private var doctorDbHelper: DoctorDatabaseHelper
    private var doctors: [Doctor] = []

    private static let searchItemCellIdentifer: String = "search_item_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    // Initialize controller properties
    private func initialize() {        
        self.searchList.delegate = self
        self.searchList.dataSource = self
        self.doctorDbHelper = DoctorDatabaseHelper()
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let doctor: Doctor = self.doctors[indexPath.row]
        let searchItemCell = tableView.dequeueReusableCell(withIdentifier: searchItemCellIdentifer) as! SearchItemCell
        searchItemCell.setData(doctor: doctor)
        
        return searchItemCell
    }
}
