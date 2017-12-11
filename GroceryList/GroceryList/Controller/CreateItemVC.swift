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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemField.delegate = self
        descriptionField.delegate = self
    }
    
    // Actions
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if itemField.text != nil && descriptionField.text != nil && itemField.text != "ITEM" && descriptionField.text != "DESCRIPTION (quantity, weight, etc...)" {
            addBtn.isEnabled = false
            
            let uid = Auth.auth().currentUser?.uid
            
            DataService.instance.uploadItem(withItem: itemField.text!, andDescription: descriptionField.text!, forUID: uid!, sendComplete: { (isComplete) in
                if isComplete {
                    self.addBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.addBtn.isEnabled = true
                    print("There was an error")
                }
            })
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
}
