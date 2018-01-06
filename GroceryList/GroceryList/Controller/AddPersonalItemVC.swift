//
//  AddPersonalItemVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 1/5/18.
//  Copyright © 2018 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class AddPersonalItemVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var itemTextField: BluePlaceholder!
    @IBOutlet weak var descriptionTextField: BluePlaceholder!
    @IBOutlet weak var addBtn: ShadowButton!
    @IBOutlet weak var warningLbl: UILabel!
    
    // Variables
    var list: PersonalList?
    var groceryItems = [String]()
    
    func initData(forList list: PersonalList) {
        self.list = list
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
        warningLbl.text = ""
        reloadPersonalListItems()
    }
    
    @objc func textFieldDidChange() {
        warningLbl.text = ""
    }
    
    func reloadPersonalListItems() {
        let currentUID = Auth.auth().currentUser?.uid
        DataService.instance.listItems(uid: currentUID!, listName: (list?.listTitle)!) { (returnedItems) in
            self.groceryItems = returnedItems
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
    @IBAction func addItemBtnWasPressed(_ sender: Any) {
        if itemTextField.text != "" && itemTextField.text != "ITEM" && itemTextField.text != nil {
            addBtn.isEnabled = true
            self.reloadPersonalListItems()
            let uid = Auth.auth().currentUser?.uid
            
            let available = itemAvailable(checkedItem: itemTextField.text!)
            
            if available {
                DataService.instance.createPersonalItem(forUID: uid!, andListName: (list?.listTitle)!, andItem: itemTextField.text!, andDescription: descriptionTextField.text!, sendComplete: { (isComplete) in
                    if isComplete {
                        DataService.instance.increasePersonalListCount(uid: uid!, listName: (self.list?.listTitle)!)
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

extension AddPersonalItemVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
