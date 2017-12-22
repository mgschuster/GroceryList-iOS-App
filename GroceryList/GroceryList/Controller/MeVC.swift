//
//  MeVC.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    // Outlets
    @IBOutlet weak var newNameTextField: BluePlaceholder!
    @IBOutlet weak var retypeNewName: BluePlaceholder!
    @IBOutlet weak var currentEmail: BluePlaceholder!
    @IBOutlet weak var newEmail: BluePlaceholder!
    @IBOutlet weak var retypeNewEmail: BluePlaceholder!
    @IBOutlet weak var newUsername: BluePlaceholder!
    @IBOutlet weak var retypeNewUsername: BluePlaceholder!
    @IBOutlet weak var currentPassword: BluePlaceholder!
    @IBOutlet weak var newPassword: BluePlaceholder!
    @IBOutlet weak var retypeNewPassword: BluePlaceholder!
    
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var nameNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var updateNicknameBtn: ShadowButton!
    @IBOutlet weak var updateEmailBtn: ShadowButton!
    @IBOutlet weak var changeUsernameBtn: ShadowButton!
    @IBOutlet weak var updatePasswordBtn: ShadowButton!
    
    @IBOutlet weak var nicknameWarningLbl: UILabel!
    @IBOutlet weak var emailWarningLbl: UILabel!
    @IBOutlet weak var usernameWarningLbl: UILabel!
    @IBOutlet weak var passwordWarningLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Text Fields
        newNameTextField.delegate = self
        currentEmail.delegate = self
        newEmail.delegate = self
        retypeNewEmail.delegate = self
        newUsername.delegate = self
        currentPassword.delegate = self
        newPassword.delegate = self
        retypeNewPassword.delegate = self
        
        // Targets
        newNameTextField.addTarget(self, action: #selector(nameNameTextFieldDidChange), for: .editingChanged)
        
        currentEmail.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        newEmail.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        retypeNewEmail.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        
        newUsername.addTarget(self, action: #selector(usernameTextFieldDidChange), for: .editingChanged)
        
        currentPassword.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        newPassword.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        retypeNewPassword.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.printUsername(forUID: (Auth.auth().currentUser?.uid)!) { (returnedUsername) in
            self.profileNameLbl.text = returnedUsername
            self.usernameLbl.text = returnedUsername
        }
        
        nicknameWarningLbl.text = ""
        emailWarningLbl.text = ""
        usernameWarningLbl.text = ""
        passwordWarningLbl.text = ""

        emailLbl.text = Auth.auth().currentUser?.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadNameName()
    }
    
    @objc func nameNameTextFieldDidChange() {
        nicknameWarningLbl.text = ""
    }
    
    @objc func emailTextFieldDidChange() {
        emailWarningLbl.text = ""
    }
    
    @objc func usernameTextFieldDidChange() {
        usernameWarningLbl.text = ""
    }
    
    @objc func passwordTextFieldDidChange() {
        passwordWarningLbl.text = ""
    }

    func reloadNameName() {
        DataService.instance.printNameName(forUID: (Auth.auth().currentUser?.uid)!) { (returnedNameName) in
            self.nameNameLbl.text = returnedNameName
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "SIGN OUT", style: .destructive) { (buttonTapped) in
            do {
                self.warningHaptic()
                try Auth.auth().signOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.present(loginVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(cancelAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    @IBAction func changeNicknameBtnWasPressed(_ sender: Any) {
        if newNameTextField.text != "" && newNameTextField.text != "new nickname" && newNameTextField.text != nil {
            if newNameTextField.text != nameNameLbl.text {
                let uid = Auth.auth().currentUser?.uid
                
                DataService.instance.uploadNameName(forUID: uid!, andName: newNameTextField.text!, sendComplete: { (isComplete) in
                    if isComplete {
                        self.successHaptic()
                        self.updateNicknameBtn.isEnabled = true
                        self.reloadNameName()
                        self.newNameTextField.text = ""
                        self.nicknameWarningLbl.text = ""
                    } else {
                        self.updateNicknameBtn.isEnabled = true
                    }
                })
            } else {
                errorHaptic()
                nicknameWarningLbl.text = "That is the same name as above."
                newNameTextField.text = ""
            }
        } else {
            errorHaptic()
            nicknameWarningLbl.text = "Please fill in the form above."
        }
    }
    
    @IBAction func changeEmailBtnWasPressed(_ sender: Any) {
        
    }
    
    @IBAction func changeUsernameBtnWasPressed(_ sender: Any) {
        
    }
    
    @IBAction func changePswdBtnWasPressed(_ sender: Any) {
        
    }
    
    @IBAction func nameBtnWasPressed(_ sender: Any) {
//        if nameTextField.text != "" && nameTextField.text != "NAME..." && nameTextField.text != nil {
//            if nameTextField.text != nameLbl.text {
//                nameBtn.isEnabled = true
//                let uid = Auth.auth().currentUser?.uid
//
//                DataService.instance.uploadNameName(forUID: uid!, andName: nameTextField.text!, sendComplete: { (isComplete) in
//                    if isComplete {
//                        self.successHaptic()
//                        self.nameBtn.isEnabled = true
//                        self.reloadNameName()
//                        self.nameTextField.text = ""
//                        self.warningLbl.text = ""
//                    } else {
//                        self.nameBtn.isEnabled = true
//                    }
//                })
//            } else {
//                errorHaptic()
//                warningLbl.text = "That is the same name as above."
//                nameTextField.text = ""
//            }
//        } else {
//            errorHaptic()
//            warningLbl.text = "Please fill in the form above."
//        }
    }
}

extension MeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
