//
//  GroupList.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/19/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import Foundation

class GroupList {
    private var _item: String
    private var _description: String
    private var _isSelected: Bool
    private var _addedBy: String
    private var _markedOffBy: String
    
    var item: String {
        return _item
    }
    
    var description: String {
        return _description
    }
    
    var isSelected: Bool {
        return _isSelected
    }
    
    var addedBy: String {
        return _addedBy
    }
    
    var markedOffBy: String {
        return _markedOffBy
    }
    
    init(item: String, description: String, isSelected: Bool, addedBy: String, markedOffBy: String) {
        self._item = item
        self._description = description
        self._isSelected = isSelected
        self._addedBy = addedBy
        self._markedOffBy = markedOffBy
    }
}
