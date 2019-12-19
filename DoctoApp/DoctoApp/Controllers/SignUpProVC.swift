//
//  SignUpProVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 18/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit



class SignUpProVC: UIViewController {
    
    static let languages: [String] = [
        Language.FR.rawValue,
        Language.EN.rawValue,
        Language.ES.rawValue,
        Language.GER.rawValue,
        Language.IT.rawValue
    ]
    static let paymentOptions: [String] = [
        PaymentOption.CASH.rawValue,
        PaymentOption.CREDIT_CARD.rawValue,
        PaymentOption.CHEQUE.rawValue
    ]

    @IBOutlet weak var doctorLanguagesPicker: UIPickerView!
    @IBOutlet weak var doctorPaymentOptionsPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
    }
    
    private func initialize() {
        
        //intitalize the languages in the language picker
        self.doctorLanguagesPicker.delegate = self
        self.doctorLanguagesPicker.dataSource = self
        self.doctorPaymentOptionsPicker.delegate = self
        self.doctorPaymentOptionsPicker.dataSource = self
    }

}

extension SignUpProVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.doctorPaymentOptionsPicker {
            
            return SignUpProVC.paymentOptions.count
        }
        return SignUpProVC.languages.count
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.doctorPaymentOptionsPicker {
            
            return SignUpProVC.paymentOptions[row]
        }
        return SignUpProVC.languages[row]
        
    }

}
