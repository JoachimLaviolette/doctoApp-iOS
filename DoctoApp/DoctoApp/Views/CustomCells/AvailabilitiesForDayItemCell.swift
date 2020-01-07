//
//  AvailabilitiesForDayItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class AvailabilitiesForDayItemCell: UITableViewCell {
    private var delegator: ChooseAvailabilityDelegator! // must be set by the calling view
    
    @IBOutlet weak var availabilitiesFullDate: UILabel!
    @IBOutlet weak var timesList: UICollectionView!
    
    private var availabilitiesForDay: [String: [Availability]]! // must be set by the calling view
    private var reason: Reason! // must be set by the calling view
    private var doctor: Doctor! // must be set by the calling view
    private var loggedUser: Resident! // can be retrieved from the user defaults
    private var isBookingUpdate: Bool? = false
    private var booking: Booking? = nil

    private static let availabilityItemCellIdentifier: String = "availability_item_cell"
    private static let availabilityItemCellXibFile: String = "AvailabilityItemCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tryGetLoggedUser()
        self.timesList.delegate = self
        self.timesList.dataSource = self
        self.timesList.register(UINib(nibName: AvailabilitiesForDayItemCell.availabilityItemCellXibFile, bundle: nil), forCellWithReuseIdentifier: AvailabilitiesForDayItemCell.availabilityItemCellIdentifier)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Set cell data
    func setData(availabilitiesForDay: [String: [Availability]], reason: Reason, doctor: Doctor, delegator: ChooseAvailabilityDelegator, isBookingUpdate: Bool? = false, booking: Booking? = nil) {
        self.delegator = delegator
        self.isBookingUpdate = isBookingUpdate
        self.booking = booking
        self.availabilitiesForDay = availabilitiesForDay
        self.reason = reason   
        self.doctor = doctor
        self.availabilitiesFullDate.text = availabilitiesForDay.first?.key
    }
}

extension AvailabilitiesForDayItemCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let fullDateKey: String? = (availabilitiesForDay.first?.key)
        
        if fullDateKey != nil { return self.availabilitiesForDay[fullDateKey!]!.count }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fullDateKey: String = (self.availabilitiesForDay.first?.key)!
        let availabilitiesForDay: [Availability] = self.availabilitiesForDay[fullDateKey]!
        let availability: Availability = availabilitiesForDay[indexPath.row]
        let availabilityItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailabilitiesForDayItemCell.availabilityItemCellIdentifier, for: indexPath) as! AvailabilityItemCell
        
        availabilityItemCell.setData(availability: availability)
        
        return availabilityItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullDateKey: String = (self.availabilitiesForDay.first?.key)!
        let availabilitiesForDay: [Availability] = self.availabilitiesForDay[fullDateKey]!
        let availability: Availability = availabilitiesForDay[indexPath.row]
        
        if !self.isBookingUpdate! {
            let booking = Booking(
                id: -1,
                patient: self.loggedUser as! Patient,
                doctor: self.doctor,
                reason: self.reason,
                fullDate: availability.getDate(),
                date: DateTimeService.GetDateTimeInFormatFromStringAsString(date: availability.getDate(), fromFormat: DateTimeService.FORMAT_EEEE_MM_DD_YYYY, toFormat: DateTimeService.FORMAT_YYYY_MM_DD),
                time: availability.getTime(),
                bookingDate: DateTimeService.GetCurrentDateTime()
            )
            self.delegator.confirmBooking(booking: booking)
            
            return
        }
        
        self.booking!.setTime(time: availability.getTime())
        self.delegator.updateBooking(booking: self.booking!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 20
        let spacing: CGFloat = 20
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        if let collection = self.timesList {
            let width = (collection.bounds.width - totalSpacing) / numberOfItemsPerRow
            // let height = (collection.bounds.height - totalSpacing) / numberOfItemsPerRow

            return CGSize(width: width, height: collection.bounds.height)
        }
        
        return CGSize(width: 0, height: 0)
    }
}
