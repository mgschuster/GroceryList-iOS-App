//
//  PersonalGroceryListCell.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 1/5/18.
//  Copyright © 2018 TJSchoost. All rights reserved.
//

import UIKit

class PersonalGroceryListCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    // Variables
    var showing = false
    
    func configureCell(item: String, withDescription description: String, isSelected: Bool) {
        self.itemLbl.text = item
        self.descriptionLbl.text = description
        if isSelected {
            self.checkmark.isHidden = false
        } else {
            self.checkmark.isHidden = true
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
