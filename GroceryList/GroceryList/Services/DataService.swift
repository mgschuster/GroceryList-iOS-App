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
    private var _REF_USERNAMES = DB_BASE.child("usernames")
    private var _REF_EMAILS = DB_BASE.child("emails")
    
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
    
    var REF_USERNAMES: DatabaseReference {
        return _REF_USERNAMES
    }
    
    var REF_EMAILS: DatabaseReference {
        return _REF_EMAILS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func addUsername(uid: String, username: String) {
        REF_USERNAMES.updateChildValues([username: uid])
    }
    
    func usernames(handler: @escaping (_ usernameList: [String]) -> ()) {
        var usernameArray = [String]()
        
        REF_USERNAMES.observeSingleEvent(of: .value) { (usernameSnapshot) in
            guard let usernameSnapshot = usernameSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usernameSnapshot {
                let usernames = user.key
                usernameArray.append(usernames)
            }
            handler(usernameArray)
        }
    }
    
    func printUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let username = snapshot.childSnapshot(forPath: "username").value as! String
            handler(username)
        }
    }
    
    func uploadItem(withItem item: String, andDescription description: String, forUID uid: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("grocery list").child(item).updateChildValues(["description": description, "isSelected": false])
        sendComplete(true)
    }
    
    func getAllFeedMessages(forUID uid: String, handler: @escaping (_ groceryList: [GroceryList]) -> ()) {
        var groceryListArray = [GroceryList]()
        REF_USERS.child(uid).child("grocery list").observeSingleEvent(of: .value) { (groceryListSnapshot) in
            guard let groceryListSnapshot = groceryListSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for item in groceryListSnapshot {
                let itemName = item.key
                let description = item.childSnapshot(forPath: "description").value as! String
                let selected = item.childSnapshot(forPath: "isSelected").value as! Bool
                let groceryList = GroceryList(item: itemName, description: description, isSelected: selected)
                groceryListArray.append(groceryList)
            }
            handler(groceryListArray)
        }
    }
    
    func getUsernames(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var usernameArray = [String]()
        var currentUser = ""
        
        printUsername(forUID: (Auth.auth().currentUser?.uid)!) { (returnedUsername) in
            currentUser = returnedUsername
        }
        
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                let username = user.childSnapshot(forPath: "username").value as! String
                if username.contains(query) == true && username != currentUser {
                    usernameArray.append(username)
                }
            }
            handler(usernameArray)
        }
    }
    
    func checkOffItem(forUID uid: String, andItemName name: String) {
        REF_USERS.child(uid).child("grocery list").child(name).updateChildValues(["isSelected": true])
    }
    
    func uncheckItem(forUID uid: String, andItemName name: String) {
        REF_USERS.child(uid).child("grocery list").child(name).updateChildValues(["isSelected": false])
    }
    
    func removeItem(forUID uid: String, andItem item: String) {
        REF_USERS.child(uid).child("grocery list").child(item).removeValue()
    }
}
