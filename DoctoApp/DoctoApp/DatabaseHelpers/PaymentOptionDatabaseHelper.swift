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

class PaymentOptionDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "payment_option"
    static let table = Table("payment_option")
    
    // Fields
    private let doctorId = Expression<Int64>("doctor_id")
    private let paymentOption = Expression<String>("payment_option")
    
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
                .appendingPathComponent(PaymentOptionDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
            
            let createTable = PaymentOptionDatabaseHelper.table.create { table in
                table.column(self.doctorId)
                table.column(self.paymentOption)
                
                // Alter table
                table.primaryKey(
                    self.doctorId,
                    self.paymentOption
                )
                
                table.foreignKey(
                    self.doctorId,
                    references: DoctorDatabaseHelper.table, DoctorDatabaseHelper.id,
                    update: .cascade,
                    delete: .cascade
                )
            }
            
            do {
                try self.database.run(createTable)
                print (PaymentOptionDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(PaymentOptionDatabaseHelper.table.drop())
        } catch {}
    }
    
    // Insert all the payment options of the given doctor in the database
    func insertPaymentOptions(doctor: Doctor) -> Doctor {
        for paymentOption: PaymentOption in doctor.getPaymentOptions()! {
            self.insertPaymentOption(paymentOption: paymentOption, doctor: doctor)
        }
        
        return doctor
    }
    
    // Insert a new payment option in the database related to the given doctor
    private func insertPaymentOption(paymentOption: PaymentOption, doctor: Doctor) {
        self.initTableConfig()
        
        let query = PaymentOptionDatabaseHelper.table.insert(
            self.doctorId <- Int64(doctor.getId()),
            self.paymentOption <- paymentOption.rawValue
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
        self.initTableConfig()
        
        if self.dropPaymentOptions(doctor: doctor) {
            let _ = self.insertPaymentOptions(doctor: doctor)
        }
        
        return true
    }
    
    // Drop all the payment options related to the given doctor from the database
    private func dropPaymentOptions(doctor: Doctor) -> Bool {
        self.initTableConfig()
        
        let filter = PaymentOptionDatabaseHelper.table.filter(self.doctorId == Int64(doctor.getId()))
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
        
        self.initTableConfig()
        
        let query = PaymentOptionDatabaseHelper.table
            .select(PaymentOptionDatabaseHelper.table[*])
            .filter(self.doctorId == Int64(doctor.getId()))
        
        do {
            for paymentOption in try self.database.prepare(query) {
                paymentOptions.append(PaymentOption.getValueOf(paymentOptionName: try paymentOption.get(self.paymentOption))!)
            }
        } catch {
            print("Something went wrong when fetching payment options data.")
        }
        
        return paymentOptions
    }
}
