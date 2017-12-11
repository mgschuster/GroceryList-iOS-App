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
    
    var item: String {
        return _item
    }
    
    var description: String {
        return _description
    }
    
    init(item: String, description: String) {
        self._item = item
        self._description = description
    }
}
