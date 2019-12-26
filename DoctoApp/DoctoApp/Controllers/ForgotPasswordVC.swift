//
//  ForgotPasswordVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 09/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var feedbackMessage: FeedbackMessageView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmPasswordInput: UITextField!
    
    private var patientDbHelper: PatientDatabaseHelper = PatientDatabaseHelper()
    private var doctorDbHelper: DoctorDatabaseHelper = DoctorDatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.setContent()
    }
    
    // Set view content
    private func setContent() {
        self.feedbackMessage.isHidden = true
        self.caption.font = UIFont.preferredFont(forTextStyle: .footnote).italic()
    }
    
    // Reset input fields
    private func resetInputs() {
        self.emailInput.text = ""
        self.passwordInput.text = ""
        self.confirmPasswordInput.text = ""
    }
    
    // Try to set the password associated to the given email address
    @IBAction func setNewPassword(_ sender: Any) {
        if(!self.allFieldsCorrect()) {
            self.displayErrorMessage()
            
            return
        }
        
        var user: Resident? = self.tryLoginAsDoctor()
        
        if user == nil { user = self.tryLoginAsPatient() }
        if user == nil {
            self.displayErrorMessage()
            
            return
        }
        
        //hash the password and salt
        let inputPwd = self.passwordInput.text!
        let salt = UUID().uuidString
        let hashedInputPwd = inputPwd + salt //TO DO: hash it with SHA1
        
        user!.setPwd(pwd: hashedInputPwd)
        user!.setPwdSalt(pwdSalt: salt)
        
        if user is Doctor {
            if(!doctorDbHelper.updateDoctor(doctor: user as! Doctor)) {
                self.displayErrorMessage()
                
                return
            }
        }
        if user is Patient {
            if(!patientDbHelper.updatePatient(patient: user as! Patient)) {
                self.displayErrorMessage()
                
                return
            }
        }
        
        self.displaySuccessMessage()
        self.resetInputs()
    }
    
    // Try to login as a patient
    private func tryLoginAsPatient() -> Patient? {
        let inputEmail: String = emailInput.text ?? ""
        
        // Try to get a patient using the provided email
        let patient: Patient? = PatientDatabaseHelper().getPatient(patientId: nil, email: inputEmail, fromDoctor: false)
        
        return patient
    }
    
    // Try to login as a doctor
    private func tryLoginAsDoctor() -> Doctor? {
        let inputEmail: String = emailInput.text ?? ""
        
        // Try to get a patient using the provided email
        let doctor: Doctor? = DoctorDatabaseHelper().getDoctor(doctorId: nil, email: inputEmail, fromPatient: false)
        
        return doctor
    }
    
    // Check that all the fields are filled properly
    private func allFieldsCorrect() -> Bool {
        let isOneFieldEmpty: Bool = (emailInput.text?.isEmpty)! || (passwordInput.text?.isEmpty)! || (confirmPasswordInput.text?.isEmpty)!
        
        // One of the fields is empty
        if isOneFieldEmpty { return false }
        
        let bothPwdEqual: Bool = (passwordInput.text?.elementsEqual(confirmPasswordInput.text!))!
        
        //Both passwords do not correspond
        if !bothPwdEqual { return false }
        
        return true
    }
    
    // Display success message
    private func displaySuccessMessage() {
        self.feedbackMessage.setData(
            title: Strings.FORGOT_PASSWORD_SUCCESS_MSG_TITLE,
            content: Strings.FORGOT_PASSWORD_SUCCESS_MSG_CONTENT,
            isErrorMsg: false
        )
        self.feedbackMessage.isHidden = false
    }
    
    // Display error message
    private func displayErrorMessage() {
        self.feedbackMessage.setData(
            title: Strings.FORGOT_PASSWORD_ERROR_MSG_TITLE,
            content: Strings.FORGOT_PASSWORD_ERROR_MSG_CONTENT,
            isErrorMsg: true
        )
        self.feedbackMessage.isHidden = false
    }
}
