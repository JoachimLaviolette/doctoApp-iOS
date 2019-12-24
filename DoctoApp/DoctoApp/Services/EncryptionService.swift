//
//  DateTimeService.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 24/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import Foundation

class EncryptionService {
    // SHA1 the given string
    static func SHA1(string: String) -> String {
        var encryptedString: String = string
        


        return encryptedString
    }

    // Create a unique random and ecrypted salt
    static func SALT() -> String {
        return EncryptionService.SHA1(string: UUID().uuidString)
    }
}
