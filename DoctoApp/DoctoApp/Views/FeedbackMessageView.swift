//
//  FeedbackMessageView.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 16/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class FeedbackMessageView: UIView {
    @IBOutlet var contentView: FeedbackMessageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    var isErrorMsg: Bool = false
    
    private static let xibFile: String = "FeedbackMessage"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    // Initialize controller properties
    private func initialize() {
        Bundle.main.loadNibNamed(FeedbackMessageView.xibFile, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // Set feedback message data
    func setData(title: String, content: String, isErrorMsg: Bool) {
        if isErrorMsg { self.contentView.backgroundColor = UIColor(hex: Colors.CONFIRM_APPOINTMENT_ERROR_MSG) }
        else { self.contentView.backgroundColor = UIColor(hex: Colors.CONFIRM_APPOINTMENT_SUCCESS_MSG) }
        
        self.title.text = title
        self.content.text = content
    }
}
