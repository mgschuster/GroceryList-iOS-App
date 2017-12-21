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
    }
    
    @objc func textFieldDidChange() {
        warningLbl.text = ""
    }
    
    // Actions
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if itemField.text != "" && itemField.text != "ITEM" && itemField.text != nil {
            addBtn.isEnabled = true

            let uid = Auth.auth().currentUser?.uid

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
