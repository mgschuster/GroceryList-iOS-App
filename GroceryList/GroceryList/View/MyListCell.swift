//
//  MyListCell.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 11/28/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class MyListCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    // Variables
    var showing = false
    
    func configureCell(product: String, withDescription description: String, isSelected: Bool) {
        self.productLbl.text = product
        self.descriptionLbl.text = description
        if isSelected {
            self.checkmark.isHidden = false
        } else {
            self.checkmark.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
