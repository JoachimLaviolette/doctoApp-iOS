//
//  HomeVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 26/11/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    private func initialize() {
        // Remove seach bar borders
        self.searchBar.backgroundImage = UIImage()
    }
}

