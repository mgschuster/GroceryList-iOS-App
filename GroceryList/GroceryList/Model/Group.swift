//
//  Group.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/18/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import Foundation

class Group {
    private var _groupTitle: String
    private var _groupDesc: String
    private var _key: String
    private var _members: [String]
    private var _master: String
    private var _listCount: Int
    private var _listCheckCount: Int
    
    var groupTitle: String {
        return _groupTitle
    }
    
    var groupDesc: String {
        return _groupDesc
    }
    
    var key: String {
        return _key
    }
    
    var members: [String] {
        return _members
    }
    
    var master: String {
        return _master
    }
    
    var listCount: Int {
        return _listCount
    }
    
    var listCheckCount: Int {
        return _listCheckCount
    }
    
    init(title: String, description: String, key: String, members: [String], master: String, listCount: Int, listCheckCount: Int) {
        self._groupTitle = title
        self._groupDesc = description
        self._key = key
        self._members = members
        self._master = master
        self._listCount = listCount
        self._listCheckCount = listCheckCount
    }
}
