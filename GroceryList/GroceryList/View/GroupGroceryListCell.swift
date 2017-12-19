//
//  GroupGroceryListCell.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/18/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class GroupGroceryListCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var addedByLbl: UILabel!
    @IBOutlet weak var markedByLbl: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    func configureCell(item: String, description: String, addedBy: String, markedBy: String, isSelected: Bool) {
        self.itemLbl.text = item
        self.descriptionLbl.text = description
        self.addedByLbl.text = "Added by: \(addedBy)"
        self.markedByLbl.text = "Checked off by: \(markedBy)"
        if isSelected {
            self.checkmark.isHidden = false
            self.markedByLbl.textColor = #colorLiteral(red: 0.2685465515, green: 0.6267361641, blue: 0.2813494205, alpha: 1)
        } else {
            self.checkmark.isHidden = true
            self.markedByLbl.textColor = #colorLiteral(red: 0.662745098, green: 0.4549019608, blue: 1, alpha: 1)
        }
    }
}
