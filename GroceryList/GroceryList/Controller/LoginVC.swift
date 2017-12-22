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
    @IBOutlet weak var verificationCodeBtn: UIButton!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        self.hideKeyboardWhenTappedAround()
        verificationCodeBtn.isHidden = true
        verificationCodeBtn.isEnabled = false
        resetPasswordBtn.isEnabled = false
        emailField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
        verificationCodeBtn.isHidden = true
        verificationCodeBtn.isEnabled = false
        resetPasswordBtn.isEnabled = false
        resetPasswordBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        warningLbl.text = ""
        emailField.text = ""
        passwordField.text = ""
    }
    
    @objc func passwordFieldDidChange() {
        warningLbl.text = ""
        verificationCodeBtn.isHidden = true
        verificationCodeBtn.isEnabled = false
    }
    
    @objc func emailTextFieldDidChange() {
        warningLbl.text = ""
        verificationCodeBtn.isHidden = true
        verificationCodeBtn.isEnabled = false
        
        resetPasswordBtn.isEnabled = false
        resetPasswordBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    }
    
    // Actions
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete: { (success, loginError) in
                if success {
                    if Auth.auth().currentUser?.isEmailVerified == false {
                        do {
                            self.errorHaptic()
                            try Auth.auth().signOut()
                            self.errorHaptic()
                            self.warningLbl.text = "This account has not yet been verified. Please verify via email and try again."
                            self.verificationCodeBtn.isEnabled = true
                            self.verificationCodeBtn.isHidden = false
                        } catch {
                            print(error)
                        }
                        
                    } else {
                        self.successHaptic()
                        self.dismiss(animated: true, completion: nil)
                    }
                } else if String(describing: loginError?.localizedDescription) == "Optional(\"There is no user record corresponding to this identifier. The user may have been deleted.\")" {
                    self.errorHaptic()
                    self.warningLbl.text = "No user with that email was found. Please create an account below."
                } else if String(describing: loginError?.localizedDescription) == "Optional(\"The password is invalid or the user does not have a password.\")" {
                    self.errorHaptic()
                    self.warningLbl.text = "Incorrect password. Please try again or reset password via email below."
                    self.resetPasswordBtn.isEnabled = true
                    self.resetPasswordBtn.setTitleColor(#colorLiteral(red: 0.6222327082, green: 1, blue: 0.3476967309, alpha: 1), for: .normal)
                } else if String(describing: loginError?.localizedDescription) == "Optional(\"The email address is badly formatted.\")" {
                    self.errorHaptic()
                    self.warningLbl.text = "Please insert correct email format."
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
            })
        } else {
            self.errorHaptic()
            self.warningLbl.text = "Please fill in the form above."
        }
    }
    
    @IBAction func verificationCodeBtnWasPressed(_ sender: Any) {
        
        let sendVerificationPopup = UIAlertController(title: "Resend Verfication Code?", message: "Another verification email will be sent to \(self.emailField.text!).", preferredStyle: .alert)
        let sendVerificationAction = UIAlertAction(title: "RESEND VERIFICATION", style: .destructive) { (buttonTapped) in
            AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, loginError) in
                if success {
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        self.successHaptic()
                        self.resetPasswordBtn.isEnabled = false
                        self.warningLbl.text = ""
                        self.emailField.text = ""
                        self.passwordField.text = ""
                        self.resetPasswordBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                        self.verificationCodeBtn.isEnabled = false
                        self.verificationCodeBtn.isHidden = true
                        
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print(error)
                        }
                        
                        let successPopup = UIAlertController(title: "SUCCESS", message: "Another verification email has been sent to you. Please allow up to one hour for this email to be delivered.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        successPopup.addAction(okAction)
                        self.present(successPopup, animated: true, completion: nil)
                        
                    })
                }  else {
                    print(String(describing: loginError?.localizedDescription))
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        sendVerificationPopup.addAction(sendVerificationAction)
        sendVerificationPopup.addAction(cancelAction)
        self.present(sendVerificationPopup, animated: true, completion: nil)
    }
    
    @IBAction func resetPswdBtnWasPressed(_ sender: Any) {
        
        let resetPasswordPopup = UIAlertController(title: "Reset Password?", message: "An email providing steps to reset your password will be sent to \(self.emailField.text!).", preferredStyle: .alert)
        let resetPasswordAction = UIAlertAction(title: "RESET PASSWORD", style: .destructive) { (buttonTapped) in
            Auth.auth().sendPasswordReset(withEmail: self.emailField.text!, completion: { (error) in
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                } else {
                    self.successHaptic()
                    self.resetPasswordBtn.isEnabled = false
                    self.warningLbl.text = ""
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.resetPasswordBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                    
                    
                    let successPopup = UIAlertController(title: "SUCCESS", message: "An email providing steps to reset your password has been sent to you. Please allow up to one hour for this email to be delivered.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    successPopup.addAction(okAction)
                    self.present(successPopup, animated: true, completion: nil)
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        resetPasswordPopup.addAction(cancelAction)
        resetPasswordPopup.addAction(resetPasswordAction)
        self.present(resetPasswordPopup, animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnWasPressed(_ sender: Any) {
        lightHaptic()
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
