//
//  BookingDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class BookingDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "booking"
    static let table = Table("booking")
    
    // Fields
    static let id = Expression<Int64>("id")
    static let patientId = Expression<Int64>("patient_id")
    static let doctorId = Expression<Int64>("doctor_id")
    static let reasonId = Expression<Int64>("reason_id")
    static let fullDate = Expression<String>("full_date") // used just for representation no compute needed on it at all
    static let date = Expression<Date>("date")
    static let time = Expression<Date>("time")
    static let bookingDate = Expression<Date>("booking_date")
    
    override init() {}
    
    // Insert all the bookings of the given resident in the database
    func insertBookings(resident: Resident) -> Resident {
        for booking: Booking in (resident.getBookings())! {
            self.insertBooking(booking: booking)
        }
        
        return resident
    }
    
    // Insert a new booking in the database
    public func insertBooking(booking: Booking) -> Bool {
        self.initDb()
        
        let query = BookingDatabaseHelper.table.insert(
            BookingDatabaseHelper.patientId <- Int64(booking.GetPatientId()),
            BookingDatabaseHelper.doctorId <- Int64(booking.GetDoctorId()),
            BookingDatabaseHelper.reasonId <- Int64(booking.GetReasonId()),
            BookingDatabaseHelper.fullDate <- booking.getFullDate(),
            BookingDatabaseHelper.date <- DateTimeService.GetDateTimeInFormat(date: booking.getDate(), format: DateTimeService.FORMAT_YYYY_MM_DD),
            BookingDatabaseHelper.time <- DateTimeService.GetDateTimeInFormat(date: booking.getTime(), format: DateTimeService.FORMAT_HH_MM),
            BookingDatabaseHelper.bookingDate <- DateTimeService.GetDateTimeInFormat(date: booking.getBookingDate(), format: DateTimeService.FORMAT_YYYY_MM_DD_HH_MM_SS)
        )
        
        do {
            let bookingId: Int = Int(try self.database.run(query))
            booking.setId(id: bookingId)
            
            if bookingId != -1 {
                print("Booking insertion succeeded.")

                return true
            }

            print("Booking insertion failed.")
        } catch {
            print("Booking insertion failed.")
        }

        return false
    }
    
    // Update the given booking in the database
    func updateBooking(booking: Booking) -> Bool {
        self.initDb()
        
        let filter = BookingDatabaseHelper.table.filter(BookingDatabaseHelper.id == Int64(booking.getId()))
        let query = filter.update(
            BookingDatabaseHelper.time <- DateTimeService.GetDateTimeInFormat(date: booking.getTime(), format: DateTimeService.FORMAT_HH_MM),
            BookingDatabaseHelper.bookingDate <- DateTimeService.GetDateTimeInFormat(date: booking.getBookingDate(), format: DateTimeService.FORMAT_YYYY_MM_DD_HH_MM_SS)
        )
        
        do {
            if self.getBooking(bookingId: booking.getId()) != nil {
                if try self.database.run(query) > 0 {
                    print("Booking update succeeded.")
                    
                    return true
                }
            }
            
            print("Booking update failed.")
        } catch {
            print("Booking update failed.")
        }
        
        return false
    }
    
    // Drop the given booking from the database
    func dropBooking(booking: Booking) -> Bool {
        self.initDb()
        
        let filter = BookingDatabaseHelper.table.filter(BookingDatabaseHelper.id == Int64(booking.getId()))
        let query = filter.delete()
        
        do {
            if self.getBooking(bookingId: booking.getId()) != nil {
                if try self.database.run(query) > 0 {
                    print("Booking removal succeeded.")
                    
                    return true
                }
            }
            
            print("Booking removal failed.")
        } catch {
            print("Booking removal failed.")
        }
        
        return false
    }

    // Retrieve a booking by its id
    func getBooking(bookingId: Int) -> Booking? {
        self.initDb()
        
        let query = BookingDatabaseHelper.table
            .select(BookingDatabaseHelper.table[*])
            .filter(BookingDatabaseHelper.id == Int64(bookingId))
        
        do {
            for booking in try self.database.prepare(query) {
                let patient: Patient = PatientDatabaseHelper().getPatient(patientId: Int(try booking.get(BookingDatabaseHelper.patientId)), email: nil, fromDoctor: true)!
                let doctor: Doctor = DoctorDatabaseHelper().getDoctor(doctorId: Int(try booking.get(BookingDatabaseHelper.doctorId)), email: nil, fromPatient: true)!
                let reason: Reason = ReasonDatabaseHelper().getReason(reasonId: Int(try booking.get(BookingDatabaseHelper.reasonId)))!
                
                return Booking(
                    id: try Int(booking.get(BookingDatabaseHelper.id)),
                    patient: patient,
                    doctor: doctor,
                    reason: reason,
                    fullDate: try booking.get(BookingDatabaseHelper.fullDate),
                    date: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.date), format: DateTimeService.FORMAT_YYYY_MM_DD),
                    time: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.time), format: DateTimeService.FORMAT_HH_MM),
                    bookingDate: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.bookingDate), format: DateTimeService.FORMAT_YYYY_MM_DD_HH_MM_SS)
                )
            }
        } catch {
            print("No booking found for the following id: \(bookingId)")
        }
        
        return nil
    }
    
    // Retrieve all bookings related to the given doctor
    func getBookings(doctor: Doctor) -> [Booking] {
        var bookings: [Booking] = []
        
        self.initDb()
        
        let query = BookingDatabaseHelper.table
            .select(BookingDatabaseHelper.table[*])
            .filter(BookingDatabaseHelper.doctorId == Int64(doctor.getId()))
        
        do {
            for booking in try self.database.prepare(query) {
                let patient: Patient = PatientDatabaseHelper().getPatient(patientId: Int(try booking.get(BookingDatabaseHelper.patientId)), email: nil, fromDoctor: true)!
                patient.setBookings(bookings: bookings)
                
                let reason: Reason = ReasonDatabaseHelper().getReason(reasonId: Int(try booking.get(BookingDatabaseHelper.reasonId)))!
                reason.setDoctor(doctor: doctor)
                
                bookings.append(
                    Booking(
                        id: try Int(booking.get(BookingDatabaseHelper.id)),
                        patient: patient,
                        doctor: doctor,
                        reason: reason,
                        fullDate: try booking.get(BookingDatabaseHelper.fullDate),
                        date: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.date), format: DateTimeService.FORMAT_YYYY_MM_DD),
                        time: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.time), format: DateTimeService.FORMAT_HH_MM),
                        bookingDate: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.bookingDate), format: DateTimeService.FORMAT_YYYY_MM_DD_HH_MM_SS)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching bookings data for doctor: " + doctor.getFullname())
        }
        
        return bookings
    }
    
    // Retrieve all bookings related to the given patient
    func getBookings(patient: Patient) -> [Booking] {
        var bookings: [Booking] = []
        
        self.initDb()
        
        let currentDate: Date = DateTimeService.GetCurrentDate()
        let currentTime: Date = DateTimeService.GetCurrentTime()
        
        let query = BookingDatabaseHelper.table
            .select(BookingDatabaseHelper.table[*])
            .filter(BookingDatabaseHelper.patientId == Int64(patient.getId()))
            /*&& (BookingDatabaseHelper.date > currentDate || (BookingDatabaseHelper.date == currentDate && BookingDatabaseHelper.time > currentTime))*/
            
        do {
            for booking in try self.database.prepare(query) {
                let doctor: Doctor = DoctorDatabaseHelper().getDoctor(doctorId: Int(try booking.get(BookingDatabaseHelper.doctorId)), email: nil, fromPatient: true)!
                doctor.setBookings(bookings: bookings)
                
                let reason: Reason = ReasonDatabaseHelper().getReason(reasonId: Int(try booking.get(BookingDatabaseHelper.reasonId)))!
                reason.setDoctor(doctor: doctor)
                
                let bookingDate: Date = try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.date), format: DateTimeService.FORMAT_YYYY_MM_DD)
                let bookingTime: Date = try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.date), format: DateTimeService.FORMAT_HH_MM)
                
                if bookingDate > currentDate
                    || (bookingDate == currentDate && bookingTime >= currentTime) {
                    bookings.append(
                        Booking(
                            id: try Int(booking.get(BookingDatabaseHelper.id)),
                            patient: patient,
                            doctor: doctor,
                            reason: reason,
                            fullDate: try booking.get(BookingDatabaseHelper.fullDate),
                            date: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.date), format: DateTimeService.FORMAT_YYYY_MM_DD),
                            time: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.time), format: DateTimeService.FORMAT_HH_MM),
                            bookingDate: try DateTimeService.GetDateTimeInFormat(date: booking.get(BookingDatabaseHelper.bookingDate), format: DateTimeService.FORMAT_YYYY_MM_DD_HH_MM_SS)
                        )
                    )
                }
            }
        } catch {
            print("Something went wrong when fetching bookings data for patient: " + patient.getFullname())
        }
        
        return bookings
    }
}
