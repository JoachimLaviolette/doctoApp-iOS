//
//  HeaderSubtitleView.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 16/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class HeaderDashboardSubtitleView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerSubtitle: UILabel!
    
    private var headerDelegator: HeaderDelegator! // must be  set by the calling view
    
    private static let xibFile: String = "HeaderDashboardSubtitle"
    
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
        Bundle.main.loadNibNamed(HeaderDashboardSubtitleView.xibFile, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // Set view data
    func setData(headerDelegator: HeaderDelegator, headerTitle: String, headerSubtitle: String) {
        self.headerDelegator = headerDelegator
        self.headerTitle.text = headerTitle
        self.headerSubtitle.text = headerSubtitle
    }
    
    // Action triggered when home button is clicked
    @IBAction func home(_ sender: UIButton) {
        self.headerDelegator.home()
    }
    
    // Action triggered when dashboard button is clicked
    @IBAction func dashboard(_ sender: UIButton) {
        self.headerDelegator.dashboard()
    }
}
