//
//  AuthService.swift
//  GroceryList
//
//  Created by Admin on 11/22/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, andUsername username: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email, "username": username]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            DataService.instance.addUsername(uid: user.uid, username: username)
            DataService.instance.addNameName(uid: user.uid)
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print(error.debugDescription)
            })
            
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
