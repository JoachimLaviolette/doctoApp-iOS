//
//  LoginVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 09/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
   
    @IBOutlet weak var loginMsg: UIView!
    @IBOutlet weak var deleteAccountMsg: UIView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var stayLogged: UISwitch!
    @IBOutlet weak var forgotPwd: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var optionsSection: UIStackView!
    @IBOutlet weak var signupSection: UIView!
    @IBOutlet weak var professionalSection: UIView!
    @IBOutlet weak var myProfileBtn: UIButton!
    @IBOutlet weak var myBookingsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

}
