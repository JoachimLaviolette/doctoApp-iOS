//
//  Language.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

enum Language: String {
    case FR = "French"
    case EN = "English"
    case ES = "Spanish"
    case GER = "German"
    case IT = "Italian"

    static func getValueOf(languageName: String) -> Language? {
        switch languageName {
            case "French": return FR
            case "English": return EN
            case "Spanish": return ES
            case "German": return GER
            case "Italian": return IT
            default: return nil
        }
    }
}
