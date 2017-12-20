//
//  GroupCell.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 11/28/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var listCountLbl: CircleLabel!
    
    func configureCell(title: String, description: String, listCount: Int, listCheckCount: Int) {
        self.groupTitleLbl.text = title
        self.descriptionLbl.text = description
        
        if listCount == 0 {
            self.listCountLbl.isHidden = true
        } else {
            self.listCountLbl.isHidden = false
            self.listCountLbl.text = "\(listCheckCount) / \(listCount)"
        }
    }
    
    @IBInspectable var selectionColor: UIColor = .gray {
        didSet {
            configureSelectedBackgroundView()
        }
    }
    
    func configureSelectedBackgroundView() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
    }
}
