//
//  LoginVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 09/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

protocol PopUpActionDelegator {
    func doAction()
}

class LoginVC: UIViewController, PopUpActionDelegator {
    @IBOutlet weak var feedbackMessage: FeedbackMessageView!
    
    @IBOutlet weak var caption: UILabel!
    
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
    
    private var loggedUser: Resident? = nil // set when a successful login was made
    private var toRedirect: Bool = false // can be set by the calling view
    
    private static let myBookingsSegueIdentifier: String = "my_bookings_segue"
    private static let deleteAccountSegueIdentifier: String = "delete_account_segue"
    private static let myProfilePatientSegueIdentifier: String = "my_profile_patient_segue"
    private static let myProfileDoctorSegueIdentifier: String = "my_profile_doctor_segue"

    private static let myProfileIcon = "ic_profile"
    private static let myBookingsIcon = "ic_bookings"
    private static let deleteMyAccountIcon = "ic_delete"
    private static let logoutBtnIcon = "ic_logout"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.loggedUser == nil { self.displayLoginContext() }
    }
    
    // Initialize controller properties
    private func initialize() {
        self.tryGetLoggedUser()
        self.setupButtonsIconsColors()
        self.setContent()
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
        if segue.identifier == LoginVC.deleteAccountSegueIdentifier
            && segue.destination is PopUpVC {
            let popUpVC = segue.destination as! PopUpVC
            popUpVC.setData(
                title: Strings.LOGIN_DELETE_ACCOUNT_POPUP_TITLE,
                content: Strings.LOGIN_DELETE_ACCOUNT_POPUP_CONTENT,
                delegate: self
            )
        }
    }
    
    // Setup actions buttons
    private func setupButtonsIconsColors() {
        var myProfileBtnIcon: UIImage? = UIImage(named: LoginVC.myProfileIcon)
        var myBookingsBtnIcon: UIImage? = UIImage(named: LoginVC.myBookingsIcon)
        var deleteMyAccountBtnIcon: UIImage? = UIImage(named: LoginVC.deleteMyAccountIcon)
        var logoutBtnIcon: UIImage? = UIImage(named: LoginVC.logoutBtnIcon)

        myProfileBtnIcon = myProfileBtnIcon?.withRenderingMode(.alwaysTemplate)
        myBookingsBtnIcon = myBookingsBtnIcon?.withRenderingMode(.alwaysTemplate)
        deleteMyAccountBtnIcon = deleteMyAccountBtnIcon?.withRenderingMode(.alwaysTemplate)
        logoutBtnIcon = logoutBtnIcon?.withRenderingMode(.alwaysTemplate)

        self.myProfileBtn.setImage(myProfileBtnIcon, for: .normal)
        self.myBookingsBtn.setImage(myBookingsBtnIcon, for: .normal)
        self.deleteMyAccountBtn.setImage(deleteMyAccountBtnIcon, for: .normal)
        self.logoutBtn.setImage(logoutBtnIcon, for: .normal)

        self.myProfileBtn.tintColor = UIColor(hex: Colors.SIGNUP_TAKE_PICTURE_FROM_CAMERA_TEXT)
        self.myBookingsBtn.tintColor = UIColor(hex: Colors.SIGNUP_SELECT_PICTURE_FROM_GALLERY_TEXT)
        self.deleteMyAccountBtn.tintColor = UIColor(hex: Colors.SIGNUP_SELECT_PICTURE_FROM_GALLERY_TEXT)
        self.logoutBtn.tintColor = UIColor(hex: Colors.SIGNUP_SELECT_PICTURE_FROM_GALLERY_TEXT)

        self.myProfileBtn.imageView?.contentMode = .scaleAspectFit
        self.myBookingsBtn.imageView?.contentMode = .scaleAspectFit
        self.deleteMyAccountBtn.imageView?.contentMode = .scaleAspectFit
        self.logoutBtn.imageView?.contentMode = .scaleAspectFit

        self.myProfileBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 5, bottom: 30, right: 30)
        self.myBookingsBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 5, bottom: 30, right: 30)
        self.deleteMyAccountBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: -5, bottom: 30, right: 30)
        self.logoutBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 5, bottom: 30, right: 30)
    }
    
    // Set basic view content
    private func setContent() {
        self.caption.font = UIFont.preferredFont(forTextStyle: .footnote).italic() 

        if self.loggedUser != nil {
            self.displaySuccessMsg()
            self.displaySuccessContent()
            
            return
        }
        
        self.displayLoginContext()
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
        
        self.setupButtonsIconsColors()
    }
    
    // Try to login as a patient
    private func tryLoginAsPatient() -> Bool {
        let inputEmail: String = emailInput.text ?? ""
        
        // Try to get a patient using the provided email
        let patient: Patient? = PatientDatabaseHelper().getPatient(patientId: nil, email: inputEmail, fromDoctor: false)
        
        // If the email isn't matched
        if patient == nil { return false }
        
        // Check the password
        let inputPwd = passwordInput.text!
        let salt = patient!.getPwdSalt()
        let hashedInputPwd = EncryptionService.SHA1(string: inputPwd + salt)

        // If the password does not match
        if patient!.getPwd() != hashedInputPwd { return false }
        self.loggedUser = patient
        
        if self.toRedirect {
             //REDIRECT
        }
        
        return true
    }
    
    // Try to login as a doctor
    private func tryLoginAsDoctor() -> Bool {
        let inputEmail: String = emailInput.text ?? ""
        
        // Try to get a patient using the provided email
        let doctor: Doctor? = DoctorDatabaseHelper().getDoctor(doctorId: nil, email: inputEmail, fromPatient: false)
        
        // If the email isn't matched
        if doctor == nil { return false }
        
        // Check the password
        let inputPwd: String = passwordInput.text!
        let salt: String = doctor!.getPwdSalt()
        let hashedInputPwd = EncryptionService.SHA1(string: inputPwd + salt)
        
        // If the password does not match
        if (doctor!.getPwd() != hashedInputPwd) { return false }
        
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
        
        self.setupButtonsIconsColors()
    }
    
    // Display a error message after a unsuccessful login
    private func displayErrorMsg(title: String, content: String) {
        self.feedbackMessage.isHidden = false
        self.feedbackMessage.setData(
            title: title,
            content: content,
            isErrorMsg: true
        )
    }
    
    @IBAction func myProfile(_ sender: Any) {
        if self.loggedUser is Patient { performSegue(withIdentifier: LoginVC.myProfilePatientSegueIdentifier, sender: nil)}
        else if self.loggedUser is Doctor { performSegue(withIdentifier: LoginVC.myProfileDoctorSegueIdentifier, sender: nil)}
    }
    
    
    // Login the user
    @IBAction func login(_ sender: Any) {
        var success: Bool = self.tryLoginAsPatient()
        
        if !self.toRedirect && !success { success = self.tryLoginAsDoctor() }

        if !success {
            self.displayErrorMsg(title: Strings.LOGIN_ERROR_MSG_TITLE, content: Strings.LOGIN_ERROR_MSG_CONTENT)
            
            return
        }
        
        // From here the user is logged
        self.displaySuccessMsg()
        self.displaySuccessContent()
        self.addUserToUserDefaults()
        
        if self.toRedirect { self.redirectUser() }
    }
    
    // Logout the current user
    @IBAction func logout(_ sender: Any) {
        self.loggedUser = nil
        self.removeUserFromUserDefaults()
        self.displayLoginContext()
    }
    
    // Redirect the user to calling view
    private func redirectUser() {
        
    }
    
    // Remove the logged user from the user defaults
    private func removeUserFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Strings.USER_ID_KEY)
        UserDefaults.standard.removeObject(forKey: Strings.USER_TYPE_KEY)
    }
    
    // Add the logged user to the user defaults
    private func addUserToUserDefaults() {
        // Check if we have to remember the user or not
        
        // Add to the user defaults
        if self.loggedUser is Patient {
            UserDefaults.standard.set(self.loggedUser!.getId(), forKey: Strings.USER_ID_KEY)
            UserDefaults.standard.set(Strings.USER_TYPE_PATIENT, forKey: Strings.USER_TYPE_KEY)
        }
        
        if self.loggedUser is Doctor {
            UserDefaults.standard.set(self.loggedUser!.getId(), forKey: Strings.USER_ID_KEY)
            UserDefaults.standard.set(Strings.USER_TYPE_DOCTOR, forKey: Strings.USER_TYPE_KEY)
        }
    }
    
    // Delete Account Action
    func doAction() {
        var isUserDeleted: Bool = false
        
        if self.loggedUser is Patient { isUserDeleted = PatientDatabaseHelper().deletePatient(patient: self.loggedUser as! Patient) }
        else { isUserDeleted = DoctorDatabaseHelper().deleteDoctor(doctor: self.loggedUser as! Doctor) }
        
        if isUserDeleted {
            self.removeUserFromUserDefaults()
            self.navigationController?.popToRootViewController(animated: true)
            
            return
        }
        
        self.displayErrorMsg(title: Strings.LOGIN_DELETE_ACCOUNT_MSG_TITLE, content: Strings.LOGIN_DELETE_ACCOUNT_MSG_CONTENT)
    }
}
