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
    
    func addNameName(uid: String) {
        REF_USERS.child(uid).updateChildValues(["name name": ""])
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
    
    func groupGroceryListItems(groupUID: String, handler: @escaping (_ usernameList: [String]) -> ()) {
        var groceryListItems = [String]()
        
        REF_GROUPS.child(groupUID).child("grocery list").observeSingleEvent(of: .value) { (groceryListSnapshot) in
            guard let groceryList = groceryListSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for item in groceryList {
                groceryListItems.append(item.key)
            }
            
            handler(groceryListItems)
        }
    }
    
    func userListItems(uid: String, handler: @escaping (_ usernameList: [String]) -> ()) {
        var listItems = [String]()
        
        REF_USERS.child(uid).child("grocery list").observeSingleEvent(of: .value) { (listSnapshot) in
            guard let groceryList = listSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for item in groceryList {
                listItems.append(item.key)
            }
            handler(listItems)
        }
    }
    
    func printUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let username = snapshot.childSnapshot(forPath: "username").value as! String
            handler(username)
        }
    }
    
    func printDatabaseEmail(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            handler(email)
        }
    }
    
    func changeUsername(forUID uid: String, andAdjustedUsername username: String) {
        REF_USERS.child(uid).updateChildValues(["username": username])
    }
    
    func changeEmail(forUID uid: String, andAdjustedEmail email: String) {
        REF_USERS.child(uid).updateChildValues(["email": email])
    }
    
    func deleteFromUsernames(username: String) {
        REF_USERNAMES.child(username).removeValue()
    }
    
    func deleteFromGroups(username: String) {
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupList = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupList {
                self.REF_GROUPS.child(group.key).child("members").observeSingleEvent(of: .value, with: { (membersSnapshot) in
                    guard let memberList = membersSnapshot.children.allObjects as? [DataSnapshot] else { return }
                    for member in memberList {
                        if member.key == username {
                            self.REF_GROUPS.child(group.key).child("members").child(member.key).removeValue()
                        }
                    }
                })
            }
        }
    }
    
    func deleteUserFromDatabase(uid: String) {
        REF_USERS.child(uid).removeValue()
    }
    
    func changeAddedBy(currentUsername: String, changedUsername: String) {
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupList = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupList {
                self.REF_GROUPS.child(group.key).child("grocery list").observeSingleEvent(of: .value, with: { (groceryListSnapshot) in
                    guard let groceryList = groceryListSnapshot.children.allObjects as? [DataSnapshot] else { return }
                    for groceryItem in groceryList {
                        let addedBy = groceryItem.childSnapshot(forPath: "added by").value as! String
                        if addedBy == currentUsername {
                            self.REF_GROUPS.child(group.key).child("grocery list").child(groceryItem.key).updateChildValues(["added by": changedUsername])
                        }
                    }
                })
            }
        }
    }
    
    func changeMarkedOffBy(currentUsername: String, changedUsername: String) {
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupList = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupList {
                self.REF_GROUPS.child(group.key).child("grocery list").observeSingleEvent(of: .value, with: { (groceryListSnapshot) in
                    guard let groceryList = groceryListSnapshot.children.allObjects as? [DataSnapshot] else { return }
                    for groceryItem in groceryList {
                        let addedBy = groceryItem.childSnapshot(forPath: "marked off by").value as! String
                        if addedBy == currentUsername {
                            self.REF_GROUPS.child(group.key).child("grocery list").child(groceryItem.key).updateChildValues(["marked off by": changedUsername])
                        }
                    }
                })
            }
        }
    }
    
    func changeMaster(currentUsername: String, changedUsername: String) {
        var updatedUsername = ""
        var groupUID = ""
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupList = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupList {
                groupUID = group.key
                let master = group.childSnapshot(forPath: "master").value as! String
                if master == currentUsername {
                    updatedUsername = changedUsername
                    if updatedUsername != "" {
                        self.REF_GROUPS.child(groupUID).updateChildValues(["master": updatedUsername])
                    }
                }
            }
        }
    }
    
    func changeUsersInGroup(currentUsername: String, changedUsername: String, uid: String) {
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupList = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupList {
                self.REF_GROUPS.child(group.key).child("members").observeSingleEvent(of: .value, with: { (memberSnapshot) in
                    guard let memberList = memberSnapshot.children.allObjects as? [DataSnapshot] else { return }
                    for member in memberList {
                        if member.key == currentUsername {
                            self.REF_GROUPS.child(group.key).child("members").child(currentUsername).removeValue()
                            self.REF_GROUPS.child(group.key).child("members").updateChildValues([changedUsername: uid])
                        }
                    }
                })
            }
        }
    }
    
    func printNameName(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let nameName = snapshot.childSnapshot(forPath: "name name").value as! String
            handler(nameName)
        }
    }
    
    func uploadItem(withItem item: String, andDescription description: String, forUID uid: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("grocery list").child(item).updateChildValues(["description": description, "isSelected": false])
        sendComplete(true)
    }
    
    func uploadNameName(forUID uid: String, andName name: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).updateChildValues(["name name": name])
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
    
    func getAllGroupLists(forUID uid: String, handler: @escaping (_ groceryList: [GroupList]) -> ()){
        var groupListArray = [GroupList]()
        REF_GROUPS.child(uid).child("grocery list").observeSingleEvent(of: .value) { (groupGroceryListSnapshot) in
            guard let groupList = groupGroceryListSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for item in groupList {
                let itemName = item.key
                let description = item.childSnapshot(forPath: "description").value as! String
                let selected = item.childSnapshot(forPath: "isSelected").value as! Bool
                let addedBy = item.childSnapshot(forPath: "added by").value as! String
                let markedOffBy = item.childSnapshot(forPath: "marked off by").value as! String
                let groupList = GroupList(item: itemName, description: description, isSelected: selected, addedBy: addedBy, markedOffBy: markedOffBy)
                groupListArray.append(groupList)
            }
            handler(groupListArray)
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
    
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let username = user.childSnapshot(forPath: "username").value as! String
                if usernames.contains(username) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getUsernamesFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var usernameArray = [String]()
        
        REF_GROUPS.child(group.key).child("members").observeSingleEvent(of: .value) { (usersSnapshot) in
            guard let userSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                usernameArray.append(user.key)
            }
            handler(usernameArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, andMaster master: String, forUsernames usernames: [String : String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["master": master, "title": title, "description": description, "list count": 0, "list check count": 0, "members": usernames])
        handler(true)
    }
    
    func getUsernames(forIds uids: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                for i in 0..<uids.count {
                    if uids[i] == user.key {
                        let uid = user.key
                        idArray.append(uid)
                        break
                    } else {
                        break
                    }
                }
            }
        }
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        var currentUser = ""
        var usernames = [String]()
        
        printUsername(forUID: (Auth.auth().currentUser?.uid)!) { (returnedUsername) in
            currentUser = returnedUsername
        }
        
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                let memberDictionary = group.childSnapshot(forPath: "members").value as! NSDictionary
                
                for (key, _) in memberDictionary {
                    usernames.append(key as! String)
                    
                    let username = key as! String
                    
                    if username == currentUser {
                        let title = group.childSnapshot(forPath: "title").value as! String
                        let description = group.childSnapshot(forPath: "description").value as! String
                        let listCount = group.childSnapshot(forPath: "list count").value as! Int
                        let listCheckCount = group.childSnapshot(forPath: "list check count").value as! Int
                        let master = group.childSnapshot(forPath: "master").value as! String
                        let group = Group(title: title, description: description, key: group.key, members: usernames, master: master, listCount: listCount, listCheckCount: listCheckCount)
                        groupsArray.append(group)
                    }
                }
            }
            handler(groupsArray)
        }
    }
    
    func increaseListCount(forGroupUid uid: String) {
        REF_GROUPS.child(uid).child("list count").observeSingleEvent(of: .value) { (snapshot) in
            let listCount = snapshot.value as! Int
            var value = listCount
            value = value + 1
            self.REF_GROUPS.child(uid).updateChildValues(["list count": value])
        }
    }
    
    func decreaseListCount(forGroupUid uid: String) {
        REF_GROUPS.child(uid).child("list count").observeSingleEvent(of: .value) { (snapshot) in
            let listCount = snapshot.value as! Int
            var value = listCount
            value = value - 1
            self.REF_GROUPS.child(uid).updateChildValues(["list count": value])
        }
    }
    
    func increaseListCheckCount(forGroupUid uid: String) {
        REF_GROUPS.child(uid).child("list check count").observeSingleEvent(of: .value) { (snapshot) in
            let listCheckCount = snapshot.value as! Int
            var value = listCheckCount
            value = value + 1
            self.REF_GROUPS.child(uid).updateChildValues(["list check count": value])
        }
    }
    
    func decreaseListCheckCount(forGroupUid uid: String) {
        REF_GROUPS.child(uid).child("list check count").observeSingleEvent(of: .value) { (snapshot) in
            let listCheckCount = snapshot.value as! Int
            var value = listCheckCount
            value = value - 1
            self.REF_GROUPS.child(uid).updateChildValues(["list check count": value])
        }
    }
    
    func createGroupItem(forGroupUid uid: String, andItem item: String, andDescription description: String, addedBy: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        REF_GROUPS.child(uid).child("grocery list").child(item).updateChildValues(["description": description, "added by": addedBy, "marked off by": "- -", "isSelected": false])
        sendComplete(true)
    }
    
    func markeOffUser(forGroupUid uid: String, andItem item: String, withUser username: String) {
        REF_GROUPS.child(uid).child("grocery list").child(item).updateChildValues(["marked off by": username, "isSelected": true])
        increaseListCheckCount(forGroupUid: uid)
    }
    
    func uncheckUser(forGroupUid uid: String, andItem item: String) {
        REF_GROUPS.child(uid).child("grocery list").child(item).updateChildValues(["marked off by": "- -", "isSelected": false])
        decreaseListCheckCount(forGroupUid: uid)
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
    
    func removeGroupItem(forUID uid: String, andItem item: String) {
        REF_GROUPS.child(uid).child("grocery list").child(item).removeValue()
        decreaseListCount(forGroupUid: uid)
    }
    
    func removeAllItems(forUID uid: String) {
        REF_USERS.child(uid).child("grocery list").removeValue()
    }
    
    func removeGroup(forGroupUID groupUid: String) {
        REF_GROUPS.child(groupUid).removeValue()
    }
    
    func removeUserFromGroup(fromGroupUid groupUid: String, andUserUid uid: String) {
        
        var currentUser = ""
        printUsername(forUID: uid) { (returnedUsername) in
            currentUser = returnedUsername
        }

        REF_GROUPS.child(groupUid).child("members").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let memberList = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for member in  memberList {
                if memberList.count > 1 {
                    if member.key == currentUser {
                        self.REF_GROUPS.child(groupUid).child("members").child(currentUser).removeValue()
                    }
                } else {
                    self.removeGroup(forGroupUID: groupUid)
                }
            }
        }
    }
}
