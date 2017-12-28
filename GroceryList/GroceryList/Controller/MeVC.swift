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
    @IBOutlet weak var currentEmail: BluePlaceholder!
    @IBOutlet weak var newEmail: BluePlaceholder!
    @IBOutlet weak var retypeNewEmail: BluePlaceholder!
    @IBOutlet weak var newUsername: BluePlaceholder!
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
    @IBOutlet weak var upgradeAccntBtn: UIButton!
    
    @IBOutlet weak var nicknameWarningLbl: UILabel!
    @IBOutlet weak var emailWarningLbl: UILabel!
    @IBOutlet weak var usernameWarningLbl: UILabel!
    @IBOutlet weak var passwordWarningLbl: UILabel!
    
    // Variables
    var usernamesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Text Fields
        newNameTextField.delegate = self
        currentEmail.delegate = self
        newEmail.delegate = self
        retypeNewEmail.delegate = self
        newUsername.delegate = self
        newPassword.delegate = self
        retypeNewPassword.delegate = self
        
        // Targets
        newNameTextField.addTarget(self, action: #selector(nameNameTextFieldDidChange), for: .editingChanged)
        
        currentEmail.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        newEmail.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        retypeNewEmail.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        
        newUsername.addTarget(self, action: #selector(usernameTextFieldDidChange), for: .editingChanged)
        
        newPassword.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        retypeNewPassword.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        upgradeAccntBtn.flash()
        reloadUsername()
        
        nicknameWarningLbl.text = ""
        emailWarningLbl.text = ""
        usernameWarningLbl.text = ""
        passwordWarningLbl.text = ""

        reloadEmail()
        reloadUsernames()
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
    
    func reloadEmail() {
        DataService.instance.printDatabaseEmail(forUID: (Auth.auth().currentUser?.uid)!) { (returnedEmail) in
            self.emailLbl.text = returnedEmail
            
            if self.emailLbl.text != Auth.auth().currentUser?.email {
                DataService.instance.changeEmail(forUID: (Auth.auth().currentUser?.uid)!, andAdjustedEmail: (Auth.auth().currentUser?.email)!)
                self.reloadEmail()
            } else {
                return
            }
            
        }
    }
    
    func reloadUsername() {
        DataService.instance.printUsername(forUID: (Auth.auth().currentUser?.uid)!) { (returnedUsername) in
            self.profileNameLbl.text = returnedUsername
            self.usernameLbl.text = returnedUsername
        }
    }

    func reloadNameName() {
        DataService.instance.printNameName(forUID: (Auth.auth().currentUser?.uid)!) { (returnedNameName) in
            if returnedNameName == "" {
                self.nameNameLbl.text = "Please add a nickname below."
            } else {
                self.nameNameLbl.text = returnedNameName
            }
        }
    }
    
    func reloadUsernames() {
        DataService.instance.usernames(handler: { (returnedUsernameArray) in
            self.usernamesArray = returnedUsernameArray
        })
    }
    
    func usernameAvailable(username: String) -> Bool {
        var available: Bool?
        
        if usernamesArray.count >= 1 {
            for user in usernamesArray {
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
    @IBAction func upgradeBtnWasPressed(_ sender: Any) {
//        guard let url = URL(string: "https://itunes.apple.com/us/app/facebook/id284882215?mt=8") else {
//            return
//        }
        let upgradePopup = UIAlertController(title: "UPGRADE ACCOUNT \n(Coming Soon)", message: "A PRO version of this app will be available soon! This will include MANY amazing features such as: \n\n\u{2022} Add people to your group. \n\u{2022} Create unlimited lists for yourself with unique color coding. \n\u{2022} Edit item names and descriptions in both your own and group lists. \n\u{2022} Increased syncing speed. \n\nPlease keep an eye out for updates and have a great day! \n\nTJ Schoost", preferredStyle: .alert)
//        let upAction = UIAlertAction(title: "UPGRADE ACCOUNT", style: .destructive) { (buttonTapped) in
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        let upgradeAction = UIAlertAction(title: "OK!", style: .cancel, handler: nil)
//        upgradePopup.addAction(upAction)
        upgradePopup.addAction(upgradeAction)
        present(upgradePopup, animated: true, completion: nil)
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
                        self.nicknameWarningLbl.text = "SUCCESS"
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
        
        let currentUID = Auth.auth().currentUser?.uid
        let changeEmailPopup = UIAlertController(title: "Update Email?", message: "Your email will be updated and an email will be sent to verify. Please double-check new email for any typos before updating.", preferredStyle: .alert)
        
        if currentEmail.text != "" && newEmail.text != "" && retypeNewEmail.text != "" {
            if currentEmail.text == emailLbl.text {
                if newEmail.text == retypeNewEmail.text {
                    let changeEmailAction = UIAlertAction(title: "UPDATE EMAIL", style: .destructive, handler: { (buttonTapped) in
                        Auth.auth().currentUser?.updateEmail(to: self.retypeNewEmail.text!, completion: { (error) in
                            
                            if String(describing: error?.localizedDescription) == "Optional(\"This operation is sensitive and requires recent authentication. Log in again before retrying this request.\")" {
                                self.errorHaptic()
                                self.emailWarningLbl.text = "Recent authentication is required. Please sign back in and try again."
                                self.currentEmail.text = ""
                                self.newEmail.text = ""
                                self.retypeNewEmail.text = ""
                            } else if error != nil {
                                self.emailWarningLbl.text = "There was an error. Please try again."
                                print(String(describing: error?.localizedDescription))
                            } else {
                                DataService.instance.changeEmail(forUID: currentUID!, andAdjustedEmail: self.retypeNewEmail.text!)
                                self.successHaptic()
                                self.currentEmail.text = ""
                                self.newEmail.text = ""
                                self.retypeNewEmail.text = ""
                                self.reloadEmail()
                                self.emailWarningLbl.text = "SUCCESS"
                                
                                let changeSuccessPopup = UIAlertController(title: "SUCCESS", message: "Your email has been successfully changed. Check your initial email for confirmation.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                changeSuccessPopup.addAction(okAction)
                                self.present(changeSuccessPopup, animated: true, completion: nil)
                                
                            }
                        })
                    })
                    let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                    changeEmailPopup.addAction(changeEmailAction)
                    changeEmailPopup.addAction(cancelAction)
                    self.present(changeEmailPopup, animated: true, completion: nil)
                } else {
                    self.errorHaptic()
                    self.emailWarningLbl.text = "New emails are not the same."
                }
            } else {
                self.errorHaptic()
                self.emailWarningLbl.text = "That is not your current email."
            }
        } else {
            self.errorHaptic()
            self.emailWarningLbl.text = "Please completely fill in all forms above."
        }
    }
    
    @IBAction func changeUsernameBtnWasPressed(_ sender: Any) {
        
        let currentUID = Auth.auth().currentUser?.uid
        let changeUsernamePopup = UIAlertController(title: "Change Username?", message: "Your username is about to change. Make sure you really, really like it.", preferredStyle: .alert)
        
        if self.newUsername.text != "" && self.newUsername.text != "new username" {
            if self.newUsername.text != self.profileNameLbl.text {
                if self.newUsername.text!.count >= 5 && self.newUsername.text!.count <= 17 {
                    if !self.newUsername.text!.contains(" ") {
                        
                        self.reloadUsernames()
                        let usernameAvailable = self.usernameAvailable(username: self.newUsername.text!)
                        
                        if usernameAvailable {
                            let changeUsernameAction = UIAlertAction(title: "CHANGE USERNAME", style: .destructive, handler: { (buttonTapped) in
                                DataService.instance.changeUsername(forUID: currentUID!, andAdjustedUsername: self.newUsername.text!)
                                DataService.instance.addUsername(uid: currentUID!, username: self.newUsername.text!)
                                DataService.instance.deleteFromUsernames(username: self.profileNameLbl.text!)
                                DataService.instance.changeMaster(currentUsername: self.profileNameLbl.text!, changedUsername: self.newUsername.text!)
                                DataService.instance.changeUsersInGroup(currentUsername: self.profileNameLbl.text!, changedUsername: self.newUsername.text!, uid: currentUID!)
                                DataService.instance.changeMarkedOffBy(currentUsername: self.profileNameLbl.text!, changedUsername: self.newUsername.text!)
                                DataService.instance.changeAddedBy(currentUsername: self.profileNameLbl.text!, changedUsername: self.newUsername.text!)
                                self.successHaptic()
                                self.reloadUsername()
                                self.reloadUsernames()
                                self.newUsername.text = ""
                                self.usernameWarningLbl.text = ""
                                
                                let changeSuccessPopup = UIAlertController(title: "SUCCESS", message: "Your username has been successfully changed. CONGRATULATIONS!", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                changeSuccessPopup.addAction(okAction)
                                self.present(changeSuccessPopup, animated: true, completion: nil)
                                
                            })
                            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                            changeUsernamePopup.addAction(changeUsernameAction)
                            changeUsernamePopup.addAction(cancelAction)
                            self.present(changeUsernamePopup, animated: true, completion: nil)
                        } else {
                            self.errorHaptic()
                            self.usernameWarningLbl.text = "An account with that username already exists."
                            self.newUsername.text = ""
                        }
                    } else {
                        self.errorHaptic()
                        self.usernameWarningLbl.text = "New username must not contain a space."
                        self.newUsername.text = ""
                    }
                } else {
                    self.errorHaptic()
                    self.usernameWarningLbl.text = "Username must be between 5 and 17 characters."
                    self.newUsername.text = ""
                }
            } else {
                self.errorHaptic()
                self.usernameWarningLbl.text = "New username is the same as current username. Please try again."
                self.newUsername.text = ""
            }
        } else {
            self.errorHaptic()
            self.usernameWarningLbl.text = "Please fill in the form above."
            self.newUsername.text = ""
        }
    }
    
    @IBAction func changePswdBtnWasPressed(_ sender: Any) {
        
        let changePasswordPopup = UIAlertController(title: "Change Password?", message: "Your password will be changed. This cannot be undone. Are you sure you want to do this?", preferredStyle: .alert)
        
        if newPassword.text != "" && retypeNewPassword.text != "" {
            if newPassword.text == retypeNewPassword.text {
                if retypeNewPassword.text!.count >= 6 {
                    let changePasswordAction = UIAlertAction(title: "CHANGE PASSWORD", style: .destructive, handler: { (buttonTapped) in
                        Auth.auth().currentUser?.updatePassword(to: self.retypeNewPassword.text!, completion: { (error) in
                            if String(describing: error?.localizedDescription) == "Optional(\"This operation is sensitive and requires recent authentication. Log in again before retrying this request.\")" {
                                self.errorHaptic()
                                self.passwordWarningLbl.text = "Recent authentication is required. Please sign back in and try again."
                                self.newPassword.text = ""
                                self.retypeNewPassword.text = ""
                            } else if error != nil {
                                print(String(describing: error?.localizedDescription))
                            } else {
                                self.successHaptic()
                                self.newPassword.text = ""
                                self.retypeNewPassword.text = ""
                                self.passwordWarningLbl.text = ""
                                
                                let changeSuccessPopup = UIAlertController(title: "SUCCESS", message: "Your password has been successfully changed. CONGRATULATIONS!", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                changeSuccessPopup.addAction(okAction)
                                self.present(changeSuccessPopup, animated: true, completion: nil)
                            }
                        })
                    })
                    let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                    changePasswordPopup.addAction(changePasswordAction)
                    changePasswordPopup.addAction(cancelAction)
                    self.present(changePasswordPopup, animated: true, completion: nil)
                } else {
                    self.errorHaptic()
                    self.passwordWarningLbl.text = "Password must be 6+ characters long."
                    self.newPassword.text = ""
                    self.retypeNewPassword.text = ""
                }
            } else {
                self.errorHaptic()
                self.passwordWarningLbl.text = "Passwords do not match."
                self.newPassword.text = ""
                self.retypeNewPassword.text = ""
            }
        } else {
            self.errorHaptic()
            self.passwordWarningLbl.text = "Please fill in all forms above."
            self.newPassword.text = ""
            self.retypeNewPassword.text = ""
        }
    }
    
    @IBAction func deleteAcntBtnWasPressed(_ sender: Any) {
        let deletePopup = UIAlertController(title: "DELETE ACCOUNT", message: "This will fully delete your account and erase everything you ever worked for... (in this app). If this isn't permanent you can always sign out instead.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "DELETE ACCOUNT", style: .destructive) { (buttonTapped) in
            let confirmDeletePopup = UIAlertController(title: "LAST CHANCE...", message: "Are you sure you want to delete this account. Please choose wisely as this cannot be undone.", preferredStyle: .alert)
            
            let confirmDeleteAction = UIAlertAction(title: "YES I'M SURE", style: .destructive, handler: { (buttonTapped) in
                DataService.instance.deleteFromUsernames(username: self.usernameLbl.text!)
                DataService.instance.deleteUserFromDatabase(uid: (Auth.auth().currentUser?.uid)!)
                DataService.instance.deleteFromGroups(username: self.usernameLbl.text!)
                
                Auth.auth().currentUser?.delete(completion: { (error) in
                    if error != nil {
                        let deleteFailedPopup = UIAlertController(title: "ERROR", message: "There was an error deleting your account. Recent authentication is required. Please sign back in and try again another time.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        deleteFailedPopup.addAction(okAction)
                        self.present(deleteFailedPopup, animated: true, completion: nil)
                    } else {
                        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                        self.present(loginVC!, animated: true, completion: nil)
                    }
                })
            })
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            confirmDeletePopup.addAction(confirmDeleteAction)
            confirmDeletePopup.addAction(cancelAction)
            self.present(confirmDeletePopup, animated: true, completion: nil)
        }
        
        let logoutAction = UIAlertAction(title: "SIGN OUT", style: .default) { (buttonTapped) in
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
        deletePopup.addAction(deleteAction)
        deletePopup.addAction(logoutAction)
        deletePopup.addAction(cancelAction)
        self.present(deletePopup, animated: true, completion: nil)
    }
}

extension MeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
