//
//  MyBookingsVC.swift
//  DoctoApp
//
//  Created by Joachim LAVIOLETTE on 13/12/2019
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class MyBookingsVC: UIViewController {
    @IBOutlet weak var headerDashboardSubtitle: HeaderDashboardSubtitleView!
    @IBOutlet weak var bookingsPreviewsTable: UITableView!
    
    var resident: Resident! // logged user // must be set by the calling view or got from user defaults
    var bookings: [Booking] = []
    var booking: Booking? // set when clicked on one of the bookings
    
    private static let myBookingDetailsSegueIdentifier = "my_bookings_details_segue"
    private static let bookingPreviewItemCellIdentifier = "booking_preview_item_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.bookingsPreviewsTable.delegate = self
        self.bookingsPreviewsTable.dataSource = self
        self.bookings = self.resident.getBookings()!
        self.setHeaderData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MyBookingsVC.myBookingDetailsSegueIdentifier
            && segue.destination is MyBookingDetailsVC {
            let myBookingDetailsVC = segue.destination as! MyBookingDetailsVC
            myBookingDetailsVC.setData(
                booking: self.booking!,
                resident: self.resident
            )
        }
    }
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboardSubtitle.headerTitle.text = self.resident is Doctor ? Strings.MY_BOOKINGS_TITLE_DOCTOR : Strings.MY_BOOKINGS_TITLE_PATIENT
        self.headerDashboardSubtitle.headerSubtitle.text = Strings.MY_BOOKINGS_SUBTITLE
    }
    
    // Set view data
    func setData(resident: Resident) {
        self.resident = resident
    }
}

extension MyBookingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookingPreviewItemCell = tableView.dequeueReusableCell(withIdentifier: MyBookingsVC.bookingPreviewItemCellIdentifier) as! BookingPreviewItemCell
        bookingPreviewItemCell.selectionStyle = .none
        let booking: Booking = self.bookings[indexPath.row]
        
        if self.resident is Doctor {
            bookingPreviewItemCell.setData(
                picture: booking.getPatient().getPicture(),
                fullname: booking.getPatient().getFullname(),
                description: booking.getPatient().getBirthdate()
            )
        } else {
            bookingPreviewItemCell.setData(
                picture: booking.getDoctor().getPicture(),
                fullname: booking.getDoctor().getFullname(),
                description: booking.getDoctor().getSpeciality()
            )
        }
        
        return bookingPreviewItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.booking = self.bookings[indexPath.row]
        performSegue(withIdentifier: MyBookingsVC.myBookingDetailsSegueIdentifier, sender: nil)
    }
}
