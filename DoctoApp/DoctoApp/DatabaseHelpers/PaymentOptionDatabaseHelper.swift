//
//  PaymentOptionDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class PaymentOptionDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "payment_option"
    static let table = Table("payment_option")
    
    // Fields
    static let doctorId = Expression<Int64>("doctor_id")
    static let paymentOption = Expression<String>("payment_option")
    
    override init() {}
    
    // Insert all the payment options of the given doctor in the database
    func insertPaymentOptions(doctor: Doctor) -> Doctor {
        for paymentOption: PaymentOption in doctor.getPaymentOptions()! {
            self.insertPaymentOption(paymentOption: paymentOption, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new payment option in the database related to the given doctor
    private func insertPaymentOption(paymentOption: PaymentOption, doctor: Doctor) {
        self.initDb()
        
        let query = PaymentOptionDatabaseHelper.table.insert(
            PaymentOptionDatabaseHelper.doctorId <- Int64(doctor.getId()),
            PaymentOptionDatabaseHelper.paymentOption <- paymentOption.rawValue
        )
        
        do {
            try self.database.run(query)
            print("Payment option insertion succeeded for doctor: " + doctor.getFullname())
        } catch {
            print("Payment option insertion failed for doctor: " + doctor.getFullname())
        }
    }
    
    // Update the payment options of the given doctor in the database
    func updatePaymentOptions(doctor: Doctor) -> Bool {
        self.initDb()
        
        if self.dropPaymentOptions(doctor: doctor) {
            let _ = self.insertPaymentOptions(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the payment options related to the given doctor from the database
    private func dropPaymentOptions(doctor: Doctor) -> Bool {
        self.initDb()
        
        let filter = PaymentOptionDatabaseHelper.table.filter(PaymentOptionDatabaseHelper.doctorId == Int64(doctor.getId()))
        let query = filter.delete()
        
        do {
            if try self.database.run(query) > 0 {
                print("Payment options removal succeeded for doctor: " + doctor.getFullname())
                
                return true
            }
            
            print("Payment options removal failed for doctor: " + doctor.getFullname())
        } catch {
            print("Payment options removal failed for doctor: " + doctor.getFullname())
        }
        
        return false
    }
    
    // Retrieve allpayment optionsrelated to the given doctor
    func getPaymentOptions(doctor: Doctor) -> [PaymentOption] {
        var paymentOptions: [PaymentOption] = []
        
        self.initDb()
        
        let query = PaymentOptionDatabaseHelper.table
            .select(PaymentOptionDatabaseHelper.table[*])
            .filter(PaymentOptionDatabaseHelper.doctorId == Int64(doctor.getId()))
        
        do {
            for paymentOption in try self.database.prepare(query) {
                paymentOptions.append(PaymentOption.getValueOf(paymentOptionName: try paymentOption.get(PaymentOptionDatabaseHelper.paymentOption))!)
            }
        } catch {
            print("Something went wrong when fetching payment options data.")
        }
        
        return paymentOptions
    }
}
