//
//  GroceryList.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/11/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import Foundation

class GroceryList {
    private var _item: String
    private var _description: String
    private var _isSelected: Bool
    
    var item: String {
        return _item
    }
    
    var description: String {
        return _description
    }
    
    var isSelected: Bool {
        return _isSelected
    }
    
    init(item: String, description: String, isSelected: Bool) {
        self._item = item
        self._description = description
        self._isSelected = isSelected
    }
}
