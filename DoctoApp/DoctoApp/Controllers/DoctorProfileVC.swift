//
//  DoctorProfileVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import Foundation
import UIKit

struct DoctorMainData {
    let sectionIcon: String!
    let sectionTitle: String!
    let sectionContent: String!
}

struct DoctorSecondaryData {
    let sectionIcon: String!
    let sectionTitle: String!
}

class DoctorProfileVC: UIViewController {
    @IBOutlet weak var doctorPicture: UIImageView!
    @IBOutlet weak var doctorHeader: UIImageView!
    @IBOutlet weak var doctorFullname: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var doctorMainDataTable: UITableView!
    @IBOutlet weak var doctorSecondaryDataTable: UITableView!
    
    var doctor: Doctor! // must be set by the calling view
    var doctorMainData: [DoctorMainData] = [DoctorMainData]()
    var doctorSecondaryData: [DoctorSecondaryData] = [DoctorSecondaryData]()
    
    private static let chooseReasonSegueIdentifier: String = "choose_reason_segue"
    private static let loginSegueIdentifier: String = "login_segue"
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
        // Retrieve most recent changes updating the doctor model
        // self.doctor = doctor.update() as? Doctor
        
        self.doctorMainDataTable.delegate = self
        self.doctorMainDataTable.dataSource = self
        self.doctorMainDataTable.rowHeight = UITableView.automaticDimension
        self.doctorMainDataTable.separatorColor = UIColor.clear
        
        self.doctorSecondaryDataTable.delegate = self
        self.doctorSecondaryDataTable.dataSource = self
        self.doctorSecondaryDataTable.rowHeight = UITableView.automaticDimension
        self.doctorSecondaryDataTable.separatorColor = UIColor.clear
        
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
        
        self.doctorFullname.text = self.doctor.getFullname()
        self.doctorSpeciality.text = self.doctor.getSpeciality()
        
        self.doctorPicture.layer.masksToBounds = true
        self.doctorPicture.layer.cornerRadius = self.doctorPicture.frame.height / 2
        self.doctorHeader.addBlurEffect()
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
            doctorMainDataItemCell.setData(doctorMainData: self.doctorMainData[indexPath.row])
            
            return doctorMainDataItemCell
        }
        
        let doctorSecondaryDataItemCell = Bundle.main.loadNibNamed(DoctorProfileVC.doctorSecondaryDataItemCellXibFile, owner: self, options: nil)?.first as! DoctorSecondaryDataItemCell
        doctorSecondaryDataItemCell.selectionStyle = .none
        doctorSecondaryDataItemCell.setData(doctorSecondaryData: self.doctorSecondaryData[indexPath.row])
        
        return doctorSecondaryDataItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.doctorMainDataTable { return 70 }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.doctorMainDataTable { }
        else {}
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
