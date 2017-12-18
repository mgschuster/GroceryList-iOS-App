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
    
    func configureCell(title: String, description: String) {
        self.groupTitleLbl.text = title
        self.descriptionLbl.text = description
    }
}
