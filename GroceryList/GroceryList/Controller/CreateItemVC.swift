//
//  CreateItemVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 11/28/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class CreateItemVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var itemField: BluePlaceholder!
    @IBOutlet weak var descriptionField: BluePlaceholder!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var warningLbl: UILabel!
    
    // Variables
    var groceryItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemField.delegate = self
        descriptionField.delegate = self
        self.hideKeyboardWhenTappedAround()
        itemField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        warningLbl.text = ""
        reloadGroceryItems()
    }
    
    @objc func textFieldDidChange() {
        warningLbl.text = ""
    }
    
    func reloadGroceryItems() {
        DataService.instance.userListItems(uid: (Auth.auth().currentUser?.uid)!) { (returnedGroceryList) in
            self.groceryItems = returnedGroceryList
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
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if itemField.text != "" && itemField.text != "ITEM" && itemField.text != nil {
            
            self.reloadGroceryItems()
            let itemAvailable = self.itemAvailable(checkedItem: itemField.text!)
            addBtn.isEnabled = true
            let uid = Auth.auth().currentUser?.uid
            
            if itemAvailable {
                DataService.instance.uploadItem(withItem: itemField.text!, andDescription: descriptionField.text!, forUID: uid!, sendComplete: { (isComplete) in
                    if isComplete {
                        self.successHaptic()
                        self.addBtn.isEnabled = true
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.addBtn.isEnabled = true
                    }
                })
            } else {
                errorHaptic()
                warningLbl.text = "You already have that item on your list."
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

extension CreateItemVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
