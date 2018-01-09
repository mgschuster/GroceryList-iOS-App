//
//  PersonalList.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 1/5/18.
//  Copyright © 2018 TJSchoost. All rights reserved.
//

import Foundation

class PersonalList {
    private var _listTitle: String
    private var _listDescription: String
    private var _listCount: Int
    private var _listCheckCount: Int
    
    var listTitle: String {
        return _listTitle
    }
    
    var listDescription: String {
        return _listDescription
    }
    
    var listCount: Int {
        return _listCount
    }
    
    var listCheckCount: Int {
        return _listCheckCount
    }
    
    init(title: String, description: String, listCount: Int, listCheckCount: Int) {
        self._listTitle = title
        self._listDescription = description
        self._listCount = listCount
        self._listCheckCount = listCheckCount
    }
}
