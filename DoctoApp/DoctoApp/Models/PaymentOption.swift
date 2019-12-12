//
//  PaymentOption.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

enum PaymentOption: String {
    case CASH = "Cash"
    case CREDIT_CARD = "Credit card"
    case CHEQUE = "Cheque"

    static func getValueOf(paymentOptionName: String) -> PaymentOption? {
        switch paymentOptionName {
            case "Cash": return CASH
            case "Credit card": return CREDIT_CARD
            case "Cheque": return CHEQUE
            default: return nil
        }
    }
}
