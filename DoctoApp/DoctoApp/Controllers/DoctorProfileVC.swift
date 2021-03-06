//
//  DoctorProfileVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import Foundation
import UIKit

protocol ToRedirectDelegator {
    func redirect()
}

struct DoctorMainData {
    let sectionIcon: String!
    let sectionTitle: String!
    let sectionContent: String!
}

struct DoctorSecondaryData {
    let sectionIcon: String!
    let sectionTitle: String!
}

class DoctorProfileVC: UIViewController, ToRedirectDelegator {
    @IBOutlet weak var doctorPicture: UIImageView!
    @IBOutlet weak var doctorHeader: UIImageView!
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var doctorMainDataTable: UITableView!
    @IBOutlet weak var doctorSecondaryDataTable: UITableView!
    @IBOutlet weak var bookAppointmentBtn: UIButton!
    
    private var doctor: Doctor! // must be set by the calling view
    private var doctorMainData: [DoctorMainData] = [DoctorMainData]()
    private var doctorSecondaryData: [DoctorSecondaryData] = [DoctorSecondaryData]()
    private var loggedUser: Resident? // can be retrieved from the user defaults
    
    private var selectedCategoryTitle: String = "" // set when we tap on a category
    private var selectedCategoryContent: String = "" // set when we tap on a category
    private var popupSectionsData: [PopUpSectionsData]? = nil // set we tap on a multiple sections category
    
    private static let chooseReasonSegueIdentifier: String = "choose_reason_segue"
    private static let loginSegueIdentifier: String = "login_segue"
    private static let expandDataSegueIdentifier: String = "expand_data_segue"
    private static let expandDataSectionsSegueIdentifier: String = "expand_data_sections_segue"

    private static let doctorMainDataItemCellXibFile: String = "DoctorMainDataItemCell"
    private static let doctorSecondaryDataItemCellXibFile: String = "DoctorSecondaryDataItemCell"
    private static let doctorMainDataItemCellIdentifier: String = "doctor_main_data_item_cell"
    private static let doctorSecondaryDataItemCellIdentifier: String = "doctor_secondary_data_item_cell"

    private static let sectionAddressIcon: String = "ic_dialog_map"
    private static let sectionAddressTitle: String = "Address"
    private static let sectionPricesAndRefundsIcon: String = "ic_money"
    private static let sectionPricesAndRefundsTitle: String = "Prices and refunds"
    private static let sectionPaymentOptionsIcon: String = "ic_payment"
    private static let sectionPaymentOptionsTitle: String = "Payment options"
    
    private static let sectionDescriptionIcon: String = "ic_description"
    private static let sectionDescriptionTitle: String = "Description"
    private static let sectionHoursAndContactsIcon: String = "ic_contact"
    private static let sectionHoursAndContactsTitle: String = "Hours and contacts"
    private static let sectionEducationIcon: String = "ic_menu_view"
    private static let sectionEducationTitle: String = "Education"
    private static let sectionLanguagesIcon: String = "ic_stat_notify_chat"
    private static let sectionLanguagesTitle: String = "Spoken languages"
    private static let sectionExperiencesIcon: String = "ic_menu_sort_by_size"
    private static let sectionExperiencesTitle: String = "Experiences"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.tryGetLoggedUser()
        
        // Update doctor model to get most recent changes
        self.doctor = self.doctor.update() as? Doctor

        self.doctorMainDataTable.delegate = self
        self.doctorMainDataTable.dataSource = self
        self.doctorMainDataTable.rowHeight = UITableView.automaticDimension
        self.doctorMainDataTable.separatorColor = UIColor.clear
        
        self.doctorSecondaryDataTable.delegate = self
        self.doctorSecondaryDataTable.dataSource = self
        self.doctorSecondaryDataTable.rowHeight = UITableView.automaticDimension
        self.doctorSecondaryDataTable.separatorColor = UIColor(hex: Colors.FORGOT_PASSWORD_BACKGROUND)
        
        self.setHeaderData()
        self.setMainData()
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
        if segue.identifier == DoctorProfileVC.loginSegueIdentifier
            && segue.destination is LoginVC {
            let loginVC = segue.destination as! LoginVC
            loginVC.setData(
                toRedirect: true,
                toRedirectDelegator: self
            )
        } else if segue.identifier == DoctorProfileVC.chooseReasonSegueIdentifier
            && segue.destination is ChooseReasonVC {
            let chooseReasonVC = segue.destination as! ChooseReasonVC
            chooseReasonVC.setData(doctor: doctor)
        } else if segue.identifier == DoctorProfileVC.expandDataSegueIdentifier 
            && segue.destination is PopUpVC {
            let popupVC = segue.destination as! PopUpVC
            popupVC.setData(
                title: self.selectedCategoryTitle,
                content: self.selectedCategoryContent,
                hideButtons: true
            )
        } else if segue.identifier == DoctorProfileVC.expandDataSectionsSegueIdentifier
            && segue.destination is PopUpSectionsVC {
            let popupSectionsVC = segue.destination as! PopUpSectionsVC
            popupSectionsVC.setData(
                title: self.selectedCategoryTitle,
                popupSectionsData: self.popupSectionsData!
            )
        }
    }
    
    // Set view data
    func setData(doctor: Doctor) {
        self.doctor = doctor
    }
    
    // Set header data
    private func setHeaderData() {
        if let picture: UIImage = self.doctor.getPicture() { self.doctorPicture.image = picture }
        if let header: UIImage = self.doctor.getHeader() { self.doctorHeader.image = header }
        
        self.doctorHeader.addBlurEffect()
        
        self.doctorFullname.text = self.doctor.getFullname()
        self.doctorSpeciality.text = self.doctor.getSpeciality()
        
        self.doctorPicture.layer.masksToBounds = true
        self.doctorPicture.layer.cornerRadius = self.doctorPicture.frame.height / 2
    }
    
    // Set main data
    private func setMainData() {
        if self.loggedUser is Doctor { self.bookAppointmentBtn.isHidden = true }
        
        self.doctorMainData = [
            DoctorMainData(
                sectionIcon: DoctorProfileVC.sectionAddressIcon,
                sectionTitle: DoctorProfileVC.sectionAddressTitle,
                sectionContent: self.doctor.GetFullAddress()
            ),
            DoctorMainData(
                sectionIcon: DoctorProfileVC.sectionPricesAndRefundsIcon,
                sectionTitle: DoctorProfileVC.sectionPricesAndRefundsTitle,
                sectionContent: self.doctor.getPricesAndRefundsAsString()
            ),
            DoctorMainData(
                sectionIcon: DoctorProfileVC.sectionPaymentOptionsIcon,
                sectionTitle: DoctorProfileVC.sectionPaymentOptionsTitle,
                sectionContent: self.doctor.getPaymentOptionsAsString()
            )
        ]
        
        self.doctorSecondaryData = [
            DoctorSecondaryData(
                sectionIcon: DoctorProfileVC.sectionDescriptionIcon,
                sectionTitle: DoctorProfileVC.sectionDescriptionTitle
            ),
            DoctorSecondaryData(
                sectionIcon: DoctorProfileVC.sectionHoursAndContactsIcon,
                sectionTitle: DoctorProfileVC.sectionHoursAndContactsTitle
            ),
            DoctorSecondaryData(
                sectionIcon: DoctorProfileVC.sectionEducationIcon,
                sectionTitle: DoctorProfileVC.sectionEducationTitle
            ),
            DoctorSecondaryData(
                sectionIcon: DoctorProfileVC.sectionLanguagesIcon,
                sectionTitle: DoctorProfileVC.sectionLanguagesTitle
            ),
            DoctorSecondaryData(
                sectionIcon: DoctorProfileVC.sectionExperiencesIcon,
                sectionTitle: DoctorProfileVC.sectionExperiencesTitle
            )
        ]
    }
    
    // Action triggered when book appointment online button is clicked
    @IBAction func bookAppointment(_ sender: UIButton) {
        if self.loggedUser != nil {
            performSegue(withIdentifier: DoctorProfileVC.chooseReasonSegueIdentifier, sender: nil)
        } else {
            performSegue(withIdentifier: DoctorProfileVC.loginSegueIdentifier, sender: nil)
        }
    }
    
    // Redirect the logged user to ChooseReasonVC
    func redirect() {
        self.tryGetLoggedUser()
        performSegue(withIdentifier: DoctorProfileVC.chooseReasonSegueIdentifier, sender: nil)
    }
    
}

extension DoctorProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.doctorMainDataTable { return self.doctorMainData.count }
        
        return self.doctorSecondaryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.doctorMainDataTable {
            let doctorMainDataItemCell = Bundle.main.loadNibNamed(DoctorProfileVC.doctorMainDataItemCellXibFile, owner: self, options: nil)?.first as! DoctorMainDataItemCell
            doctorMainDataItemCell.selectionStyle = .none
            
            doctorMainDataItemCell.setData(
                doctorMainData: self.doctorMainData[indexPath.row],
                displayExpandIcon: !(indexPath.row == 2)
            )
            
            return doctorMainDataItemCell
        }
        
        let doctorSecondaryDataItemCell = Bundle.main.loadNibNamed(DoctorProfileVC.doctorSecondaryDataItemCellXibFile, owner: self, options: nil)?.first as! DoctorSecondaryDataItemCell
        doctorSecondaryDataItemCell.selectionStyle = .none
        doctorSecondaryDataItemCell.setData(doctorSecondaryData: self.doctorSecondaryData[indexPath.row])
        
        return doctorSecondaryDataItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.doctorMainDataTable {
            if indexPath.row == 2 { // Payment options
                return 70
            }
            
            return 110
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.doctorMainDataTable {
            self.selectedCategoryTitle = self.doctorMainData[indexPath.row].sectionTitle

            if indexPath.row == 1 { // Prices and refunds
                self.popupSectionsData = self.preparePopupSectionsData()
                performSegue(withIdentifier: DoctorProfileVC.expandDataSectionsSegueIdentifier, sender: nil)
                
                return
            }
            
            if indexPath.row == 2 { // Payment options
                return
            }
            
            self.selectedCategoryContent = self.doctorMainData[indexPath.row].sectionContent
        } else {
            self.selectedCategoryTitle = self.doctorSecondaryData[indexPath.row].sectionTitle
            
            switch(indexPath.row) {
                case 0:
                    self.selectedCategoryContent = self.doctor.getDescription()
                    break
                case 1:
                    self.selectedCategoryContent = self.doctor.getContactNumber()
                    break
                case 2:
                    self.selectedCategoryContent = self.doctor.getEducationsAsString()
                    break
                case 3:
                    self.selectedCategoryContent = self.doctor.getLanguagesAsString()
                    break
                case 4:
                    self.selectedCategoryContent = self.doctor.getExperiencesAString()
                    break
                default: break
            }
        }
        
        performSegue(withIdentifier: DoctorProfileVC.expandDataSegueIdentifier, sender: nil)
    }
    
    // Prepare the content to display in the popup sections
    private func preparePopupSectionsData() -> [PopUpSectionsData] {
        var popupSectionsData: [PopUpSectionsData] = [PopUpSectionsData]()
        
        if self.doctor.isUnderAgreement() {
            popupSectionsData.append(
                PopUpSectionsData(
                    title: Strings.DOCTOR_PROFILE_POPUP_IS_UNDER_AGREEMENT,
                    content: Strings.DOCTOR_PROFILE_POPUP_IS_UNDER_AGREEMENT_CONTENT
                )
            )
        }
        
        if self.doctor.isHealthInsuranceCard() {
            popupSectionsData.append(
                PopUpSectionsData(
                    title: Strings.DOCTOR_PROFILE_POPUP_IS_HEALTH_INSURANCE_CARD,
                    content: Strings.DOCTOR_PROFILE_POPUP_IS_HEALTH_INSURANCE_CARD_CONTENT
                )
            )
        }
        
        if self.doctor.isThirdPartyPayment() {
            popupSectionsData.append(
                PopUpSectionsData(
                    title: Strings.DOCTOR_PROFILE_POPUP_IS_THIRD_PARTY_PAYMENT,
                    content: Strings.DOCTOR_PROFILE_POPUP_IS_THIRD_PARTY_PAYMENT_CONTENT
                )
            )
        }
        
        return popupSectionsData
    }
}

extension UIImageView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
