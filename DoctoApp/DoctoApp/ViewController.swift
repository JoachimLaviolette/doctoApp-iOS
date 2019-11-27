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
        self.searchBar.backgroundImage = UIImage()
    }
}

