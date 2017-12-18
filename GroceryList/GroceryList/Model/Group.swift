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
    
    init(title: String, description: String, key: String, members: [String]) {
        self._groupTitle = title
        self._groupDesc = description
        self._key = key
        self._members = members
    }
}
