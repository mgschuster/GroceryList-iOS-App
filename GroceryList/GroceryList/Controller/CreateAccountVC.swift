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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Actions
    @IBAction func signUpBtnWasPressed(_ sender: Any) {
        if usernameField.text != nil && emailField.text != nil && passwordField.text != nil && confirmPasswordField.text != nil {
            if passwordField.text == confirmPasswordField.text {
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, andUsername: self.usernameField.text!, userCreationComplete: { (success, registrationError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully registered user")
                        })
                    } else {
                        print(String(describing: registrationError?.localizedDescription))
                    }
                })
            }
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
