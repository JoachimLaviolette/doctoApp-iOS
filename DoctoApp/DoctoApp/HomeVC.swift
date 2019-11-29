//
//  ViewController.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 26/11/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialize()
    }
    
    private func Initialize() {
        // Remove seach bar borders
        self.searchBar.backgroundImage = UIImage()
    }
}

