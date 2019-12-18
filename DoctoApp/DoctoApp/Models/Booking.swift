//
//  Booking.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

class Booking {
    private var id: Int
    private var patient: Patient
    private var doctor: Doctor
    private var reason: Reason
    private var fullDate: String
    private var date: String
    private var time: String
    private var bookingDate: String
    
    init(
        id: Int,
        patient: Patient,
        doctor: Doctor,
        reason: Reason,
        fullDate: String,
        date: String,
        time: String,
        bookingDate: String
    ) {
        self.id = id
        self.patient = patient
        self.doctor = doctor
        self.reason = reason
        self.fullDate = fullDate
        self.date = date
        self.time = time
        self.bookingDate = bookingDate
    }
    
    func getId() -> Int { return self.id }
    func getPatient() -> Patient { return self.patient }
    func getDoctor() -> Doctor { return self.doctor }
    func getReason() -> Reason { return self.reason }
    func getFullDate() -> String { return self.fullDate }
    func getDate() -> String { return self.date }
    func getTime() -> String { return self.time }
    func getBookingDate() -> String { return self.bookingDate }
    
    func setId(id: Int) { self.id = id }
    func setPatient(patient: Patient) { self.patient = patient }
    func setDoctor(doctor: Doctor) { self.doctor = doctor }
    func setReason(reason: Reason) { self.reason = reason }
    func setFullDate(fullDate: String) { self.fullDate = fullDate }
    func setDate(date: String) { self.date = date }
    func setTime(time: String) { self.time = time }
    func setBookingDate(bookingDate: String) { self.bookingDate = bookingDate }
    
    func GetDoctorId() -> Int {
        return self.doctor.getId()
    }
    
    func GetPatientId() -> Int {
        return self.patient.getId()
    }
    
    func GetReasonId() -> Int {
        return self.reason.getId()
    }
    
    func getDoctorFullname() -> String {
        return self.doctor.getFullname()
    }
}
