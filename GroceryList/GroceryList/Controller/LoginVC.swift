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
    }
    
    @IBAction func signUpBtnWasPressed(_ sender: Any) {
        let CreateAccountVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC")
        present(CreateAccountVC!, animated: true, completion: nil)
    }
    
}
