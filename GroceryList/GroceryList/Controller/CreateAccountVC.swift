//
//  CreateAccountVC.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameField: BluePlaceholder!
    @IBOutlet weak var emailField: BluePlaceholder!
    @IBOutlet weak var passwordField: WhitePlaceholder!
    @IBOutlet weak var confirmPasswordField: WhitePlaceholder!
    @IBOutlet weak var warningLbl: UILabel!
    
    // Variables
    var usernameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadUsernames()
    }
    
    func reloadUsernames() {
        DataService.instance.usernames(handler: { (returnedUsernameArray) in
            self.usernameArray = returnedUsernameArray
        })
    }
    
    func usernameAvailable(username: String) -> Bool {
        var available: Bool?
        
        if usernameArray.count >= 1 {
            for user in usernameArray {
                if user == username {
                    available = false
                    break
                } else {
                    available = true
                }
            }
            return available!
        } else {
            return true
        }
    }
    
    // Actions
    @IBAction func signUpBtnWasPressed(_ sender: Any) {
        if usernameField.text != nil && usernameField.text != "" && usernameField.text != "USERNAME" && emailField.text != "" && passwordField.text != nil && confirmPasswordField.text != nil {
            
            let usernameAvailable = self.usernameAvailable(username: usernameField.text!)
            
            if usernameField.text!.count >= 5 && usernameField.text!.count <= 17 {
                if !usernameField.text!.contains(" ") {
                    if usernameAvailable {
                        if passwordField.text == confirmPasswordField.text {
                            AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, andUsername: self.usernameField.text!, userCreationComplete: { (success, registrationError) in
                                if success {
                                    AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                                        self.successHaptic()
                                        self.dismiss(animated: true, completion: nil)
                                        print("Successfully registered user")
                                    })
                                } else if String(describing: registrationError?.localizedDescription) == "Optional(\"The password must be 6 characters long or more.\")" {
                                    self.errorHaptic()
                                    self.warningLbl.text = "Password must be 6+ characters long."
                                } else if String(describing: registrationError?.localizedDescription) == "Optional(\"The email address is badly formatted.\")" {
                                    self.errorHaptic()
                                    self.warningLbl.text = "Invalid email. Please try again."
                                } else if String(describing: registrationError?.localizedDescription) == "Optional(\"The email address is already in use by another account.\")"{
                                    self.errorHaptic()
                                    self.warningLbl.text = "An account with that email already exists. Please try logging in."
                                } else {
                                    print(String(describing: registrationError?.localizedDescription))
                                }
                            })
                        } else {
                            self.errorHaptic()
                            warningLbl.text = "Passwords do not match."
                        }
                    } else {
                        self.errorHaptic()
                        self.warningLbl.text = "An account with that username already exists."
                    }
                } else {
                    self.errorHaptic()
                    self.warningLbl.text = "Username must not contain a space."
                }
            } else {
                self.errorHaptic()
                self.warningLbl.text = "Username must be between 5 and 17 characters."
            }
        } else {
            self.errorHaptic()
            warningLbl.text = "Please fill in all forms above."
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        lightHaptic()
        dismiss(animated: true, completion: nil)
    }
}

extension CreateAccountVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
