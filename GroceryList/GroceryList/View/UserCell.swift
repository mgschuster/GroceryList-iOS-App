//
//  UserCell.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/15/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var usernameLbl: UILabel!
    
    func configureCell(username: String, isSelected: Bool) {
        self.usernameLbl.text = username
        if isSelected {
            self.usernameLbl.textColor = #colorLiteral(red: 0.2685465515, green: 0.6267361641, blue: 0.2813494205, alpha: 1)
        } else {
            self.usernameLbl.textColor = #colorLiteral(red: 0.2117647059, green: 0.5607843137, blue: 1, alpha: 1)
        }
    }    
}
