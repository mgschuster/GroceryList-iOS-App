//
//  AddNewUserVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/18/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class AddNewUserVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameSearchField: BluePlaceholder!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var newUsers: UILabel!
    @IBOutlet weak var checkmarkBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var usernameArray = [String]()
    var chosenUserArray = [String]()
    var currentUsers = [String]()
    
    var group: Group?
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        usernameSearchField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkmarkBtn.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameSearchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        DataService.instance.getUsernamesFor(group: group!) { (returnedCurrentUsersArray) in
            self.currentUsers = returnedCurrentUsersArray
        }
    }
    
    @objc func textFieldDidChange() {
        if usernameSearchField.text == "" {
            tableView.reloadData()
        } else {
            DataService.instance.getNewUsernames(forSearchQuery: self.usernameSearchField.text!, andUsernames: self.currentUsers, handler: { (returnedUsernameArray) in
                self.usernameArray = returnedUsernameArray
                self.tableView.reloadData()
            })
        }
    }
    
    // Actions
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkmarkBtnWasPressed(_ sender: Any) {
        DataService.instance.getIds(forUsernames: chosenUserArray) { (usernameIdsArray) in
            let usernameIds = usernameIdsArray
            DataService.instance.getIds(forUsernames: self.currentUsers, handler: { (currentUserIdsArray) in
                let currentUsersIds = currentUserIdsArray
                DataService.instance.addUsersToGroup(forGroupUID: (self.group?.key)!, andNewUsers: usernameIds, andCurrentUsers: currentUsersIds, handler: { (usersAdded) in
                    if usersAdded {
                        guard let GroupsVC = self.storyboard?.instantiateViewController(withIdentifier: "GroupsVC") as? GroupsVC else { return }
                        self.present(GroupsVC, animated: true, completion: nil)
                    } else {
                        print("There was a problem")
                    }
                })
            })
        }
    }
}

extension AddNewUserVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newUserCell") as? NewUserCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        if chosenUserArray.contains(usernameArray[indexPath.row]) {
            cell.configureCell(username: usernameArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(username: usernameArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewUserCell else { return }
        if !chosenUserArray.contains(cell.usernameLbl.text!) {
            chosenUserArray.append(cell.usernameLbl.text!)
            newUsers.text = chosenUserArray.joined(separator: ", ")
            checkmarkBtn.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.usernameLbl.text! })
            if chosenUserArray.count >= 1 {
                newUsers.text = chosenUserArray.joined(separator: ", ")
            } else {
                newUsers.text = "Add new users to your group"
                checkmarkBtn.isHidden = true
            }
        }
    }
}

extension AddNewUserVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
