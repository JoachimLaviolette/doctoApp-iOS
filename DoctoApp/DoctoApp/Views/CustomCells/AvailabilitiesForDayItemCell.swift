//
//  AvailabilitiesForDayItemCell.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 14/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class AvailabilitiesForDayItemCell: UITableViewCell {
    var delegator: ChooseAvailabilityDelegator! // must be set by the calling view
    
    @IBOutlet weak var availabilitiesFullDate: UILabel!
    @IBOutlet weak var timesList: UICollectionView!
    
    var availabilitiesForDay: [String: [Availability]]! // must be set by the calling view
    var reason: Reason! // must be set by the calling view
    var doctor: Doctor! // must be set by the calling view
    var loggedUser: Resident! // must be set by the calling view
    var isBookingUpdate: Bool? = false
    var booking: Booking? = nil

    private static let availabilityItemCellIdentifier: String = "availability_item_cell"
    private static let availabilityItemCellXibFile: String = "AvailabilityItemCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timesList.delegate = self
        self.timesList.dataSource = self
        self.timesList.register(UINib(nibName: AvailabilitiesForDayItemCell.availabilityItemCellXibFile, bundle: nil), forCellWithReuseIdentifier: AvailabilitiesForDayItemCell.availabilityItemCellIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(availabilitiesForDay: [String: [Availability]], reason: Reason, doctor: Doctor, loggedUser: Resident? = nil, delegator: ChooseAvailabilityDelegator, isBookingUpdate: Bool? = false, booking: Booking? = nil) {
        self.delegator = delegator
        self.isBookingUpdate = isBookingUpdate
        self.booking = booking
        self.availabilitiesForDay = availabilitiesForDay
        self.reason = reason   
        self.doctor = doctor
        if loggedUser != nil { self.loggedUser = loggedUser! }
        self.availabilitiesFullDate.text = availabilitiesForDay.first?.key
    }
}

extension AvailabilitiesForDayItemCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let fullDateKey: String = (availabilitiesForDay.first?.key)!
        
        return self.availabilitiesForDay[fullDateKey]!.count
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
                    date: availability.getDate(),
                    time: availability.getTime(),
                    bookingDate: DateTimeService.GetCurrentDateTime()
                )
            self.delegator.confirmBooking(booking: booking, loggedUser: self.loggedUser)
            
                return
        }
        
        self.booking!.setTime(time: availability.getTime())
        self.delegator.updateBooking(booking: self.booking!, loggedUser: self.loggedUser)
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
