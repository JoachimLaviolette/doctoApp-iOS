//
//  HeaderDashboardSubtitleView.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 16/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class HeaderDashboardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
    private static let xibFile: String = "HeaderDashboard"
    
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
        Bundle.main.loadNibNamed(HeaderDashboardView.xibFile, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
