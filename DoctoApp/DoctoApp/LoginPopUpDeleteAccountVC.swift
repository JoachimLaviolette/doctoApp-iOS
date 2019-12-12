//
//  LoginPopUpDeleteAccountVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 11/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class LoginPopUpDeleteAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discardDeleteAccount(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        // TO DO Delete Account Logic
        
        dismiss(animated: true, completion: nil)
    }
    
}
