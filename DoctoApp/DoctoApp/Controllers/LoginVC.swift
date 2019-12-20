//
//  LoginVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 09/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var feedbackMessage: FeedbackMessageView!
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var stayLogged: UISwitch!
    @IBOutlet weak var forgotPwd: UIButton!
    
    @IBOutlet weak var optionsSection: UIStackView!
    @IBOutlet weak var signupSection: UIView!
    @IBOutlet weak var professionalSection: UIView!
    
    @IBOutlet weak var myProfileBtn: UIButton!
    @IBOutlet weak var myBookingsBtn: UIButton!
    @IBOutlet weak var deleteMyAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var loggedUser: Resident? // set when a successful login was made
    private var toRedirect: Bool = false // can be setby the calling view
    
    private static let myBookingsSegueIdentifier: String = "my_bookings_segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.setContent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LoginVC.myBookingsSegueIdentifier
            && segue.destination is MyBookingsVC {
            let myBookingsVC = segue.destination as! MyBookingsVC
            myBookingsVC.setData(loggedUser: self.loggedUser!)
        }
    }
    
    // Set basic view content
    private func setContent() {
        self.displayLoginContext()
        
        if (self.loggedUser != nil) {
            self.displaySuccessMsg()
            self.displaySuccessContent()
        }
    }
    
    // Display login content
    private func displayLoginContext() {
        self.emailInput.isHidden = false
        self.passwordInput.isHidden = false
        self.optionsSection.isHidden = false
        self.loginBtn.isHidden = false
        self.myProfileBtn.isHidden = true
        self.myBookingsBtn.isHidden = true
        self.deleteMyAccountBtn.isHidden = true
        self.logoutBtn.isHidden = true
        self.signupSection.isHidden = false
        self.professionalSection.isHidden = false
        self.feedbackMessage.isHidden = true
        self.emailInput.text = ""
        self.passwordInput.text  = ""
        self.stayLogged.setOn(false, animated: false)
        
        self.myProfileBtn.imageView?.contentMode = .scaleAspectFit
        self.myBookingsBtn.imageView?.contentMode = .scaleAspectFit
        self.deleteMyAccountBtn.imageView?.contentMode = .scaleAspectFit
        self.logoutBtn.imageView?.contentMode = .scaleAspectFit
        
        self.myProfileBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.myBookingsBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.deleteMyAccountBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.logoutBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
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
        
        // If the password isn't matched
        if (patient!.getPwd() != hashedInputPwd) { return false }
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
        if (doctor == nil) { return false }
        
        //Check the password
        let inputPwd = passwordInput.text!
        let salt = doctor?.getPwdSalt()
        let hashedInputPwd = inputPwd + salt! //TO DO: hash it with SHA1
        let patientPwd = doctor?.getPwd()
        
        // If the password isn't matched
        if ((patientPwd?.elementsEqual(hashedInputPwd))!) {
            return false
        }
        
        self.loggedUser = doctor
        
        return true
    }
    
    // Display a success message after a successful login
    private func displaySuccessMsg() {
        self.feedbackMessage.isHidden = false
        self.feedbackMessage.setData(
            title: Strings.LOGIN_SUCCESS_MSG_TITLE,
            content: Strings.LOGIN_SUCCESS_MSG_CONTENT,
            isErrorMsg: false
        )
    }
    
    // Display success components after a successful login
    private func displaySuccessContent() {
        self.emailInput.isHidden = true
        self.passwordInput.isHidden = true
        self.optionsSection.isHidden = true
        self.loginBtn.isHidden = true
        self.myProfileBtn.isHidden = false
        self.myBookingsBtn.isHidden = false
        self.deleteMyAccountBtn.isHidden = false
        self.logoutBtn.isHidden = false
        self.signupSection.isHidden = true
        self.professionalSection.isHidden = true
    }
    
    // Display a error message after a unsuccessful login
    private func displayErrorMsg() {
        self.feedbackMessage.isHidden = false
        self.feedbackMessage.setData(
            title: Strings.LOGIN_ERROR_MSG_TITLE,
            content: Strings.LOGIN_ERROR_MSG_CONTENT,
            isErrorMsg: true
        )
    }
    
    // Login the user
    @IBAction func login(_ sender: Any) {
        var success: Bool = self.tryLoginAsPatient()
        
        if (!self.toRedirect && !success) { success = self.tryLoginAsDoctor() }
        
        if (!success) {
            self.displayErrorMsg()
            
            return
        }
        
        // From here the user is logged
        self.displaySuccessMsg()
        self.displaySuccessContent()
        self.addUserToUserDefaults()
        
        if (self.toRedirect) { self.redirectUser() }
    }
    
    // Logout the current user
    @IBAction func logout(_ sender: Any) {
        self.loggedUser = nil
        self.displayLoginContext()
        self.addUserToUserDefaults()
    }
    
    // Redirect the user to calling view
    private func redirectUser() {
        
    }
    
    // Add the logged user to the user defaults
    private func addUserToUserDefaults() {
        // Check if we have to remember the user or not
        
        // Add to the user defaults
    }
}
