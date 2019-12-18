//
//  Doctor.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import UIKit

class Doctor: Resident {
    private var speciality: String
    private var description: String
    private var contactNumber: String
    private var underAgreement: Bool
    private var healthInsuranceCard: Bool
    private var thirdPartyPayment: Bool
    private var header: String?
    private var availabilities: [Availability]?
    private var languages: [Language]?
    private var paymentOptions: [PaymentOption]?
    private var reasons: [Reason]?
    private var educations: [Education]?
    private var experiences: [Experience]?
    
    init(
        id: Int,
        lastname: String,
        firstname: String,
        email: String,
        pwd: String,
        pwdSalt: String,
        lastLogin: String,
        picture: String?,
        address: Address?,
        speciality: String,
        description: String,
        contactNumber: String,
        underAgreement: Bool,
        healthInsuranceCard: Bool,
        thirdPartyPayment: Bool,
        header: String?
    ) {
        self.speciality = speciality
        self.description = description
        self.contactNumber = contactNumber
        self.underAgreement = underAgreement
        self.healthInsuranceCard = healthInsuranceCard
        self.thirdPartyPayment = thirdPartyPayment
        self.header = header
        self.availabilities = [Availability]()
        self.languages = [Language]()
        self.paymentOptions = [PaymentOption]()
        self.reasons = [Reason]()
        self.educations = [Education]()
        self.experiences = [Experience]()
        
        super.init(
                id: id,
                lastname: lastname,
                firstname: firstname,
                email: email,
                pwd: pwd,
                pwdSalt: pwdSalt,
                lastLogin: lastLogin,
                picture: picture,
                address: address
        )
    }

    init(
        id: Int,
        lastname: String,
        firstname: String,
        email: String,
        pwd: String,
        pwdSalt: String,
        lastLogin: String,
        picture: String?,
        address: Address?,
        speciality: String,
        description: String,
        contactNumber: String,
        underAgreement: Bool,
        healthInsuranceCard: Bool,
        thirdPartyPayment: Bool,
        header: String?,
        availabilities: [Availability]?,
        languages: [Language]?,
        paymentOptions: [PaymentOption]?,
        reasons: [Reason]?,
        educations: [Education]?,
        experiences: [Experience]?,
        bookings: [Booking]?
    ) {
        self.speciality = speciality
        self.description = description
        self.contactNumber = contactNumber
        self.underAgreement = underAgreement
        self.healthInsuranceCard = healthInsuranceCard
        self.thirdPartyPayment = thirdPartyPayment
        self.header = header
        self.availabilities = availabilities
        self.languages = languages
        self.paymentOptions = paymentOptions
        self.reasons = reasons
        self.educations = educations
        self.experiences = experiences
        
        super.init(
            id: id,
            lastname: lastname,
            firstname: firstname,
            email: email,
            pwd: pwd,
            pwdSalt: pwdSalt,
            lastLogin: lastLogin,
            picture: picture,
            address: address,
            bookings: bookings
        )
    }

    init(
        id: Int,
        lastname: String,
        firstname: String,
        email: String,
        pwd: String,
        pwdSalt: String,
        lastLogin: String,
        picture: String?,
        address: Address?,
        speciality: String,
        description: String,
        contactNumber: String,
        underAgreement: Bool,
        healthInsuranceCard: Bool,
        thirdPartyPayment: Bool,
        header: String?,
        availabilities: [Availability]?,
        languages: [Language]?,
        paymentOptions: [PaymentOption]?,
        reasons: [Reason]?,
        educations: [Education]?,
        experiences: [Experience]?
    ) {
        self.speciality = speciality
        self.description = description
        self.contactNumber = contactNumber
        self.underAgreement = underAgreement
        self.healthInsuranceCard = healthInsuranceCard
        self.thirdPartyPayment = thirdPartyPayment
        self.header = header
        self.availabilities = availabilities
        self.languages = languages
        self.paymentOptions = paymentOptions
        self.reasons = reasons
        self.educations = educations
        self.experiences = experiences
        
        super.init(
            id: id,
            lastname: lastname,
            firstname: firstname,
            email: email,
            pwd: pwd,
            pwdSalt: pwdSalt,
            lastLogin: lastLogin,
            picture: picture,
            address: address
        )
    }
    
    func getSpeciality() -> String { return self.speciality }
    func getDescription() -> String { return self.description }
    func getContactNumber() -> String { return self.contactNumber }
    func isUnderAgreement() -> Bool { return self.underAgreement }
    func isHealthInsuranceCard() -> Bool { return self.healthInsuranceCard }
    func isThirdPartyPayment() -> Bool { return self.thirdPartyPayment }
    func getHeader() -> String? { return self.header }
    func getAvailabilities() -> [Availability]? { return self.availabilities }
    func getLanguages() -> [Language]? { return self.languages }
    func getPaymentOptions() -> [PaymentOption]? { return self.paymentOptions }
    func getReasons() -> [Reason]? { return self.reasons }
    func getEducations() -> [Education]? { return self.educations }
    func getExperiences() -> [Experience]? { return self.experiences }

    func setSpeciality(speciality: String) { self.speciality = speciality }
    func setDescription(description: String) { self.description = description }
    func setContactNumber(contactNumber: String) { self.contactNumber = contactNumber }
    func setUnderAgreement(underAgreement: Bool) { self.underAgreement = underAgreement }
    func setHealthInsuranceCard(healthInsuranceCard: Bool) { self.healthInsuranceCard = healthInsuranceCard }
    func setThirdPartyPayment(thirdPartyPayment: Bool) { self.thirdPartyPayment = thirdPartyPayment }
    func setHeader(header: String?) { self.header = header }
    func setAvailabilities(availabilities: [Availability]?) { self.availabilities = availabilities }
    func setLanguages(languages: [Language]?) { self.languages = languages }
    func setPaymentOptions(paymentOptions: [PaymentOption]?) { self.paymentOptions = paymentOptions }
    func setReasons(reasons: [Reason]?) { self.reasons = reasons }
    func setEducations(educations: [Education]?) { self.educations = educations }
    func setExperiences(experiences: [Experience]?) { self.experiences = experiences }

    // Add methods
    func addAvailability(a: Availability) {
        self.availabilities!.append(a)
    }

    func addLanguage(l: Language) {
        self.languages!.append(l)
    }

    func addPaymentOption(po: PaymentOption) {
        self.paymentOptions!.append(po)
    }

    func addReason(r: Reason) {
        self.reasons!.append(r)
    }

    func addEducation(e: Education) {
        self.educations!.append(e)
    }

    func addExperience(e: Experience) {
        self.experiences!.append(e)
    }

    // Remove methods
    func removeAvailability(a: Availability) {
        if self.availabilities!.contains(a) {
            self.availabilities!.index(of: a).map {
                self.availabilities!.remove(at: $0)
            }
        }
    }

    func removeLanguage(l: Language) {
        if self.languages!.contains(l) {
            self.languages!.index(of: l).map {
                self.languages!.remove(at: $0)
            }
        }
    }

    func removePaymentOption(po: PaymentOption) {
        if self.paymentOptions!.contains(po) {
            self.paymentOptions!.index(of: po).map {
                self.paymentOptions!.remove(at: $0)
            }
        }
    }

    func removeReason(r: Reason) {
        if self.reasons!.contains(r) {
            self.reasons!.index(of: r).map {
                self.reasons!.remove(at: $0)
            }
        }
    }

    func removeEducation(e: Education) {
        if self.educations!.contains(e) {
            self.educations!.index(of: e).map {
                self.educations!.remove(at: $0)
            }
        }
    }

    func removeExperience(e: Experience) {
        if self.experiences!.contains(e) {
            self.experiences!.index(of: e).map {
                self.experiences!.remove(at: $0)
            }
        }
    }

    // Super getters and setters
    func getContactNumberAsString() -> String {
        let contactNumber: String = self.contactNumber.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)

        if contactNumber.count != 10
            && contactNumber.count != 12 {
            return ErrorCode.DATA_FORMAT_ERROR
        }
 
        if contactNumber[0] == "+" {
            return contactNumber.substring(fromIndex: 0, toIndex: 3) +
                    " " +
                    contactNumber[3] +
                    " " +
                contactNumber.substring(fromIndex: 4, toIndex: 6) +
                    " " +
                contactNumber.substring(fromIndex: 6, toIndex: 8) +
                    " " +
                contactNumber.substring(fromIndex: 8, toIndex: 10) +
                    " " +
                contactNumber.substring(fromIndex: 10)
        }

        return contactNumber.substring(fromIndex: 0, toIndex: 2) +
                " " +
            contactNumber.substring(fromIndex: 2, toIndex: 4) +
                " " +
            contactNumber.substring(fromIndex: 4, toIndex: 6) +
                " " +
            contactNumber.substring(fromIndex: 6, toIndex: 8) +
                " " +
            contactNumber.substring(fromIndex: 8)
    }

    // Return the appropriate warning message
    func getWarningMessage() -> String {
        return self.thirdPartyPayment ?
                Strings.APPOINTMENT_SUMMARY_WARNING_MSG_THIRD_PARTY_PAYMENT_TRUE :
                Strings.APPOINTMENT_SUMMARY_WARNING_MSG_THIRD_PARTY_PAYMENT_FALSE
    }

    // Return prices and refunds data as a string
    func getPricesAndRefundsAsString() -> String {
        var underAgreement: String = "- "
        underAgreement += self.underAgreement ?
                Strings.DOCTOR_PROFILE_IS_UNDER_AGREEMENT_TRUE : Strings.DOCTOR_PROFILE_IS_UNDER_AGREEMENT_FALSE

        var healthInsuranceCard: String = "- "
        healthInsuranceCard += self.healthInsuranceCard ?
                Strings.DOCTOR_PROFILE_IS_HEALTH_INSURANCE_CARD_TRUE : Strings.DOCTOR_PROFILE_IS_HEALTH_INSURANCE_CARD_FALSE

        let thirdPartyPayment: String = self.thirdPartyPayment ?
                "- " + Strings.DOCTOR_PROFILE_IS_THIRD_PARTY_PAYMENT_TRUE : ""

        return (underAgreement + "\n"
                + healthInsuranceCard + "\n"
                + thirdPartyPayment).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Return doctor payment options as a string
    func getPaymentOptionsAsString() -> String {
        var paymentOptions: String = ""

        for po in self.paymentOptions! { paymentOptions += po.rawValue + ", " }

        if paymentOptions.isEmpty { return paymentOptions }

        paymentOptions = StringFormatterService.Capitalize(str: paymentOptions)
        paymentOptions = paymentOptions.substring(fromIndex: 0, toIndex: paymentOptions.lastIndex(of: ",")!.encodedOffset)

        return paymentOptions
    }

    // Return doctor languages as a string
    func getLanguagesAsString() -> String {
        var languages: String = ""

        for l in self.languages! {
            languages += "- " + l.rawValue + "\n"
        } 

        return languages.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Return educations as a string
    func getEducationsAsString() -> String {
        var educations: String = ""

        for e in self.educations! {
            educations += "- " + e.getYear() + ": " + e.getDegree() + "\n"
        }

        return educations.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Return experiences as a string
    func getExperiencesAString() -> String {
        var experiences: String = ""

        for e in self.experiences! {
            experiences += "- " + e.getYear() + ": " + e.getDescription() + "\n"
        } 

        return experiences.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Organize the availabilities by day
    func getAvailabilitiesPerDay(weeksNumber: Int) -> [Int: [String: [Availability]]] {
        var availabilitiesPerDay: [Int: [String: [Availability]]] = [Int: [String: [Availability]]]()
        var availabilitiesPerDayRef: [String: [Availability]] = [String: [Availability]]()

        for a: Availability in self.availabilities! {
            if availabilitiesPerDayRef[a.getDate()] != nil {
                availabilitiesPerDayRef[a.getDate()] = [Availability]()
            }
        }

        for x in 0...7 * weeksNumber {
            let date: String = DateTimeService.GetDateFromCurrent(daysToAdd: x)
            
            if availabilitiesPerDayRef[DateTimeService.GetDayFromDate(date: date)] != nil {
                availabilitiesPerDay[availabilitiesPerDay.count]![date] = [Availability]()
            }
        }

        for a: Availability in self.availabilities! {
            if availabilitiesPerDayRef[a.getDate()] != nil {
                availabilitiesPerDayRef[a.getDate()]!.append(a)
            }
        }

        for x in 0...(availabilitiesPerDay.count - 1) {
            let fullDate: String = Array(availabilitiesPerDay[x]!.keys).first! // availabilitiesPerDay[x].keys should contain the same key which is the full date so it's not important to have it sorted 
            let day = DateTimeService.GetDayFromDate(date: fullDate)

            if availabilitiesPerDayRef[day] != nil {
                for a: Availability in availabilitiesPerDayRef[day]! {
                    for x in 0...(availabilitiesPerDay.count-1) {
                        if availabilitiesPerDay[x]![day] != nil {
                            availabilitiesPerDay[x]![day]!.append(
                                Availability(
                                    doctor: self,
                                    date: fullDate,
                                    time: a.getTime()
                                )
                            )
                        }
                    }
                }
            }
        }

        return availabilitiesPerDay
    }

    // Organize the availabilities for the given day
    func getAvailabilitiesForDay(bookingFullDate: String) -> [String: [Availability]] {
        var availabilitiesForDay: [String: [Availability]] = [String: [Availability]]()
        availabilitiesForDay[bookingFullDate] = [Availability]()

        for a: Availability in self.availabilities! {
            if a.getDate() == DateTimeService.GetDayFromDate(date: bookingFullDate) {
                availabilitiesForDay[bookingFullDate]!.append(
                    Availability(
                        doctor: self,
                        date: bookingFullDate,
                        time: a.getTime()
                    )
                )
            }
        }

        return availabilitiesForDay
    }

    // Update doctor data
    override func update() -> Resident {
        return DoctorDatabaseHelper().getDoctor(
            doctorId: self.getId(),
            email: nil,
            fromPatient: false
        )!;
    }
    
    // Transitive getters and setters
    func SetReasonId(reason: Reason, reasonId: Int) {
        if self.reasons!.contains(reason) { reason.setId(id: reasonId) }
    }
}
