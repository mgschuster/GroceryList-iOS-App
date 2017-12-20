//
//  CircleShadowLabel.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/19/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class CircleShadowLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2.0
    }
    
}
