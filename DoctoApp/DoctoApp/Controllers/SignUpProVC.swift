//
//  SignUpProVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 18/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation

protocol SignUpProVCDelegator {
    func removeItem(index: Int, itemType: ItemType)
}

class SignUpProVC: UIViewController, SignUpProVCDelegator {
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var caption: UILabel!
    
    @IBOutlet weak var feedbackMessage: FeedbackMessageView!
    
    @IBOutlet weak var doctorProfilePicture: UIImageView!
    @IBOutlet weak var doctorHeader: UIImageView!
    
    @IBOutlet weak var selectHeaderBtn: UIButton!
    @IBOutlet weak var takeHeaderBtn: UIButton!
    @IBOutlet weak var selectPictureBtn: UIButton!
    @IBOutlet weak var takePictureBtn: UIButton!
    @IBOutlet weak var addAvailabilityBtn: UIButton!
    @IBOutlet weak var addReasonBtn: UIButton!
    @IBOutlet weak var addEducationBtn: UIButton!
    @IBOutlet weak var addExperienceBtn: UIButton!
    @IBOutlet weak var addLanguageBtn: UIButton!
    @IBOutlet weak var addPaymentOptionBtn: UIButton!
    
    @IBOutlet weak var doctorProfileSection: UIStackView!
    @IBOutlet weak var doctorEmail: UITextField!
    @IBOutlet weak var doctorFirstName: UITextField!
    @IBOutlet weak var doctorLastName: UITextField!
    @IBOutlet weak var doctorPwd: UITextField!
    @IBOutlet weak var doctorConfirmPwd: UITextField!
    @IBOutlet weak var doctorSpeciality: UITextField!
    @IBOutlet weak var doctorDescription: UITextField!
    @IBOutlet weak var doctorContactNumber: UITextField!
    
    @IBOutlet weak var isUnderAgreement: UISwitch!
    @IBOutlet weak var isHealthInsuranceCard: UISwitch!
    @IBOutlet weak var isThirdPartyPayment: UISwitch!
    
    @IBOutlet weak var availibilityInfoIcon: UIImageView!
    @IBOutlet weak var availibilityInfoMsg: UILabel!
    @IBOutlet weak var availabilityTableView: UITableView!
    @IBOutlet weak var availibilityDayPicker: UIPickerView!
    @IBOutlet weak var availibilityTimePicker: UIDatePicker!
    @IBOutlet weak var availibilityErrorView: UIView!
    @IBOutlet weak var availibilityErrorIcon: UIImageView!
    @IBOutlet weak var availibilityErrorMsg: UILabel!
    
    @IBOutlet weak var reasonTableView: UITableView!
    @IBOutlet weak var reasonDescription: UITextField!
    @IBOutlet weak var reasonErrorView: UIView!
    @IBOutlet weak var reasonErrorIcon: UIImageView!
    @IBOutlet weak var reasonErrorMsg: UILabel!
    
    @IBOutlet weak var educationTableView: UITableView!
    @IBOutlet weak var educationYear: UITextField!
    @IBOutlet weak var educationDescription: UITextField!
    @IBOutlet weak var educationErrorView: UIView!
    @IBOutlet weak var educationErrorIcon: UIImageView!
    @IBOutlet weak var educationErrorMsg: UILabel!
    
    @IBOutlet weak var experienceTableView: UITableView!
    @IBOutlet weak var experienceYear: UITextField!
    @IBOutlet weak var experienceDescription: UITextField!
    @IBOutlet weak var experienceErrorView: UIView!
    @IBOutlet weak var experienceErrorIcon: UIImageView!
    @IBOutlet weak var experienceErrorMsg: UILabel!
    
    @IBOutlet weak var languagesTableView: UITableView!
    @IBOutlet weak var doctorLanguagesPicker: UIPickerView!
    @IBOutlet weak var languagesErrorView: UIView!
    @IBOutlet weak var languagesErrorIcon: UIImageView!
    @IBOutlet weak var languagesErrorMsg: UILabel!
    
    @IBOutlet weak var paymentOptionsTableView: UITableView!
    @IBOutlet weak var doctorPaymentOptionsPicker: UIPickerView!
    @IBOutlet weak var paymentOptionsErrorView: UIView!
    @IBOutlet weak var paymentOptionsErrorIcon: UIImageView!
    @IBOutlet weak var paymentOptionsErrorMsg: UILabel!
    
    @IBOutlet weak var doctorAddressSection: UIStackView!
    @IBOutlet weak var doctorStreet1: UITextField!
    @IBOutlet weak var doctorStreet2: UITextField!
    @IBOutlet weak var doctorCity: UITextField!
    @IBOutlet weak var doctorZip: UITextField!
    @IBOutlet weak var doctorCountry: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var signInSection: UIView!
    @IBOutlet weak var signUpSection: UIView!
    
    private var loggedUser: Resident? = nil // can be retrieved from the user defaults
    private var doctor: Doctor?
    private let doctorDbHelper: DoctorDatabaseHelper = DoctorDatabaseHelper()
    
    private var availabilities: [Availability]?
    private var reasons: [Reason]?
    private var experiences: [Experience]?
    private var educations: [Education]?
    private var languages: [Language]?
    private var paymentOptions: [PaymentOption]?
    
    private var picturePicker: UIImagePickerController!
    private var headerPicker: UIImagePickerController!
    
    static let languages: [String] = [
        Language.FR.rawValue,
        Language.EN.rawValue,
        Language.ES.rawValue,
        Language.GER.rawValue,
        Language.IT.rawValue
    ]
    static let paymentOptions: [String] = [
        PaymentOption.CASH.rawValue,
        PaymentOption.CREDIT_CARD.rawValue,
        PaymentOption.CHEQUE.rawValue
    ]
    
    static let days: [String] = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    ]
    
    static let oneColumnElementItemCellIdentifier: String = "signup_pro_one_column_element_item_cell"
    static let twoColumnsElementItemCellIdentifier: String = "signup_pro_two_columns_element_item_cell"
    
    private static let photoIcon = "ic_take_picture"
    private static let galleryIcon = "ic_add_image"
    private static let addIcon = "ic_add"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    private func initialize() {
        self.tryGetLoggedUser()
        
        // Take in charge all the subcomponents
        self.doctorLanguagesPicker.delegate = self
        self.doctorLanguagesPicker.dataSource = self
        self.doctorPaymentOptionsPicker.delegate = self
        self.doctorPaymentOptionsPicker.dataSource = self
        self.availibilityDayPicker.delegate = self
        self.availibilityDayPicker.dataSource = self
        
        self.availabilityTableView.delegate = self
        self.availabilityTableView.dataSource = self
        self.availabilityTableView.rowHeight = UITableView.automaticDimension
        self.availabilityTableView.separatorColor = UIColor.clear
        
        self.reasonTableView.delegate = self
        self.reasonTableView.dataSource = self
        self.reasonTableView.rowHeight = UITableView.automaticDimension
        self.reasonTableView.separatorColor = UIColor.clear
        
        self.educationTableView.delegate = self
        self.educationTableView.dataSource = self
        self.educationTableView.rowHeight = UITableView.automaticDimension
        self.educationTableView.separatorColor = UIColor.clear
        
        self.experienceTableView.delegate = self
        self.experienceTableView.dataSource = self
        self.experienceTableView.rowHeight = UITableView.automaticDimension
        self.experienceTableView.separatorColor = UIColor.clear
        
        self.languagesTableView.delegate = self
        self.languagesTableView.dataSource = self
        self.languagesTableView.rowHeight = UITableView.automaticDimension
        self.languagesTableView.separatorColor = UIColor.clear
        
        self.paymentOptionsTableView.delegate = self
        self.paymentOptionsTableView.dataSource = self
        self.paymentOptionsTableView.rowHeight = UITableView.automaticDimension
        self.paymentOptionsTableView.separatorColor = UIColor.clear
        
        self.picturePicker = UIImagePickerController()
        self.picturePicker.delegate = self
        self.headerPicker = UIImagePickerController()
        self.headerPicker.delegate = self
        
        self.setContent()
    }
    
    // Try to get a logged user id from the user defaults
    private func tryGetLoggedUser() {
        if self.loggedUser == nil {
            if UserDefaults.standard.string(forKey: Strings.USER_TYPE_KEY) == Strings.USER_TYPE_DOCTOR {
                let doctorId = UserDefaults.standard.integer(forKey: Strings.USER_ID_KEY)
                let doctor: Doctor = DoctorDatabaseHelper().getDoctor(doctorId: doctorId, email: nil, fromPatient: false)!
                self.loggedUser = doctor
            }
        }
    }
    
    // Set view content
    private func setContent() {
        // Make a circle profile picture
        self.doctorProfilePicture.layer.masksToBounds = true
        self.doctorProfilePicture.layer.cornerRadius = doctorProfilePicture.frame.width / 2
        
        self.setupButtonsIconsColors()
        
        // Resize switches
        self.isUnderAgreement.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.isThirdPartyPayment.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.isHealthInsuranceCard.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        self.caption.font = UIFont.preferredFont(forTextStyle: .footnote).italic()
        self.doctorHeader.addBlurEffect()
        
        self.displayAvailibilityInfo()
        self.displayAvailibilityError()
        self.displayReasonError()
        self.displayEducationError()
        self.displayExperienceError()
        self.displayLanguageError()
        self.displayPaymentOptionsError()
        
        if self.loggedUser != nil { self.setSignupContextForDoctor() }
        else { self.setSignupContext() }
    }
    
    // Setup actions buttons
    private func setupButtonsIconsColors() {
        var takePictureBtnIcon: UIImage? = UIImage(named: SignUpProVC.photoIcon)
        var selectFromGalleryIcon: UIImage? = UIImage(named: SignUpProVC.galleryIcon)
        var addIcon: UIImage? = UIImage(named: SignUpProVC.addIcon)
        
        takePictureBtnIcon = takePictureBtnIcon?.withRenderingMode(.alwaysTemplate)
        selectFromGalleryIcon = selectFromGalleryIcon?.withRenderingMode(.alwaysTemplate)
        addIcon = addIcon?.withRenderingMode(.alwaysTemplate)

        self.takePictureBtn.setImage(takePictureBtnIcon, for: .normal)
        self.selectPictureBtn.setImage(selectFromGalleryIcon, for: .normal)
        self.takeHeaderBtn.setImage(takePictureBtnIcon, for: .normal)
        self.selectHeaderBtn.setImage(selectFromGalleryIcon, for: .normal)
        self.addAvailabilityBtn.setImage(addIcon, for: .normal)
        self.addReasonBtn.setImage(addIcon, for: .normal)
        self.addEducationBtn.setImage(addIcon, for: .normal)
        self.addExperienceBtn.setImage(addIcon, for: .normal)
        self.addLanguageBtn.setImage(addIcon, for: .normal)
        self.addPaymentOptionBtn.setImage(addIcon, for: .normal)
        
        self.takePictureBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_TAKE_PICTURE_FROM_CAMERA_TEXT)
        self.selectPictureBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_SELECT_PICTURE_FROM_GALLERY_TEXT)
        self.takeHeaderBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_TAKE_HEADER_FROM_CAMERA_TEXT)
        self.selectHeaderBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_SELECT_HEADER_FROM_GALLERY_TEXT)
        self.addAvailabilityBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_SELECT_HEADER_FROM_GALLERY_TEXT)
        self.addReasonBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_SELECT_HEADER_FROM_GALLERY_TEXT)
        self.addEducationBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_SELECT_HEADER_FROM_GALLERY_TEXT)
        self.addExperienceBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_SELECT_HEADER_FROM_GALLERY_TEXT)
        self.addLanguageBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_SELECT_HEADER_FROM_GALLERY_TEXT)
        self.addPaymentOptionBtn.tintColor = UIColor(hex: Colors.SIGNUP_PRO_SELECT_HEADER_FROM_GALLERY_TEXT)
        
        self.takePictureBtn.imageView?.contentMode = .scaleAspectFit
        self.selectPictureBtn.imageView?.contentMode = .scaleAspectFit
        self.takeHeaderBtn.imageView?.contentMode = .scaleAspectFit
        self.selectHeaderBtn.imageView?.contentMode = .scaleAspectFit
        self.addAvailabilityBtn.imageView?.contentMode = .scaleAspectFit
        self.addReasonBtn.imageView?.contentMode = .scaleAspectFit
        self.addEducationBtn.imageView?.contentMode = .scaleAspectFit
        self.addExperienceBtn.imageView?.contentMode = .scaleAspectFit
        self.addLanguageBtn.imageView?.contentMode = .scaleAspectFit
        self.addPaymentOptionBtn.imageView?.contentMode = .scaleAspectFit
        
        self.takePictureBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.selectPictureBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.takeHeaderBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.selectHeaderBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 30)
        self.addAvailabilityBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: -5, bottom: 30, right: 30)
        self.addReasonBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: -5, bottom: 30, right: 30)
        self.addEducationBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: -5, bottom: 30, right: 30)
        self.addExperienceBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: -5, bottom: 30, right: 30)
        self.addLanguageBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: -5, bottom: 30, right: 30)
        self.addPaymentOptionBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: -5, bottom: 30, right: 30)
    }
    
    // Display availibility info message
    private func displayAvailibilityInfo() {
        self.availibilityInfoIcon.image = self.availibilityInfoIcon.image?.withRenderingMode(.alwaysTemplate)
        self.availibilityInfoIcon.tintColor = UIColor(hex: Colors.SIGNUP_PRO_INFO_MSG)
        self.availibilityInfoMsg.text = Strings.SIGNUP_PRO_AVAILABILITY_INFO
    }
    
    // Display availibility error message
    private func displayAvailibilityError() {
        self.availibilityErrorIcon.image = self.availibilityErrorIcon.image?.withRenderingMode(.alwaysTemplate)
        self.availibilityErrorIcon.tintColor = UIColor(hex: Colors.SIGNUP_PRO_ERROR_MSG)
        self.availibilityErrorMsg.text = Strings.SIGNUP_PRO_AVAILABILITY_ERROR
    }
    
    // Display reason error message
    private func displayReasonError() {
        self.reasonErrorIcon.image = self.reasonErrorIcon.image?.withRenderingMode(.alwaysTemplate)
        self.reasonErrorIcon.tintColor = UIColor(hex: Colors.SIGNUP_PRO_ERROR_MSG)
        self.reasonErrorMsg.text = Strings.SIGNUP_PRO_REASON_ERROR
    }
    
    // Display eudcation error message
    private func displayEducationError() {
        self.educationErrorIcon.image = self.educationErrorIcon.image?.withRenderingMode(.alwaysTemplate)
        self.educationErrorIcon.tintColor = UIColor(hex: Colors.SIGNUP_PRO_ERROR_MSG)
        self.educationErrorMsg.text = Strings.SIGNUP_PRO_TRAINING_ERROR
    }
    
    // Display experience error message
    private func displayExperienceError() {
        self.experienceErrorIcon.image = self.experienceErrorIcon.image?.withRenderingMode(.alwaysTemplate)
        self.experienceErrorIcon.tintColor = UIColor(hex: Colors.SIGNUP_PRO_ERROR_MSG)
        self.experienceErrorMsg.text = Strings.SIGNUP_PRO_EXPERIENCE_ERROR
    }
    
    // display the language error message
    private func displayLanguageError() {
        self.languagesErrorIcon.image = self.languagesErrorIcon.image?.withRenderingMode(.alwaysTemplate)
        self.languagesErrorIcon.tintColor = UIColor(hex: Colors.SIGNUP_PRO_ERROR_MSG)
        self.languagesErrorMsg.text = Strings.SIGNUP_PRO_LANGUAGE_ERROR
    }
    
    // Display payment options error message
    private func displayPaymentOptionsError() {
        self.paymentOptionsErrorIcon.image = self.paymentOptionsErrorIcon.image?.withRenderingMode(.alwaysTemplate)
        self.paymentOptionsErrorIcon.tintColor = UIColor(hex: Colors.SIGNUP_PRO_ERROR_MSG)
        self.paymentOptionsErrorMsg.text = Strings.SIGNUP_PRO_PAYMENT_OPTION_ERROR
    }
    
    // Set sign up context
    private func setSignupContext() {
        self.doctorProfileSection.isHidden = false
        self.doctorAddressSection.isHidden = false
        self.signUpSection.isHidden = false
        self.feedbackMessage.isHidden = true
        self.availibilityErrorView.isHidden = true
        self.reasonErrorView.isHidden = true
        self.educationErrorView.isHidden = true
        self.languagesErrorView.isHidden = true
        self.experienceErrorView.isHidden = true
        self.paymentOptionsErrorView.isHidden = true
        self.signupBtn.titleLabel!.text = Strings.SIGNUP_PRO_BTN.uppercased()

        self.doctorLastName.text = ""
        self.doctorFirstName.text = ""
        self.doctorSpeciality.text = ""
        self.doctorEmail.text = ""
        self.doctorDescription.text = ""
        self.doctorContactNumber.text = ""
        self.doctorPwd.text = ""
        self.doctorConfirmPwd.text = ""
        self.doctorStreet1.text = ""
        self.doctorStreet2.text = ""
        self.doctorCity.text = ""
        self.doctorZip.text = ""
        self.doctorCountry.text = ""
        self.availabilities = []
        self.reasons = []
        self.educations = []
        self.experiences = []
        self.languages = []
        self.paymentOptions = []
        self.availabilityTableView.reloadData()
        self.reasonTableView.reloadData()
        self.educationTableView.reloadData()
        self.experienceTableView.reloadData()
        self.languagesTableView.reloadData()
        self.paymentOptionsTableView.reloadData()
    }
        
    // Set sign up context when a doctor is  currently logged-in
    private func setSignupContextForDoctor() {
        self.feedbackMessage.isHidden = true
        self.caption.text = Strings.MY_PROFILE_PRO_CAPTION
        self.signInSection.isHidden = true
        self.signUpSection.isHidden = true
        
        let doctor: Doctor = self.loggedUser as! Doctor
        self.doctorProfileSection.isHidden = false
        self.doctorAddressSection.isHidden = false
        self.signUpSection.isHidden = true
        self.feedbackMessage.isHidden = true
        self.availibilityErrorView.isHidden = true
        self.reasonErrorView.isHidden = true
        self.educationErrorView.isHidden = true
        self.languagesErrorView.isHidden = true
        self.experienceErrorView.isHidden = true
        self.paymentOptionsErrorView.isHidden = true
        self.signupBtn.titleLabel!.text = Strings.MY_PROFILE_PRO_UPDATE_BTN.uppercased()
        
        if let userPicture: UIImage = ImageService().retrieve(
            key: Strings.LOGGED_USER_DOCTOR_PICTURE + "\(self.loggedUser!.getId())",
            storageType: StorageType.UserDefaults
        ) {
            self.doctorProfilePicture.image = userPicture
        }
        
        if let userPicture: UIImage = ImageService().retrieve(
            key: Strings.LOGGED_USER_DOCTOR_HEADER + "\(self.loggedUser!.getId())",
            storageType: StorageType.UserDefaults
        ) {
            self.doctorHeader.image = userPicture
        }
        
        self.doctorLastName.text = doctor.getLastname()
        self.doctorFirstName.text = doctor.getFirstname()
        self.doctorSpeciality.text = doctor.getSpeciality()
        self.doctorEmail.text = doctor.getEmail()
        self.doctorDescription.text = doctor.getDescription()
        self.doctorContactNumber.text = doctor.getContactNumber()
        self.doctorPwd.text = ""
        self.doctorConfirmPwd.text = ""
        self.doctorStreet1.text = doctor.GetStreet1()
        self.doctorStreet2.text = doctor.GetStreet2()
        self.doctorCity.text = doctor.GetCity()
        self.doctorZip.text = doctor.GetZip()
        self.doctorCountry.text = doctor.GetCountry()
        self.availabilities = doctor.getAvailabilities() ?? []
        self.reasons = doctor.getReasons() ?? []
        self.educations = doctor.getEducations() ?? []
        self.experiences = doctor.getExperiences() ?? []
        self.languages = doctor.getLanguages() ?? []
        self.paymentOptions = doctor.getPaymentOptions() ?? []
        self.availabilityTableView.reloadData()
        self.reasonTableView.reloadData()
        self.educationTableView.reloadData()
        self.experienceTableView.reloadData()
        self.languagesTableView.reloadData()
        self.paymentOptionsTableView.reloadData()
        self.isUnderAgreement.isOn = (self.loggedUser! as! Doctor).isUnderAgreement()
        self.isThirdPartyPayment.isOn = (self.loggedUser! as! Doctor).isThirdPartyPayment()
        self.isHealthInsuranceCard.isOn = (self.loggedUser! as! Doctor).isHealthInsuranceCard()
    }
    
    // Display a success message to notify the registration succeeded
    private func displaySuccessMsg() {
        self.feedbackMessage.isHidden = false
        self.feedbackMessage.setData(
            title: Strings.SIGNUP_PRO_SUCCESS_MSG_TITLE,
            content: Strings.SIGNUP_PRO_SUCCESS_MSG_CONTENT,
            isErrorMsg: false
        )
        self.signUpSection.isHidden = true
        self.scrollToTop()
    }
    
    // Display an error message to notify the registration failed
    private func displayErrorMsg() {
        self.feedbackMessage.isHidden = false
        self.feedbackMessage.setData(
            title: Strings.SIGNUP_PRO_ERROR_MSG_TITLE,
            content: Strings.SIGNUP_PRO_ERROR_MSG_CONTENT,
            isErrorMsg: true
        )
        self.scrollToTop()
    }
    
    // Add the availibility chosen by the doctor
    @IBAction func addAvailibility(_ sender: Any) {
        let day = SignUpProVC.days[self.availibilityDayPicker.selectedRow(inComponent: 0)].trimmingCharacters(in: .whitespacesAndNewlines)
        let time = DateTimeService.GetTimeIn24H(date: self.availibilityTimePicker.date)
        
        let a: Availability = Availability(doctor: nil, date: day, time: time)
        
        // If already added
        if self.availabilities!.contains(a)  {
            self.availibilityErrorView.isHidden = false
            
            return
        }
        
        self.availibilityErrorView.isHidden = true
        
        // Add it to the list of availibilities
        self.availabilities!.append(a)
        
        // Add it to the view's list of availibities
        self.availabilityTableView.reloadData()
    }
    
    // Add the education chosen by the doctor
    @IBAction func addEducation(_ sender: Any) {
        if !self.checkEducationFields() {
            self.educationErrorView.isHidden = false
            
            return
        }
        
        let year = self.educationYear.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = self.educationDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let e: Education = Education(doctor: nil, year: year!, degree: desc!)
        
        // If already added
        if self.educations!.contains(e) {
            self.educationErrorView.isHidden = false
            
            return
        }
        
        self.educationErrorView.isHidden = true
        
        // Add it to the list of educations
        self.educations!.append(e)
        
        // Add it to the view's list of educations
        self.educationTableView.reloadData()
    }
    
    // Check if the education fields are filled properly
    private func checkEducationFields() -> Bool {
        // TO DO Check if the text match with a date format
        return !(self.educationYear.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! && !(self.educationDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
    
    // Add the experience chosen by the doctor
    @IBAction func addExperience(_ sender: Any) {
        if(!self.checkExperienceFields()) {
            self.experienceErrorView.isHidden = false
            
            return
        }
        
        let year = self.experienceYear.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = self.experienceDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let e: Experience = Experience(doctor: nil, year: year!, description: desc!)
        
        // If already added
        if self.experiences!.contains(e) {
            self.experienceErrorView.isHidden = false
            
            return
        }
        
        self.educationErrorView.isHidden = true
        
        // Add it to the list of educations
        self.experiences!.append(e)
        
        // Add it to the view's list of educations
        self.experienceTableView.reloadData()
    }
    
    // Check if the experience fields are filled properly
    private func checkExperienceFields() -> Bool {
        // TO DO Check if the text match with a date format
        return !(self.experienceYear.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! && !(self.experienceYear.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
    
    // Add the reason chosen by the doctor
    @IBAction func addReason(_ sender: Any) {
        if(!self.checkReasonFields()) {
            self.reasonErrorView.isHidden = false
            
            return
        }
        
        let desc = self.reasonDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let r: Reason = Reason(id: -1, doctor: nil, description: desc!)
        
        // If already added
        if self.reasons!.contains(r) {
            self.reasonErrorView.isHidden = false
            
            return
        }
        
        self.reasonErrorView.isHidden = true
        
        // Add it to the list of educations
        self.reasons!.append(r)
        
        // Add it to the view's list of educations
        self.reasonTableView.reloadData()
    }
    
    // Check reason fields are filled properly
    private func checkReasonFields() -> Bool {
        return !(self.reasonDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
    
    // Add the language chosen by the doctor
    @IBAction func addLanguage(_ sender: Any) {
        let l: Language = Language.getValueOf(languageName: SignUpProVC.languages[self.doctorLanguagesPicker.selectedRow(inComponent: 0)].trimmingCharacters(in: .whitespacesAndNewlines))!
        
        // If already added
        if self.languages!.contains(l) {
            self.languagesErrorView.isHidden = false
            
            return
        }
        
        self.languagesErrorView.isHidden = true
        
        // Add it to the list of languages
        self.languages!.append(l)
        
        // Add it to the view's list of languages
        self.languagesTableView.reloadData()
    }
    
    // Add the payment option chosen by the doctor
    @IBAction func addPaymentOption(_ sender: Any) {
        let po: PaymentOption = PaymentOption.getValueOf(paymentOptionName: SignUpProVC.paymentOptions[self.doctorPaymentOptionsPicker.selectedRow(inComponent: 0)].trimmingCharacters(in: .whitespacesAndNewlines))!
        
        // If already added
        if self.paymentOptions!.contains(po) {
            self.paymentOptionsErrorView.isHidden = false
            
            return
        }
        
        self.paymentOptionsErrorView.isHidden = true
        
        // Add it to the list of payment options
        self.paymentOptions!.append(po)
        
        // Add it to the view's list of payment options
        self.paymentOptionsTableView.reloadData()
    }
    
    // Execute the signup process
    @IBAction func signUpPro(_ sender: Any) {
        if self.loggedUser != nil {
            self.updateProfilePro()
            
            return
        }
        
        self.signupPro()
    }
    
    // Update the logged-in doctor profile
    private func updateProfilePro() {
        if !allFieldsCorrect(forUpdate: true) {
            self.displayErrorMsg()
            
            return
        }
        
        if !self.doctorPwd.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let inputPwd = self.doctorPwd.text!
            let salt = EncryptionService.SALT()
            self.loggedUser!.setPwdSalt(pwdSalt: salt)
            self.loggedUser!.setPwd(pwd: EncryptionService.SHA1(string: inputPwd + salt))
        }
        
        let address: Address = self.loggedUser!.getAddress()!
        address.setStreet1(street1: StringFormatterService.CapitalizeOnly(str: self.doctorStreet1.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        address.setStreet2(street2: StringFormatterService.CapitalizeOnly(str: self.doctorStreet2.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        address.setCity(city: StringFormatterService.CapitalizeOnly(str: self.doctorCity.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        address.setZip(zip: self.doctorZip.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        address.setCountry(country: StringFormatterService.Capitalize(str: self.doctorCountry.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        
        self.loggedUser!.setLastname(lastname: StringFormatterService.CapitalizeOnly(str: self.doctorLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        self.loggedUser!.setFirstname(firstname: StringFormatterService.CapitalizeOnly(str: self.doctorFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        self.loggedUser!.setEmail(email: self.doctorEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        self.loggedUser!.setLastLogin(lastLogin: DateTimeService.GetCurrentDateTime())
        // self.loggedUser!.setPicture(picture: self.doctorProfilePicture.name)
        (self.loggedUser! as! Doctor).setSpeciality(speciality: StringFormatterService.CapitalizeOnly(str: self.doctorSpeciality.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        (self.loggedUser! as! Doctor).setDescription(description: StringFormatterService.CapitalizeOnly(str: self.doctorDescription.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        (self.loggedUser! as! Doctor).setContactNumber(contactNumber: StringFormatterService.CapitalizeOnly(str: self.doctorContactNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
        (self.loggedUser! as! Doctor).setUnderAgreement(underAgreement: self.isUnderAgreement.isOn)
        (self.loggedUser! as! Doctor).setHealthInsuranceCard(healthInsuranceCard: self.isHealthInsuranceCard.isOn)
        (self.loggedUser! as! Doctor).setThirdPartyPayment(thirdPartyPayment: self.isThirdPartyPayment.isOn)
        // (self.loggedUser! as! Doctor).setHeader(header: self.doctorHeader.name)
        (self.loggedUser! as! Doctor).setAvailabilities(availabilities: self.availabilities)
        (self.loggedUser! as! Doctor).setLanguages(languages: self.languages)
        (self.loggedUser! as! Doctor).setPaymentOptions(paymentOptions: self.paymentOptions)
        (self.loggedUser! as! Doctor).setReasons(reasons: self.reasons)
        (self.loggedUser! as! Doctor).setEducations(educations: self.educations)
        (self.loggedUser! as! Doctor).setExperiences(experiences: self.experiences)
        
        if self.doctorDbHelper.updateDoctor(doctor: self.loggedUser as! Doctor) {
            self.displaySuccessMsg()
            
            if self.doctorProfilePicture.image != nil {
                ImageService().store(
                    image: self.doctorProfilePicture.image!,
                    key: Strings.LOGGED_USER_DOCTOR_PICTURE + "\(self.loggedUser!.getId())",
                    storageType: StorageType.UserDefaults
                )
            }
            
            if self.doctorHeader.image != nil {
                ImageService().store(
                    image: self.doctorHeader.image!,
                    key: Strings.LOGGED_USER_DOCTOR_HEADER + "\(self.loggedUser!.getId())",
                    storageType: StorageType.UserDefaults
                )
            }
            
            return
        }
        
        self.displayErrorMsg()
        self.loggedUser = self.loggedUser!.update()
    }
    
    // Sign-up the doctor
    private func signupPro() {
        if !allFieldsCorrect() {
            self.displayErrorMsg()
            
            return
        }
        
        let inputPwd = self.doctorPwd.text!
        let salt = EncryptionService.SALT()
        let hashedInputPwd = EncryptionService.SHA1(string: inputPwd + salt)
        
        let address: Address = Address(
            id: -1,
            street1: StringFormatterService.CapitalizeOnly(str: self.doctorStreet1.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            street2: StringFormatterService.CapitalizeOnly(str: self.doctorStreet2.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            city: StringFormatterService.CapitalizeOnly(str: self.doctorCity.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            zip: self.doctorZip.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            country: StringFormatterService.Capitalize(str: self.doctorCountry.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        )
        
        let doctor: Doctor = Doctor(
            id: -1,
            lastname: StringFormatterService.CapitalizeOnly(str: self.doctorLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            firstname: StringFormatterService.CapitalizeOnly(str: self.doctorFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            email: self.doctorEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            pwd: hashedInputPwd,
            pwdSalt: salt,
            lastLogin: DateTimeService.GetCurrentDateTime(),
            picture: "",
            address: address,
            speciality: StringFormatterService.CapitalizeOnly(str: self.doctorSpeciality.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            description: StringFormatterService.CapitalizeOnly(str: self.doctorDescription.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            contactNumber: StringFormatterService.CapitalizeOnly(str: self.doctorContactNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)),
            underAgreement: self.isUnderAgreement.isOn,
            healthInsuranceCard: self.isHealthInsuranceCard.isOn,
            thirdPartyPayment: self.isThirdPartyPayment.isOn,
            header: "",
            availabilities: self.availabilities,
            languages: self.languages,
            paymentOptions: self.paymentOptions,
            reasons: self.reasons,
            educations: self.educations,
            experiences: self.experiences
        )
        
        if self.doctorDbHelper.createDoctor(doctor: doctor) {
            self.displaySuccessMsg()
            
            if self.doctorProfilePicture.image != nil {
                ImageService().store(
                    image: self.doctorProfilePicture.image!,
                    key: Strings.LOGGED_USER_DOCTOR_PICTURE + "\(doctor.getId())",
                    storageType: StorageType.UserDefaults
                )
            }
            
            if self.doctorHeader.image != nil {
                ImageService().store(
                    image: self.doctorHeader.image!,
                    key: Strings.LOGGED_USER_DOCTOR_HEADER + "\(doctor.getId())",
                    storageType: StorageType.UserDefaults
                )
            }
            
            return
        }
        
        self.displayErrorMsg()
    }
    
    // Check that all the fields are filled properly
    private func allFieldsCorrect(forUpdate: Bool = false) -> Bool {
        let isOneFieldEmpty: Bool = !forUpdate
            ? ((doctorLastName.text?.isEmpty)! || (doctorFirstName.text?.isEmpty)! || (doctorSpeciality.text?.isEmpty)! || (doctorEmail.text?.isEmpty)! || (doctorPwd.text?.isEmpty)! || (doctorConfirmPwd.text?.isEmpty)! || (doctorContactNumber.text?.isEmpty)! || (doctorStreet1.text?.isEmpty)! || (doctorCity.text?.isEmpty)! || (doctorZip.text?.isEmpty)! || (doctorCountry.text?.isEmpty)!)
            : ((doctorLastName.text?.isEmpty)! || (doctorFirstName.text?.isEmpty)! || (doctorSpeciality.text?.isEmpty)! || (doctorEmail.text?.isEmpty)! || (doctorContactNumber.text?.isEmpty)! || (doctorStreet1.text?.isEmpty)! || (doctorCity.text?.isEmpty)! || (doctorZip.text?.isEmpty)! || (doctorCountry.text?.isEmpty)!)
        
        // One of the fields is empty
        if isOneFieldEmpty { return false }
        
        if !forUpdate
            || (forUpdate && !self.doctorPwd.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            let bothPwdEqual: Bool = doctorPwd.text! == doctorConfirmPwd.text!
            
            // Both passwords do not correspond
            if !bothPwdEqual { return false }
        }
        
        // TO DO: Check the Birthdate format
        /* let range = NSRange(location: 0, length: patientBirthDate.text!.utf16.count)
         let regex = try! NSRegularExpression(pattern: "\\d{4}-{01|02|03|04|05|06|07|08|09|10|11|12}-\\d{2}")
         let isBirthDateCorrectFormat = regex.firstMatch(in: patientBirthDate.text!, options: [], range: range) != nil
         */
        
        return true
    }
    
    
    // Remove the given item type at the specifid position in the appropriate model array
    func removeItem(index: Int, itemType: ItemType) {
        switch (itemType) {
            case ItemType.Availability:
                self.availabilities!.remove(at: index)
                self.availabilityTableView.reloadData()
                break
            case ItemType.Education:
                self.educations!.remove(at: index)
                self.educationTableView.reloadData()
                break
            case ItemType.Experience:
                self.experiences!.remove(at: index)
                self.experienceTableView.reloadData()
                break
            case ItemType.Reason:
                self.reasons!.remove(at: index)
                self.reasonTableView.reloadData()
                break
            case ItemType.Language:
                self.languages!.remove(at: index)
                self.languagesTableView.reloadData()
                break
            case ItemType.PaymentOption:
                self.paymentOptions!.remove(at: index)
                self.paymentOptionsTableView.reloadData()
                break
        }
    }
    
    // Scroll to the top of the scroll view
    private func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
        self.scrollView.setContentOffset(topOffset, animated: true)
    }
    
    // Action triggered when select picture button is clicked
    @IBAction func selectPicture(_ sender: UIButton) {
        self.picturePicker.allowsEditing = false
        self.picturePicker.sourceType = .photoLibrary
        present(self.picturePicker, animated: true, completion: nil)
    }
    
    // Action triggered when take picture button is clicked
    @IBAction func takePicture(_ sender: UIButton) {
        self.picturePicker.sourceType = .camera
        present(self.picturePicker, animated: true, completion: nil)
    }
    
    // Action triggered when select header button is clicked
    @IBAction func selectHeader(_ sender: UIButton) {
        self.headerPicker.allowsEditing = false
        self.headerPicker.sourceType = .photoLibrary
        present(self.headerPicker, animated: true, completion: nil)
    }
    
    // Action triggered when take header button is clicked
    @IBAction func takeHeader(_ sender: UIButton) {
        self.headerPicker.sourceType = .camera
        present(self.headerPicker, animated: true, completion: nil)
    }
}
    
extension SignUpProVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if picker == self.picturePicker { self.doctorProfilePicture.image = info[.originalImage] as? UIImage }
        else { self.doctorHeader.image = info[.originalImage] as? UIImage }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpProVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.doctorPaymentOptionsPicker { return SignUpProVC.paymentOptions.count }
        if pickerView == self.availibilityDayPicker { return SignUpProVC.days.count }
        
        return SignUpProVC.languages.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.doctorPaymentOptionsPicker { return SignUpProVC.paymentOptions[row] }
        if pickerView == self.availibilityDayPicker { return SignUpProVC.days[row] }
        
        return SignUpProVC.languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Roboto", size: 14)
        if pickerView == self.doctorPaymentOptionsPicker { label.text =  SignUpProVC.paymentOptions[row] }
        else if pickerView == self.availibilityDayPicker { label.text = SignUpProVC.days[row] }
        else { label.text = SignUpProVC.languages[row] }
        label.textAlignment = .center
        
        return label
    }
}

extension SignUpProVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.availabilityTableView { return self.availabilities!.count }
        if tableView == self.reasonTableView { return self.reasons!.count }
        if tableView == self.educationTableView { return self.educations!.count }
        if tableView == self.experienceTableView { return self.experiences!.count }
        if tableView == self.languagesTableView { return self.languages!.count }
        
        return self.paymentOptions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.availabilityTableView
            || tableView == self.educationTableView
            || tableView == self.experienceTableView {
            let twoColumnsElementItemCell = tableView.dequeueReusableCell(withIdentifier: SignUpProVC.twoColumnsElementItemCellIdentifier) as! SignUpProTwoColumnsElementItemCell
            twoColumnsElementItemCell.selectionStyle = .none
            twoColumnsElementItemCell.setData(
                item1: tableView == self.availabilityTableView ? self.availabilities![indexPath.row].getDate() : tableView == self.educationTableView ? self.educations![indexPath.row].getYear() : self.experiences![indexPath.row].getYear(),
                item2: tableView == self.availabilityTableView ? self.availabilities![indexPath.row].getTime() : tableView == self.educationTableView ? self.educations![indexPath.row].getDegree() : self.experiences![indexPath.row].getDescription(),
                index: indexPath.row,
                itemType: tableView == self.availabilityTableView ? ItemType.Availability : tableView == self.educationTableView ? ItemType.Education : ItemType.Experience,
                delegator: self
            )
            return twoColumnsElementItemCell
        }
        
        let oneColumnElementItemCell = tableView.dequeueReusableCell(withIdentifier: SignUpProVC.oneColumnElementItemCellIdentifier) as! SignUpProOneColumnElementItemCell
        oneColumnElementItemCell.selectionStyle = .none
        oneColumnElementItemCell.setData(
            item: tableView == self.reasonTableView ? self.reasons![indexPath.row].getDescription() : tableView == self.languagesTableView ? Language.getValueOf(languageName: self.languages![indexPath.row].rawValue)!.rawValue : PaymentOption.getValueOf(paymentOptionName: self.paymentOptions![indexPath.row].rawValue)!.rawValue,
            index: indexPath.row,
            itemType: tableView == self.reasonTableView ? ItemType.Reason : tableView == self.languagesTableView ? ItemType.Language : ItemType.PaymentOption,
            delegator: self
        )
        
        return oneColumnElementItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
