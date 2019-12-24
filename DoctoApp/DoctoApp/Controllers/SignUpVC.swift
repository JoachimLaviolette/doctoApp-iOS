//
//  SignUpVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 13/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit


class SignUpVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var feedbackMessage: FeedbackMessageView!
    
    @IBOutlet weak var patientProfilePicture: UIImageView!
    
    @IBOutlet weak var selectPictureBtn: UIButton!
    @IBOutlet weak var takePictureBtn: UIButton!
    
    @IBOutlet weak var patientEmail: UITextField!
    @IBOutlet weak var patientFirstName: UITextField!
    @IBOutlet weak var patientLastName: UITextField!
    @IBOutlet weak var patientPwd: UITextField!
    @IBOutlet weak var patientConfirmPwd: UITextField!
    @IBOutlet weak var patientBirthDate: UITextField!
    @IBOutlet weak var patientInsuranceNumber: UITextField!
    @IBOutlet weak var patientStreet1: UITextField!
    @IBOutlet weak var patientStreet2: UITextField!
    @IBOutlet weak var patientCity: UITextField!
    @IBOutlet weak var patientZip: UITextField!
    @IBOutlet weak var patientCountry: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    private var patientDbHelper: PatientDatabaseHelper = PatientDatabaseHelper()
    private var patient: Patient?
    private var loggedUser: Resident? = nil // can be retrieved from the user defaults

   private static let photoIcon = "ic_take_picture"
    private static let galleryIcon = "ic_add_image"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    private func initialize() {
        self.tryGetLoggedUser()
        
        // Make a circle profile picture
        self.patientProfilePicture.layer.masksToBounds = true
        self.patientProfilePicture.layer.cornerRadius = patientProfilePicture.frame.width / 2
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
    
    // Setup actions buttons
    private func setupButtonsIconsColors() {
        var takePictureBtnIcon: UIImage? = UIImage(named: SignUpVC.photoIcon)
        var selectFromGalleryIcon: UIImage? = UIImage(named: SignUpVC.galleryIcon)
        
        takePictureBtnIcon = takePictureBtnIcon?.withRenderingMode(.alwaysTemplate)
        selectFromGalleryIcon = selectFromGalleryIcon?.withRenderingMode(.alwaysTemplate)

        self.takePictureBtn.setImage(takePictureBtnIcon, for: .normal)
        self.selectPictureBtn.setImage(selectFromGalleryIcon, for: .normal)
        
        self.takePictureBtn.tintColor = UIColor(hex: Colors.SIGNUP_TAKE_PICTURE_FROM_CAMERA_TEXT)
        self.selectPictureBtn.tintColor = UIColor(hex: Colors.SIGNUP_SELECT_PICTURE_FROM_GALLERY_TEXT)
        
        self.takePictureBtn.imageView?.contentMode = .scaleAspectFit
        self.selectPictureBtn.imageView?.contentMode = .scaleAspectFit
        
        self.takePictureBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.selectPictureBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
    }
    
    private func setContent() {
        if (self.loggedUser != nil) { self.setSignupContextForPatient()}
        else { self.setSignupContext() }
    }
    
    private func setSignupContext() {
        self.feedbackMessage.isHidden = true
        self.signupBtn.setTitle(Strings.SIGNUP_PRO_BTN, for: .normal)
        
        self.patientEmail.text = ""
        self.patientFirstName.text = ""
        self.patientLastName.text = ""
        self.patientPwd.text = ""
        self.patientConfirmPwd.text = ""
        self.patientBirthDate.text = ""
        self.patientInsuranceNumber.text = ""
        self.patientStreet1.text = ""
        self.patientStreet2.text = ""
        self.patientCity.text = ""
        self.patientZip.text = ""
        self.patientCountry.text = ""
    }
    
    private func setSignupContextForPatient() {
        let patient: Patient = self.loggedUser as! Patient
        self.feedbackMessage.isHidden = true
        self.signupBtn.titleLabel!.text = Strings.MY_PROFILE_PRO_UPDATE_BTN.uppercased()
        
        if patient.getPicture() != nil {
            if !patient.getPicture()!.isEmpty {
                self.patientProfilePicture.image = UIImage(named: patient.getPicture()!)
            }
        }
        
        self.patientEmail.text = patient.getEmail()
        self.patientFirstName.text = patient.getFirstname()
        self.patientLastName.text = patient.getLastname()
        self.patientPwd.text = ""
        self.patientConfirmPwd.text = ""
        self.patientBirthDate.text = patient.getBirthdate()
        self.patientInsuranceNumber.text = patient.getInsuranceNumber()
        self.patientStreet1.text = patient.GetStreet1()
        self.patientStreet2.text = patient.GetStreet2()
        self.patientCity.text = patient.GetCity()
        self.patientZip.text = patient.GetZip()
        self.patientCountry.text = patient.GetCountry()
    }
    
    @IBAction private func signup(_ sender: Any) {
        if (!allFieldsCorrect()){
            self.displayErrorMsg()
            return
        }
        
        //hash the password and salt
        let inputPwd = self.patientPwd.text!
        let salt = inputPwd.isEmpty ? self.loggedUser?.getPwdSalt() : UUID().uuidString
        let hashedInputPwd = inputPwd.isEmpty ? self.loggedUser?.getPwd() : inputPwd + salt! //TO DO: hash it with SHA1
        
        let address: Address = Address(
            id: self.loggedUser == nil ? -1 : (self.loggedUser?.GetAddressId())!,
            street1: StringFormatterService.CapitalizeOnly(str: self.patientStreet1.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            street2: StringFormatterService.CapitalizeOnly(str: self.patientStreet2.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            city: StringFormatterService.CapitalizeOnly(str: self.patientCity.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            zip: self.patientZip.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            country: StringFormatterService.Capitalize(str: self.patientCountry.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        )
        
        let patient = Patient(
            id: self.loggedUser == nil ? -1 : (self.loggedUser?.getId())!,
            lastname: StringFormatterService.CapitalizeOnly(str: self.patientLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            firstname: StringFormatterService.CapitalizeOnly(str: self.patientFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            email: self.patientEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            pwd: hashedInputPwd!,
            pwdSalt: salt!,
            lastLogin: DateTimeService.GetCurrentDateTime(),
            picture: "",
            address: address,
            birthdate: self.patientBirthDate.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            insuranceNumber: self.patientInsuranceNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        if self.loggedUser == nil {
            if self.patientDbHelper.createPatient(patient: patient) {
                self.displaySuccessMsg()
                
                return
            }
        } else {
            if self.patientDbHelper.updatePatient(patient: patient) {
                self.displaySuccessMsg()
                
                return
            }
        }
        
        self.displayErrorMsg()
        
    }
    
    // Check that all the fields are filled properly
    private func allFieldsCorrect() -> Bool {
        let isOneFieldEmpty: Bool = self.loggedUser == nil
            ? (self.patientLastName.text?.isEmpty)! || (self.patientFirstName.text?.isEmpty)! || (self.patientBirthDate.text?.isEmpty)! || (self.patientEmail.text?.isEmpty)! || (self.patientPwd.text?.isEmpty)! || (self.patientConfirmPwd.text?.isEmpty)! || (self.patientInsuranceNumber.text?.isEmpty)! || (self.patientStreet1.text?.isEmpty)! || (self.patientCity.text?.isEmpty)! || (self.patientZip.text?.isEmpty)! || (self.patientCountry.text?.isEmpty)!
            : (self.patientLastName.text?.isEmpty)! || (self.patientFirstName.text?.isEmpty)! || (self.patientBirthDate.text?.isEmpty)! || (self.patientEmail.text?.isEmpty)! || (self.patientInsuranceNumber.text?.isEmpty)! || (self.patientStreet1.text?.isEmpty)! || (self.patientCity.text?.isEmpty)! || (self.patientZip.text?.isEmpty)! || (self.patientCountry.text?.isEmpty)!
        
        // One of the fields is empty
        if (isOneFieldEmpty) { return false }
        
        if self.loggedUser == nil || (self.loggedUser != nil && !(self.patientPwd.text?.isEmpty)!) {
            let bothPwdEqual: Bool = (self.patientPwd.text?.elementsEqual(self.patientConfirmPwd.text!))!
            
            //Both passwords do not correspond
            if (!bothPwdEqual) { return false }
        }
        
        // TO DO: Check the Birthdate format
        /* let range = NSRange(location: 0, length: patientBirthDate.text!.utf16.count)
        let regex = try! NSRegularExpression(pattern: "\\d{4}-{01|02|03|04|05|06|07|08|09|10|11|12}-\\d{2}")
        let isBirthDateCorrectFormat = regex.firstMatch(in: patientBirthDate.text!, options: [], range: range) != nil
        */
        
        return true
    }
    
    // Display success msg
    private func displayErrorMsg() {
        self.feedbackMessage.isHidden = false
        self.feedbackMessage.setData(
            title: Strings.SIGNUP_ERROR_MSG_TITLE,
            content: Strings.SIGNUP_ERROR_MSG_CONTENT,
            isErrorMsg: true
        )
        self.scrollToTop()
    }
    
    // Display error msg
    private func displaySuccessMsg() {
        self.feedbackMessage.isHidden = false
        self.feedbackMessage.setData(
            title: Strings.SIGNUP_SUCCESS_MSG_TITLE,
            content: Strings.SIGNUP_SUCCESS_MSG_CONTENT,
            isErrorMsg: false
        )
        self.scrollToTop()
    }
    
    // Scroll to the top of the scroll view
    private func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
        self.scrollView.setContentOffset(topOffset, animated: true)
    }
    
}
