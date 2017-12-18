//
//  LoginVC.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailField: WhitePlaceholder!
    @IBOutlet weak var passwordField: WhitePlaceholder!
    @IBOutlet weak var warningLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Actions
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    print("Logged in successfully")
                } else if String(describing: loginError?.localizedDescription) == "Optional(\"There is no user record corresponding to this identifier. The user may have been deleted.\")" {
                    self.warningLbl.text = "No user with that email was found. Please create an account below."
                } else if String(describing: loginError?.localizedDescription) == "Optional(\"The password is invalid or the user does not have a password.\")" {
                    self.warningLbl.text = "Incorrect email or password, please try again."
                } else if String(describing: loginError?.localizedDescription) == "Optional(\"The email address is badly formatted.\")" {
                    self.warningLbl.text = "Please insert correct email above."
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
            })
        }
    }
    
    @IBAction func signUpBtnWasPressed(_ sender: Any) {
        let CreateAccountVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC")
        present(CreateAccountVC!, animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
