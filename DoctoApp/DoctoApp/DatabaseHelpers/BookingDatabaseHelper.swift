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

class BookingDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "booking"
    static let table = Table("booking")
    
    // Fields
    static let id = Expression<Int64>("id")
    private let patientId = Expression<Int64>("patient_id")
    private let doctorId = Expression<Int64>("doctor_id")
    private let reasonId = Expression<Int64>("reason_id")
    private let fullDate = Expression<String>("full_date")
    private let date = Expression<String>("date")
    private let time = Expression<String>("time")
    private let bookingDate = Expression<String>("bookingDate")
    
    private static var pk = 0
    private var tableExist = false
    
    init() {}
    
    func initTableConfig() {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            let fileUrl = documentDirectory
                .appendingPathComponent(BookingDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
            
            let createTable = BookingDatabaseHelper.table.create { table in
                table.column(BookingDatabaseHelper.id, primaryKey: .autoincrement)
                table.column(self.patientId)
                table.column(self.doctorId)
                table.column(self.reasonId)
                table.column(self.fullDate)
                table.column(self.date)
                table.column(self.time)
                table.column(self.bookingDate)
                
                // Alter table
                table.unique([
                    self.patientId,
                    self.doctorId,
                    self.reasonId,
                    self.date,
                    self.time
                ])
                
                table.foreignKey(
                    self.patientId,
                    references: PatientDatabaseHelper.table, PatientDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
                
                table.foreignKey(
                    self.doctorId,
                    references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
                
                table.foreignKey(
                    self.reasonId,
                    references: ReasonDatabaseHelper.table, ReasonDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
            }
            
            do {
                try self.database.run(createTable)
                print (BookingDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(BookingDatabaseHelper.table.drop())
        } catch {}
    }
    
    // Insert all the bookings of the given resident in the database
    func insertBookings(resident: Resident) -> Resident {
        for booking: Booking in (resident.getBookings())! {
            self.insertBooking(booking: booking)
        }
        
        return resident
    }
    
    // Insert a new booking in the database
    private func insertBooking(booking: Booking) {
        self.initTableConfig()
        
        let query = BookingDatabaseHelper.table.insert(
            self.patientId <- Int64(booking.GetPatientId()),
            self.doctorId <- Int64(booking.GetDoctorId()),
            self.reasonId <- Int64(booking.GetPatientId()),
            self.fullDate <- booking.getFullDate(),
            self.date <- booking.getDate(),
            self.time <- booking.getTime(),
            self.bookingDate <- booking.getBookingDate()
        )
        
        do {
            try self.database.run(query)
            print("Booking insertion succeeded.")
        } catch {
            print("Booking insertion failed.")
        }
    }
    
    // Update the given booking in the database
    func updateBooking(booking: Booking) -> Bool {
        self.initTableConfig()
        
        let filter = BookingDatabaseHelper.table.filter(BookingDatabaseHelper.id == Int64(booking.getId()))
        let query = filter.update(
            self.time <- booking.getTime(),
            self.bookingDate <- booking.getBookingDate()
        )
        
        do {
            if try self.database.run(query) > 0 {
                print("Booking update succeeded.")
                
                return true
            }
            
            print("Booking update failed.")
        } catch {
            print("Booking update failed.")
        }
        
        return false
    }
    
    // Drop the given booking from the database
    private func dropBooking(booking: Booking) -> Bool {
        self.initTableConfig()
        
        let filter = BookingDatabaseHelper.table.filter(BookingDatabaseHelper.id == Int64(booking.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
                print("Booking removal succeeded.")

                return true
            }
            
            print("Booking removal failed.")
        } catch {
            print("Booking removal failed.")
        }
        
        return false
    }
    
    // Retrieve all bookings related to the given doctor
    func getBookings(doctor: Doctor) -> [Booking] {
        var bookings: [Booking] = []
        
        self.initTableConfig()
        
        var query = BookingDatabaseHelper.table
            .select(BookingDatabaseHelper.table[*])
            .filter(self.doctorId == Int64(doctor.getId()))
        
        do {
            for booking in try self.database.prepare(query) {
                let patient: Patient = PatientDatabaseHelper().getPatient(patientId: Int(try booking.get(self.patientId)), true)!
                patient.setBookings(bookings: bookings)
                
                let reason: Reason = ReasonDatabaseHelper().getReason(reasonId: Int(try booking.get(self.reasonId)))!
                reason.setDoctor(doctor: doctor)
                
                bookings.append(
                    Booking(
                        id: try Int(booking.get(BookingDatabaseHelper.id)),
                        patient: patient,
                        doctor: doctor,
                        reason: reason,
                        fullDate: try booking.get(self.fullDate),
                        date: try booking.get(self.date),
                        time: try booking.get(self.time),
                        bookingDate: try booking.get(self.bookingDate)
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
        
        self.initTableConfig()
        
        let currentDate = ""
        let currentTime = ""
        
        var query = BookingDatabaseHelper.table
            .select(BookingDatabaseHelper.table[*])
            .filter(
                self.patientId == Int64(patient.getId())
                && self.date > currentDate
                || (self.date == currentDate && self.time > currentTime)
            )
        
        do {
            for booking in try self.database.prepare(query) {
                let doctor: Doctor = DoctorDatabaseHelper().getDoctor(doctorId: Int(try booking.get(self.doctorId)), email: nil, fromPatient: true)!
                doctor.setBookings(bookings: bookings)
                
                let reason: Reason = ReasonDatabaseHelper().getReason(reasonId: Int(try booking.get(self.reasonId)))!
                reason.setDoctor(doctor: doctor)
                
                bookings.append(
                    Booking(
                        id: try Int(booking.get(BookingDatabaseHelper.id)),
                        patient: patient,
                        doctor: doctor,
                        reason: reason,
                        fullDate: try booking.get(self.fullDate),
                        date: try booking.get(self.date),
                        time: try booking.get(self.time),
                        bookingDate: try booking.get(self.bookingDate)
                    )
                )
            }
        } catch {
            print("Something went wrong when fetching bookings data for patient: " + patient.getFullname())
        }
        
        return bookings
    }
}
