//
//  AddGroupItemVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/18/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class AddGroupItemVC: UIViewController {
    
    // Outlet
    @IBOutlet weak var itemTextField: BluePlaceholder!
    @IBOutlet weak var descriptionTextField: BluePlaceholder!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var addBtn: ShadowButton!
    
    // Variables
    var group: Group?
    var currentUser = ""
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCurrentUser()
    }
    
    func loadCurrentUser() {
        let currentUserUid = Auth.auth().currentUser?.uid
        DataService.instance.printUsername(forUID: currentUserUid!) { (returnedUsername) in
            self.currentUser = returnedUsername
        }
    }
    
    // Actions
    @IBAction func addBtnWasPressed(_ sender: Any) {
        
        if itemTextField.text != "" && itemTextField.text != "ITEM" && itemTextField.text != nil {
            addBtn.isEnabled = true
            
            DataService.instance.createGroupItem(forGroupUid: (group?.key)!, andItem: itemTextField.text!, andDescription: descriptionTextField.text!, addedBy: currentUser, sendComplete: { (isComplete) in
                if isComplete {
                    self.addBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.addBtn.isEnabled = true
                }
            })
        } else {
            warningLbl.text = "Please fill in the form above."
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddGroupItemVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
