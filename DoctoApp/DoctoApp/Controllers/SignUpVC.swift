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
    
    @IBOutlet weak var signupMsg: UIView!
    @IBOutlet weak var signupMsgTitle: UILabel!
    @IBOutlet weak var signupMsgContent: UILabel!
    @IBOutlet weak var patientProfilePicture: UIImageView!
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
    
    private var patientDbHelper: PatientDatabaseHelper = PatientDatabaseHelper()
    private var patient: Patient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    private func initialize() {
        // Make a circle profile picture
        
        patientProfilePicture.layer.masksToBounds = true
        patientProfilePicture.layer.cornerRadius = patientProfilePicture.frame.width / 2
        signupMsg.isHidden = true
        
    }
    
    @IBAction private func Signup(_ sender: Any) {
        if (!allFieldsCorrect()){
            self.displayErrorMsg()
            return
        }
        
        let address: Address = Address(
            id: -1,
            street1: StringFormatterService.CapitalizeOnly(str: self.patientStreet1.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            street2: StringFormatterService.CapitalizeOnly(str: self.patientStreet2.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            city: StringFormatterService.CapitalizeOnly(str: self.patientCity.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            zip: self.patientZip.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            country: StringFormatterService.Capitalize(str: self.patientCountry.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        )
        
        let patient = Patient(
            id: -1,
            lastname: StringFormatterService.CapitalizeOnly(str: patientLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            firstname: StringFormatterService.CapitalizeOnly(str: patientFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            email: patientEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            pwd: "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3",
            pwdSalt: "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3",
            lastLogin: DateTimeService.GetCurrentDateTime(),
            picture: "",
            address: address,
            birthdate: patientBirthDate.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            insuranceNumber: patientInsuranceNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        if self.patientDbHelper.createPatient(patient: patient) {
            self.displaySuccessMsg()
            
            return
        }
        
        self.displayErrorMsg()
        
    }
    
    private func allFieldsCorrect() -> Bool {
        let isOneFieldEmpty: Bool = (patientLastName.text?.isEmpty)! || (patientFirstName.text?.isEmpty)! || (patientBirthDate.text?.isEmpty)! || (patientEmail.text?.isEmpty)! || (patientPwd.text?.isEmpty)! || (patientConfirmPwd.text?.isEmpty)! || (patientInsuranceNumber.text?.isEmpty)! || (patientStreet1.text?.isEmpty)! || (patientCity.text?.isEmpty)! || (patientZip.text?.isEmpty)! || (patientCountry.text?.isEmpty)!
        
        // One of the fields is empty
        if (isOneFieldEmpty) {
            return false
        }
        
        let bothPwdEqual: Bool = (patientPwd.text?.elementsEqual(patientConfirmPwd.text!))!
        
        //Both passwords do not correspond
        if (!bothPwdEqual) {
            return false
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
        signupMsg.isHidden = false
        signupMsg.backgroundColor = UIColor(named: "signup_error_msg_color")
        signupMsgTitle.text = Strings.SIGNUP_ERROR_MSG_TITLE
        signupMsgContent.text = Strings.SIGNUP_ERROR_MSG_CONTENT
        self.scrollToTop()
    }
    
    // Display error msg
    private func displaySuccessMsg() {
        signupMsg.isHidden = false
        signupMsg.backgroundColor = UIColor(named: "signup_success_msg_color")
        signupMsgTitle.text = Strings.SIGNUP_SUCCESS_MSG_TITLE
        signupMsgContent.text = Strings.SIGNUP_SUCCESS_MSG_CONTENT
        self.scrollToTop()
    }
    
    // Scroll to the top of the scroll view
    private func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
        self.scrollView.setContentOffset(topOffset, animated: true)
    }
    
}
