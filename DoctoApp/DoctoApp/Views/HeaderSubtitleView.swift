//
//  HeaderSubtitleView.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 16/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class HeaderSubtitleView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerSubtitle: UILabel!
    
    private static let xibFile: String = "HeaderSubtitle"
    
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
        Bundle.main.loadNibNamed(HeaderSubtitleView.xibFile, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
