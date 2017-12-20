//
//  CircleShadowView.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/19/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class CircleShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = (self.bounds.size.width)/2
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.cornerRadius = (self.bounds.size.width)/2
    }

}
