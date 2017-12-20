//
//  CircleLabel.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/20/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class CircleLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2.0
    }

}
