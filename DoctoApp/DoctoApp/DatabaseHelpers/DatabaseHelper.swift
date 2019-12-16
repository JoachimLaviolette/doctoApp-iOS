//
//  DatabaseHelper.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 12/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import Foundation

protocol DatabaseHelper {
    func initTableConfig()
    func dropTable()
    func createTable()
}
