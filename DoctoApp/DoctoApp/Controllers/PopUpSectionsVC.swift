//
//  PopUpSectionsVC.swift
//  DoctoApp
//
//  Created by Joachim Laviolette on 27/12/2019.
//  Copyright © 2019 DoctoAppLavCop. All rights reserved.
//

import UIKit

struct PopUpSectionsData {
    let title: String
    let content: String
}

class PopUpSectionsVC: UIViewController {
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupSections: UITableView!
    @IBOutlet weak var tableContainer: UIView!
    
    private var popupSectionsData: [PopUpSectionsData]! // must be set by the caling view
    
    private var titleString: String! // must be set by the calling view
    
    private static let titleHeight: CGFloat = 50
    private static let cellHeightMid: CGFloat = 100
    private static let cellHeightBig: CGFloat = 200
    
    private static let popupSectionItemCellIdentifier: String = "popup_section_item_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize controllers components and properties
    func initialize() {
        self.popupTitle.text = self.titleString
        self.popupSections.delegate = self
        self.popupSections.dataSource = self
        self.popupSections.estimatedRowHeight = 100.0
        self.popupSections.rowHeight = UITableView.automaticDimension
    }
    
    // Set view data
    func setData(title: String, popupSectionsData: [PopUpSectionsData]) {
        self.titleString = title
        self.popupSectionsData = popupSectionsData
    }
    
    // Action triggered when the background is clicked
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension PopUpSectionsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.popupSectionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let popupSectionItemCell = tableView.dequeueReusableCell(
            withIdentifier: PopUpSectionsVC.popupSectionItemCellIdentifier,
            for: indexPath
        ) as! PopupSectionItemCell
        popupSectionItemCell.selectionStyle = .none
        popupSectionItemCell.setData(
            title: self.popupSectionsData[indexPath.row].title,
            content: self.popupSectionsData[indexPath.row].content
        )
        
        return popupSectionItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PopUpSectionsVC.cellHeightMid
    }
}
