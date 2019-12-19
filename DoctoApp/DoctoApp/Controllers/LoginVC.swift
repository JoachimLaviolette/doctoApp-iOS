//
//  LoginVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 09/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    private var loggedUser: Resident?
    private var toRedirect: Bool = false // can be setby the calling view
    
    @IBOutlet weak var loginMsg: UIView!
    @IBOutlet weak var loginMsgTitle: UILabel!
    @IBOutlet weak var loginMsgContent: UILabel!
    @IBOutlet weak var deleteAccountMsg: UIView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var stayLogged: UISwitch!
    @IBOutlet weak var forgotPwd: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var optionsSection: UIStackView!
    @IBOutlet weak var signupSection: UIView!
    @IBOutlet weak var deleteMyAccountBtn: UIButton!
    @IBOutlet weak var professionalSection: UIView!
    @IBOutlet weak var myProfileBtn: UIButton!
    @IBOutlet weak var myBookingsBtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setContent()
    }
    
    private func setContent() -> Void {
        self.setLoginContext()
        
        if (self.loggedUser != nil) {
            self.displaySuccessMsg()
        }
        
    }
    
    private func setLoginContext() -> Void {
        emailInput.isHidden = false
        passwordInput.isHidden = false
        optionsSection.isHidden = false
        loginBtn.isHidden = false
        myProfileBtn.isHidden = true
        myBookingsBtn.isHidden = true
        deleteMyAccountBtn.isHidden = true
        logoutBtn.isHidden = true
        signupSection.isHidden = false
        professionalSection.isHidden = false
        loginMsg.isHidden = true
        deleteAccountMsg.isHidden = true
        emailInput.text = ""
        passwordInput.text  = ""
        stayLogged.setOn(false, animated: false)
        
    }
    
    @IBAction func login(_ sender: Any) {
        var success: Bool = self.tryLoginAsPatient()
        
        if (!self.toRedirect && !success) { success = self.tryLoginAsDoctor() }
        if (!success) { self.displayErrorMsg() }
    }
    
    private func tryLoginAsPatient() -> Bool {
        let inputEmail: String = emailInput.text ?? ""
        
        // Try to get a patient using the provided email
        let patient: Patient? = PatientDatabaseHelper().getPatient(patientId: nil, email: inputEmail, fromDoctor: false)
        
        // If the email isn't matched
        if (patient == nil) { return false }
        
        //Check the password
        let inputPwd = passwordInput.text!
        let salt = patient?.getPwdSalt()
        let hashedInputPwd = inputPwd + salt! //TO DO: hash it with SHA1
        let patientPwd = patient?.getPwd()
        
        // If the password isn't matched
        if (patient!.getPwd() != hashedInputPwd) { return false }
        
        self.displaySuccessMsg()
        self.loggedUser = patient
        
        if (self.toRedirect) {
             //REDIRECT
        }
        
        return true
    }
    
    private func tryLoginAsDoctor() -> Bool {
        let inputEmail: String = emailInput.text ?? ""
        
        // Try to get a patient using the provided email
        let doctor: Doctor? = DoctorDatabaseHelper().getDoctor(doctorId: nil, email: inputEmail, fromPatient: false)
        
        // If the email isn't matched
        if (doctor == nil) {
            return false
        }
        
        //Check the password
        let inputPwd = passwordInput.text!
        let salt = doctor?.getPwdSalt()
        let hashedInputPwd = inputPwd + salt! //TO DO: hash it with SHA1
        let patientPwd = doctor?.getPwd()
        
        // If the password isn't matched
        if ((patientPwd?.elementsEqual(hashedInputPwd))!) {
            return false
        }
        
        self.displaySuccessMsg()
        self.loggedUser = doctor
        
        if (self.toRedirect) {
            //REDIRECT
        }
        
        return true
    }
    
    private func displaySuccessMsg() -> Void {
        loginMsg.isHidden = false
        loginMsg.backgroundColor = UIColor(hex: Colors.LOGIN_SUCCESS_MSG)
        loginMsgTitle.text = Strings.LOGIN_SUCCESS_MSG_TITLE
        loginMsgContent.text = Strings.LOGIN_SUCCESS_MSG_CONTENT
        deleteAccountMsg.isHidden = true
        emailInput.isHidden = true
        passwordInput.isHidden = true
        optionsSection.isHidden = true
        loginBtn.isHidden = true
        myProfileBtn.isHidden = false
        myBookingsBtn.isHidden = false
        deleteMyAccountBtn.isHidden = false
        logoutBtn.isHidden = false
        signupSection.isHidden = true
        professionalSection.isHidden = true
    }
    
    private func displayErrorMsg() {
        loginMsg.isHidden = false
        loginMsg.backgroundColor = UIColor(hex: Colors.LOGIN_ERROR_MSG)
        loginMsgTitle.text = Strings.LOGIN_ERROR_MSG_TITLE
        loginMsgContent.text = Strings.LOGIN_ERROR_MSG_CONTENT
    }
    
    @IBAction func logout(_ sender: Any) {
        self.loggedUser = nil
        self.setLoginContext()
    }
}
