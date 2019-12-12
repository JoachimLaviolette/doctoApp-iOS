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
    private let street1 = Expression<String>("street1")
    private let street2 = Expression<String>("street2")
    private let city = Expression<String>("city")
    private let zip = Expression<String>("zip")
    private let country = Expression<String>("country")
    
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
                table.column(self.street1)
                table.column(self.street2)
                table.column(self.city)
                table.column(self.zip)
                table.column(self.country)
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
}
