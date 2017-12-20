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
        
        if listCount == listCheckCount {
            self.listCountLbl.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.6274509804, blue: 0.2784313725, alpha: 1)
        } else {
            self.listCountLbl.backgroundColor = #colorLiteral(red: 0.7099999785, green: 0.7099999785, blue: 0.7099999785, alpha: 1)
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
