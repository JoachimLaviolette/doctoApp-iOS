//
//  PopUpVC.swift
//  DoctoApp
//
//  Created by COPPENS EWEN on 11/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupContent: UILabel!
    
    private var hideActionButtons: Bool = false
    private var titleString: String! // must be set by the calling view
    private var contentString: String! // must be set by the calling view
    private var delegate: PopUpActionDelegator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.hideActionButtons { self.hideButtons() }
        
        self.popupTitle.text = self.titleString
        self.popupContent.text = self.contentString
    }
    
    // Set view data
    func setData(title: String, content: String, hideButtons: Bool = false, delegate: PopUpActionDelegator? = nil) {
        self.hideActionButtons = hideButtons
        self.titleString = title
        self.contentString = content
        self.delegate = delegate
    }
    
    // Action triggered when the background is clicked
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Action triggered when discard button is clicked
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Action triggered when confirm button is clicked
    @IBAction func confirm(_ sender: Any) {
        self.delegate?.doAction()
        dismiss(animated: true, completion: nil)
    }
    
    // Hide actions buttons
    func hideButtons() {
        self.confirmButton.isHidden = true
        self.discardButton.isHidden = true
    }
}
