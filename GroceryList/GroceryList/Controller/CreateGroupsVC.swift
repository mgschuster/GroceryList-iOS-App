//
//  CreateGroupsVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/15/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class CreateGroupsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var checkmarkBtn: UIButton!
    @IBOutlet weak var groupTextField: BluePlaceholder!
    @IBOutlet weak var descriptionTextField: BluePlaceholder!
    @IBOutlet weak var usernameSearchTextField: BluePlaceholder!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // Variables
    var usernameArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        groupTextField.delegate = self
        descriptionTextField.delegate = self
        usernameSearchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkmarkBtn.isHidden = true
    }
    
    // Actions
    @IBAction func checkmarkBtnWasPressed(_ sender: Any) {
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        cell.configureCell(username: "TJ_Schoost11", isSelected: true)
        return cell
    }
}

extension CreateGroupsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
