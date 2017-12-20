//
//  ShadowButton.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.50
        self.layer.shadowRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = 7.0
    }

}
