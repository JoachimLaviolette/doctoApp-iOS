//
//  AddressDatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class AddressDatabaseHelper: DatabaseHelper {
    var database: Connection!
    
    static let tableName = "address"
    static let table = Table("address")
    
    // Fields
    static let id = Expression<Int64>("id")
    static let street1 = Expression<String>("street1")
    static let street2 = Expression<String>("street2")
    static let city = Expression<String>("city")
    private let zip = Expression<String>("zip")
    static let country = Expression<String>("country")
    
    private static var pk = 0
    private var tableExist = false
    
    init() {}
    
    func initTableConfig() {
        if self.database != nil { return }
        
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            let fileUrl = documentDirectory
                .appendingPathComponent(AddressDatabaseHelper.tableName)
                .appendingPathExtension("sqlite3")
            
            self.database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        if !self.tableExist {
            self.tableExist = true
                        
            let createTable = AddressDatabaseHelper.table.create { table in
                table.column(AddressDatabaseHelper.id, primaryKey: .autoincrement)
                table.column(AddressDatabaseHelper.street1)
                table.column(AddressDatabaseHelper.street2)
                table.column(AddressDatabaseHelper.city)
                table.column(self.zip)
                table.column(AddressDatabaseHelper.country)
            }
            
            do {
                try self.database.run(createTable)
                print (AddressDatabaseHelper.tableName + " table was successfully created.")
            } catch {
                print(error)
            }
        }
    }
    
    func dropTable() {
        do {
            try self.database.run(AddressDatabaseHelper.table.drop())
        } catch {}
    }
    
    // Insert a new address in the database related to the given resident
    func insertAddress(resident: Resident) -> Resident {
        self.initTableConfig()
        
        let query = AddressDatabaseHelper.table.insert(
            AddressDatabaseHelper.street1 <- resident.GetStreet1(),
            AddressDatabaseHelper.street2 <- resident.GetStreet2(),
            AddressDatabaseHelper.city <- resident.GetCity(),
            self.zip <- resident.GetZip(),
            AddressDatabaseHelper.country <- resident.GetCountry()
        )
        
        do {
            let addressId = try self.database.run(query)
            let address: Address? = self.getAddress(addressId: Int(addressId))
            resident.setAddress(address: address!)
            
            print("Address insertion succeeded for resident: " + resident.getFullname())
        } catch {
            print("Address insertion failed for resident: " + resident.getFullname())
        }
        
        return resident
    }
    
    // Update the address of the given resident
    func updateAddress(resident: Resident) -> Bool {
        self.initTableConfig()
        
        let filter = AddressDatabaseHelper.table.filter(AddressDatabaseHelper.id == Int64(resident.GetAddressId()))
        let query = filter.update(
            AddressDatabaseHelper.street1 <- resident.GetStreet1(),
            AddressDatabaseHelper.street2 <- resident.GetStreet2(),
            AddressDatabaseHelper.city <- resident.GetCity(),
            self.zip <- resident.GetZip(),
            AddressDatabaseHelper.country <- resident.GetCountry()
        )
        
        do {
            if try self.database.run(query) > 0 {
                print("Address update succeeded for resident: " + resident.getFullname())
                
                return true
            }
            
            print("Address update failed for resident: " + resident.getFullname())
        } catch {
            print("Address update failed for resident: " + resident.getFullname())
        }
        
        return false
    }
    
    // Retrieve an address by its id
    func getAddress(addressId: Int) -> Address? {
        self.initTableConfig()
        
        let query = AddressDatabaseHelper.table
            .select(AddressDatabaseHelper.table[*])
            .filter(AddressDatabaseHelper.id == Int64(addressId))
        
        do {
            for address in try self.database.prepare(query) {               
                return Address(
                    id: Int(try address.get(AddressDatabaseHelper.id)),
                    street1: try address.get(AddressDatabaseHelper.street1),
                    street2: try address.get(AddressDatabaseHelper.street2),
                    city: try address.get(AddressDatabaseHelper.city),
                    zip: try address.get(self.zip),
                    country: try address.get(AddressDatabaseHelper.country)
                )
            }
        } catch {
            print("Something went wrong when fetching address data.")
        }
        
        return nil
    }
}
