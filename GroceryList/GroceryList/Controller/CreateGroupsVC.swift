//
//  CreateGroupsVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/15/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var checkmarkBtn: UIButton!
    @IBOutlet weak var groupTextField: BluePlaceholder!
    @IBOutlet weak var descriptionTextField: BluePlaceholder!
    @IBOutlet weak var usernameSearchTextField: BluePlaceholder!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningLbl: UILabel!
    
    
    // Variables
    var usernameArray = [String]()
    var chosenUserArray = [String]()
    var currentUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        groupTextField.delegate = self
        groupTextField.addTarget(self, action: #selector(groupNameFieldDidChange), for: .editingChanged)
        descriptionTextField.delegate = self
        usernameSearchTextField.delegate = self
        usernameSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
        
        DataService.instance.printUsername(forUID: (Auth.auth().currentUser?.uid)!) { (returnedUsername) in
            self.chosenUserArray.append(returnedUsername)
            self.currentUser = returnedUsername
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkmarkBtn.isHidden = true
        warningLbl.text = ""
    }
    
    @objc func textFieldDidChange() {
        if usernameSearchTextField.text == "" {
            usernameArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getUsernames(forSearchQuery: usernameSearchTextField.text!, handler: { (returnedUsernameArray) in
                self.usernameArray = returnedUsernameArray
                self.tableView.reloadData()
            })
        }
    }
    
    @objc func groupNameFieldDidChange() {
        warningLbl.text = ""
    }
    
    // Actions
    @IBAction func checkmarkBtnWasPressed(_ sender: Any) {
        if groupTextField.text != "" && descriptionTextField.text != "DESCRIPTION (optional)" {
            
            DataService.instance.getIds(forUsernames: chosenUserArray, handler: { (usernameIdsArray) in
                var usernameDict = [String: String]()
                var usernameIds = usernameIdsArray
                let currentUserId = Auth.auth().currentUser?.uid
                
                usernameIds.append(currentUserId!)
                
                for i in 0..<self.chosenUserArray.count {
                    usernameDict[self.chosenUserArray[i]] = usernameIds[i]
                }
                
                DataService.instance.createGroup(withTitle: self.groupTextField.text!, andDescription: self.descriptionTextField.text!, andMaster: self.currentUser, forUsernames: usernameDict, handler: { (groupCreated) in
                    if groupCreated {
                        self.successHaptic()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("Group could not be created. Please try again.")
                    }
                })
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

extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        if chosenUserArray.contains(usernameArray[indexPath.row]) {
            cell.configureCell(username: usernameArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(username: usernameArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lightHaptic()
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !chosenUserArray.contains(cell.usernameLbl.text!) {
            chosenUserArray.append(cell.usernameLbl.text!)
            groupMemberLbl.text = chosenUserArray.joined(separator: ", ")
            checkmarkBtn.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.usernameLbl.text! })
            if chosenUserArray.count > 1 {
                groupMemberLbl.text = chosenUserArray.joined(separator: ", ")
            } else {
                groupMemberLbl.text = "Add people to your group"
                checkmarkBtn.isHidden = true
            }
        }
    }
}

extension CreateGroupsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
