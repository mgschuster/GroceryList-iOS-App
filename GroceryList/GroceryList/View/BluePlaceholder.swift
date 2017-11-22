//
//  BluePlaceholder.swift
//  GroceryList
//
//  Created by Admin on 11/22/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class BluePlaceholder: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2117647059, green: 0.5607843137, blue: 1, alpha: 1)])
        self.attributedPlaceholder = placeholder
    }

}
