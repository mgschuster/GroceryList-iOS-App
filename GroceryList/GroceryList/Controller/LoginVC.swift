//
//  LoginVC.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailField: WhitePlaceholder!
    @IBOutlet weak var passwordField: WhitePlaceholder!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Actions
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    print("Logged in successfully")
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
