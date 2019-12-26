//
//  BookingDetailsView.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 15/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class BookingDetailsView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bookingFulldate: UILabel!
    @IBOutlet weak var bookingTime: UILabel!
    @IBOutlet weak var dataTable: UITableView!
    
    private var showDoctorProfileDelegator: ShowDoctorProfileDelegator? = nil // set by the calling view
    private var myBookingDetailsActionsDelegator: MyBookingDetailsActionsDelegator? = nil
    
    private var booking: Booking! // must be set by the calling view
    private var doctor: Doctor! // set using the booking object in setData()
    private var patient: Patient! // set using the booking object in setData()
    private var reason: Reason! // set using the booking object in setData()
    
    private var loggedUser: Resident! // must be retrieved from the user defaults
    
    private var isConfirmBooking: Bool = false
    
    private static let xibFile: String = "BookingDetailsView"
    private static let bookingPreviewItemCell: String = "BookingPreviewItemCell"
    private static let bookingOneLineElementItemCell: String = "BookingOneLineElementItemCell"
    private static let bookingTwoLinesItemCell: String = "BookingTwoLinesElementItemCell"
    private static let bookingActionsItemCell: String = "BookingActionsItemCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    // Initialize controller properties
    private func initialize() {
        self.tryGetLoggedUser()
        Bundle.main.loadNibNamed(BookingDetailsView.xibFile, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.dataTable.delegate = self
        self.dataTable.dataSource = self
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

    // Set view data
    func setData(booking: Booking, showDoctorProfileDelegator: ShowDoctorProfileDelegator? = nil, isConfirmBooking: Bool = true, myBookingDetailsActionsDelegator: MyBookingDetailsActionsDelegator? = nil) {
        self.showDoctorProfileDelegator = showDoctorProfileDelegator
        self.myBookingDetailsActionsDelegator = myBookingDetailsActionsDelegator
        self.isConfirmBooking = isConfirmBooking
        
        // Retrieve the models to work with
        self.booking = booking
        self.doctor = self.booking.getDoctor()
        self.patient = self.booking.getPatient()
        self.reason = self.booking.getReason()

        // Set the view components values
        self.bookingFulldate.text = self.booking.getFullDate()
        self.bookingTime.text = self.booking.getTime()
        
        // Set table properties
        self.dataTable.rowHeight = UITableView.automaticDimension
        self.dataTable.separatorColor = UIColor.clear
    }
}

extension BookingDetailsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.loggedUser is Doctor ? 3 : 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
            case 0:
                let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingPreviewItemCell, owner: self, options: nil)?.first as! BookingPreviewItemCell
                cell.selectionStyle = .none
                cell.setData(
                    picture: self.loggedUser is Patient ? self.doctor.getPicture() : self.booking.getPatient().getPicture(),
                    fullname: self.loggedUser is Patient ? self.doctor.getFullname() : self.booking.getPatient().getFullname(),
                    description: self.loggedUser is Patient ? self.doctor.getSpeciality() : self.booking.getPatient().getBirthdate()
                )
                
                return cell
            case 1:
                if self.isConfirmBooking || self.loggedUser is Doctor {
                    let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingOneLineElementItemCell, owner: self, options: nil)?.first as! BookingOneLineElementItemCell
                    cell.selectionStyle = .none
                    cell.setData(
                        content: self.reason.getDescription(),
                        state: OneLineElementState.reason
                    )
                    
                    return cell
                }
            
                let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingActionsItemCell, owner: self, options: nil)?.first as! BookingActionsItemCell
                cell.selectionStyle = .none
                cell.setData(
                    booking: self.booking,
                    delegator: self.myBookingDetailsActionsDelegator!
                )
                
                return cell
            case 2:
                if self.isConfirmBooking {
                    let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingPreviewItemCell, owner: self, options: nil)?.first as! BookingPreviewItemCell
                    cell.selectionStyle = .none
                    cell.setData(
                        picture: self.patient.getPicture(),
                        fullname: nil,
                        description: self.patient.getFullname()
                    )
                    
                    return cell
                }
                
                if self.loggedUser is Patient {
                    let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingOneLineElementItemCell, owner: self, options: nil)?.first as! BookingOneLineElementItemCell
                    cell.selectionStyle = .none
                    cell.setData(
                        content: self.booking.getReason().getDescription(),
                        state: OneLineElementState.reason
                    )
                    
                    return cell
                }
                
                let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingOneLineElementItemCell, owner: self, options: nil)?.first as! BookingOneLineElementItemCell
                cell.selectionStyle = .none
                cell.setData(
                    content: self.booking.getPatient().GetFullAddress(),
                    state: OneLineElementState.address
                )
                
                return cell
            case 3:
                let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingTwoLinesItemCell, owner: self, options: nil)?.first as! BookingTwoLinesElementItemCell
                cell.selectionStyle = .none
                cell.setData(
                    content: self.doctor.getWarningMessage(),
                    state: TwoLinesElementState.warningMessage
                )
                
                return cell
            case 4:
                let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingOneLineElementItemCell, owner: self, options: nil)?.first as! BookingOneLineElementItemCell
                cell.selectionStyle = .none
                cell.setData(
                    content: self.doctor.getContactNumber(),
                    state: OneLineElementState.contactNumber
                )
                
                return cell
            case 5:
                let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingOneLineElementItemCell, owner: self, options: nil)?.first as! BookingOneLineElementItemCell
                cell.selectionStyle = .none
                cell.setData(
                    content: self.doctor.GetFullAddress(),
                    state: OneLineElementState.address
                )
                
                return cell
            case 6:
                let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingTwoLinesItemCell, owner: self, options: nil)?.first as! BookingTwoLinesElementItemCell
                cell.selectionStyle = .none
                cell.setData(
                    content: self.doctor.getPaymentOptionsAsString(),
                    state: TwoLinesElementState.paymentOptions
                )
                
                return cell
            case 7:
                let cell = Bundle.main.loadNibNamed(BookingDetailsView.bookingTwoLinesItemCell, owner: self, options: nil)?.first as! BookingTwoLinesElementItemCell
                cell.selectionStyle = .none
                cell.setData(
                    content: self.doctor.getPricesAndRefundsAsString(),
                    state: TwoLinesElementState.pricesAndRefunds
                )
                
                return cell
            default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
            case 0:
                return 80
            case 1:
                return 40
            case 2:
                return 80
            case 3:
                return 80
            case 4:
                return 40
            case 5: // address
                return 80
            case 6:
                return 80
            case 7:
                return 80
            default: return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.loggedUser is Patient && indexPath.row == 0 { self.showDoctorProfileDelegator!.showDoctorProfile(doctor: self.doctor) }
    }
}
