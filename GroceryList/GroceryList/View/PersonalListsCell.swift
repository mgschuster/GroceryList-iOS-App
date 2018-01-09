//
//  PersonalListsCell.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 1/5/18.
//  Copyright © 2018 TJSchoost. All rights reserved.
//

import UIKit

class PersonalListsCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var listTitleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var listCountLbl: CircleLabel!
    
    func configureCell(title: String, description: String, listCount: Int, listCheckCount: Int) {
        self.listTitleLbl.text = title
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
            self.listCountLbl.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
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
