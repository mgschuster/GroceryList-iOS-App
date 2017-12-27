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
    var groceryItems = [String]()
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTextField.delegate = self
        descriptionTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        itemTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCurrentUser()
        warningLbl.text = ""
        reloadGroceryItems()
    }
    
    @objc func textFieldDidChange() {
        warningLbl.text = ""
    }
    
    func loadCurrentUser() {
        let currentUserUid = Auth.auth().currentUser?.uid
        DataService.instance.printUsername(forUID: currentUserUid!) { (returnedUsername) in
            self.currentUser = returnedUsername
        }
    }
    
    func reloadGroceryItems() {
        DataService.instance.groupGroceryListItems(groupUID: (group?.key)!) { (returnedGroceryItems) in
            self.groceryItems = returnedGroceryItems
        }
    }
    
    func itemAvailable(checkedItem: String) -> Bool {
        var available: Bool?
        
        if groceryItems.count >= 1 {
            for item in groceryItems {
                if checkedItem == item {
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
    @IBAction func addBtnWasPressed(_ sender: Any) {
        
        if itemTextField.text != "" && itemTextField.text != "ITEM" && itemTextField.text != nil {
            addBtn.isEnabled = true
            self.reloadGroceryItems()
            
            let available = itemAvailable(checkedItem: itemTextField.text!)
            
            if available {
                DataService.instance.createGroupItem(forGroupUid: (group?.key)!, andItem: itemTextField.text!, andDescription: descriptionTextField.text!, addedBy: currentUser, sendComplete: { (isComplete) in
                    if isComplete {
                        DataService.instance.increaseListCount(forGroupUid: (self.group?.key)!)
                        self.successHaptic()
                        self.addBtn.isEnabled = true
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.addBtn.isEnabled = true
                    }
                })
            } else {
                errorHaptic()
                warningLbl.text = "That item is already on the list."
            }
            
        } else {
            errorHaptic()
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
