//
//  DataService.swift
//  GroceryList
//
//  Created by Admin on 11/22/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadItem(withItem item: String, andDescription description: String, forUID uid: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("grocery list").updateChildValues([item: description])
        sendComplete(true)
    }
    
    func getAllFeedMessages(forUID uid: String, handler: @escaping (_ groceryList: [GroceryList]) -> ()) {
        var groceryListArray = [GroceryList]()
        REF_USERS.child(uid).child("grocery list").observeSingleEvent(of: .value) { (groceryListSnapshot) in
            guard let groceryListSnapshot = groceryListSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for item in groceryListSnapshot {
                let itemName = item.key
                let description = item.value as! String
                let groceryList = GroceryList(item: itemName, description: description)
                groceryListArray.append(groceryList)
            }
            handler(groceryListArray)
        }
        
//        REF_USERS.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
//            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
//
//            for message in feedMessageSnapshot {
//                let content = message.childSnapshot(forPath: "content").value as! String
//                let senderId = message.childSnapshot(forPath: "senderId").value as! String
//                let message = Message(content: content, senderId: senderId)
//                messageArray.append(message)
//            }
//            handler(messageArray)
//        }
    }
}
