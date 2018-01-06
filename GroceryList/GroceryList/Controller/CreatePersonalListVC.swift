//
//  CreatePersonalListVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 1/5/18.
//  Copyright © 2018 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class CreatePersonalListVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var listNameTextField: BluePlaceholder!
    @IBOutlet weak var descriptionTextField: BluePlaceholder!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var createListBtn: ShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNameTextField.delegate = self
        descriptionTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        listNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        warningLbl.text = ""
        reloadLists()
        
    }
    
    @objc func textFieldDidChange() {
        warningLbl.text = ""
    }
    
    func reloadLists() {
        
    }
    
    // Actions
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createListBtnWasPressed(_ sender: Any) {
        if listNameTextField.text != "" && listNameTextField.text != "LIST NAME" {
            self.reloadLists()
            createListBtn.isEnabled = true
            let uid = Auth.auth().currentUser?.uid
            
            DataService.instance.uploadPersonalList(withListName: listNameTextField.text!, andDescription: descriptionTextField.text!, forUID: uid!, sendComplete: { (isComplete) in
                if isComplete {
                    self.successHaptic()
                    self.createListBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.createListBtn.isEnabled = true
                }
            })
        } else {
            errorHaptic()
            warningLbl.text = "Please fill in the form above."
        }
    }
}

extension CreatePersonalListVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
