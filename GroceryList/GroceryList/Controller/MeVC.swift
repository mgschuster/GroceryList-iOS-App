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
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameBtn: ShadowButton!
    @IBOutlet weak var nameTextField: BluePlaceholder!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.printUsername(forUID: (Auth.auth().currentUser?.uid)!) { (returnedUsername) in
            self.usernameLbl.text = returnedUsername
        }
        
        warningLbl.text = ""
        
        emailLbl.text = Auth.auth().currentUser?.email
        if nameLbl.text != "" {
            nameBtn.setTitle("Update Name", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadNameName()
    }
    
    @objc func textFieldDidChange() {
        warningLbl.text = ""
    }
    
    func reloadNameName() {
        DataService.instance.printNameName(forUID: (Auth.auth().currentUser?.uid)!) { (returnedNameName) in
            self.nameLbl.text = returnedNameName
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
    
    @IBAction func nameBtnWasPressed(_ sender: Any) {
        if nameTextField.text != "" && nameTextField.text != "NAME..." && nameTextField.text != nil {
            if nameTextField.text != nameLbl.text {
                nameBtn.isEnabled = true
                let uid = Auth.auth().currentUser?.uid
                
                DataService.instance.uploadNameName(forUID: uid!, andName: nameTextField.text!, sendComplete: { (isComplete) in
                    if isComplete {
                        self.successHaptic()
                        self.nameBtn.isEnabled = true
                        self.reloadNameName()
                        self.nameTextField.text = ""
                        self.warningLbl.text = ""
                    } else {
                        self.nameBtn.isEnabled = true
                    }
                })
            } else {
                errorHaptic()
                warningLbl.text = "That is the same name as above."
                nameTextField.text = ""
            }
        } else {
            errorHaptic()
            warningLbl.text = "Please fill in the form above."
        }
    }
}

extension MeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
