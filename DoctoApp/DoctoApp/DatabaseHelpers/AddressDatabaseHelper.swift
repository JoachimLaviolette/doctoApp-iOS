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

class AddressDatabaseHelper: DoctoAppDatabaseHelper {
    static let tableName = "address"
    static let table = Table("address")
    
    // Fields
    static let id = Expression<Int64>("id")
    static let street1 = Expression<String>("street1")
    static let street2 = Expression<String>("street2")
    static let city = Expression<String>("city")
    static let zip = Expression<String>("zip")
    static let country = Expression<String>("country")
    
    override init() {}
    
    // Insert a new address in the database related to the given resident
    func insertAddress(resident: Resident) -> Resident {
        self.initDb()
        
        let query = AddressDatabaseHelper.table.insert(
            AddressDatabaseHelper.street1 <- resident.GetStreet1(),
            AddressDatabaseHelper.street2 <- resident.GetStreet2(),
            AddressDatabaseHelper.city <- resident.GetCity(),
            AddressDatabaseHelper.zip <- resident.GetZip(),
            AddressDatabaseHelper.country <- resident.GetCountry()
        )
        
        do {
            let addressId = try self.database.run(query)
            
            if addressId != -1 {
                let address: Address? = self.getAddress(addressId: Int(addressId))
                resident.setAddress(address: address!)
                print("Address insertion succeeded for resident: " + resident.getFullname())
            } else { print("Address insertion failed for resident: " + resident.getFullname()) }
        } catch {
            print("Address insertion failed for resident: " + resident.getFullname())
        }
        
        return resident
    }
    
    // Update the address of the given resident
    func updateAddress(resident: Resident) -> Bool {
        self.initDb()
        
        let filter = AddressDatabaseHelper.table.filter(AddressDatabaseHelper.id == Int64(resident.GetAddressId()))
        let query = filter.update(
            AddressDatabaseHelper.street1 <- resident.GetStreet1(),
            AddressDatabaseHelper.street2 <- resident.GetStreet2(),
            AddressDatabaseHelper.city <- resident.GetCity(),
            AddressDatabaseHelper.zip <- resident.GetZip(),
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
        self.initDb()
        
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
                    zip: try address.get(AddressDatabaseHelper.zip),
                    country: try address.get(AddressDatabaseHelper.country)
                )
            }
        } catch {
            print("Something went wrong when fetching address data.")
        }
        
        return nil
    }
}
