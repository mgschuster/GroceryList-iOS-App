//
//  GroupGroceryListVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/18/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class GroupGroceryListVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupMembersLbl: UILabel!
    @IBOutlet weak var groupTitleLbl: UILabel!
    
    // Variables
    var group: Group?
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        reloadUsers()
    }
    
    func reloadUsers() {
        DataService.instance.getUsernamesFor(group: group!) { (returnedUsernames) in
            self.groupMembersLbl.text = returnedUsernames.joined(separator: ", ")
        }
    }
    
    // Actions
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addUserBtnWasPressed(_ sender: Any) {
        guard let addNewUserVC = storyboard?.instantiateViewController(withIdentifier: "AddNewUserVC") as? AddNewUserVC else { return }
        addNewUserVC.initData(forGroup: group!)
        present(addNewUserVC, animated: true, completion: nil)
    }
}
