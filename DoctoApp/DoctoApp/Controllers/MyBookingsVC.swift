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
    @IBOutlet weak var feedbackMessage: FeedbackMessageView!
    
    var loggedUser: Resident! // must be set by the calling view or got from user defaults
    var bookings: [Booking] = []
    var booking: Booking? // set when clicked on one of the bookings
    
    private static let myBookingDetailsSegueIdentifier = "my_bookings_details_segue"
    private static let bookingPreviewHeaderItemCell = "BookingPreviewHeaderItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        self.loggedUser = self.loggedUser.update()
        
        self.bookingsPreviewsTable.delegate = self
        self.bookingsPreviewsTable.dataSource = self
        self.bookingsPreviewsTable.separatorColor = UIColor(hex: Colors.MY_BOOKINGS_BODY)
        self.bookings = self.loggedUser.getBookings()!
        self.setContent()
        self.setHeaderData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MyBookingsVC.myBookingDetailsSegueIdentifier
            && segue.destination is MyBookingDetailsVC {
            let myBookingDetailsVC = segue.destination as! MyBookingDetailsVC
            myBookingDetailsVC.setData(
                booking: self.booking!,
                loggedUser: self.loggedUser
            )
        }
    }
    
    // Set view content
    private func setContent() {
        if self.bookings.isEmpty {
            self.bookingsPreviewsTable.removeFromSuperview()
            self.feedbackMessage.setData(
                title: Strings.MY_BOOKINGS_NO_BOOKING_MSG_TITLE,
                content: Strings.MY_BOOKINGS_NO_BOOKING_MSG_CONTENT,
                isErrorMsg: false,
                isInfoMsg: true
            )
        
            return
        }
        
        self.feedbackMessage.removeFromSuperview()
    }
    
    // Set header data
    private func setHeaderData() {
        self.headerDashboardSubtitle.headerTitle.text = self.loggedUser is Doctor ? Strings.MY_BOOKINGS_TITLE_DOCTOR : Strings.MY_BOOKINGS_TITLE_PATIENT
        self.headerDashboardSubtitle.headerSubtitle.text = Strings.MY_BOOKINGS_SUBTITLE
    }
    
    // Set view data
    func setData(loggedUser: Resident? = nil) {
        if loggedUser != nil { self.loggedUser = loggedUser }
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
        let bookingPreviewHeaderItemCell = Bundle.main.loadNibNamed(MyBookingsVC.bookingPreviewHeaderItemCell, owner: self, options: nil)?.first as! BookingPreviewHeaderItemCell
        bookingPreviewHeaderItemCell.selectionStyle = .none
        let booking: Booking = self.bookings[indexPath.row]
        
        if self.loggedUser is Doctor {
            bookingPreviewHeaderItemCell.setData(
                booking: booking,
                picture: booking.getPatient().getPicture(),
                fullname: booking.getPatient().getFullname(),
                description: booking.getPatient().getBirthdate(),
                loggedUser: self.loggedUser
            )
            
            return bookingPreviewHeaderItemCell
        }
        
        bookingPreviewHeaderItemCell.setData(
            booking: booking,
            picture: booking.getDoctor().getPicture(),
            fullname: booking.getDoctor().getFullname(),
            description: booking.getDoctor().getSpeciality()
        )
        
        return bookingPreviewHeaderItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.booking = self.bookings[indexPath.row]
        performSegue(withIdentifier: MyBookingsVC.myBookingDetailsSegueIdentifier, sender: nil)
    }
}
