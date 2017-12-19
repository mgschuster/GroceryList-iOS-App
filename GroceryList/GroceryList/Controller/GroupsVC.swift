//
//  SecondViewController.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class GroupsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var groupsTableView: UITableView!
    
    // Variables
    var groupsArray = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadGroupsList()
    }
    
    func reloadGroupsList() {
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.groupsTableView.reloadData()
            }
        }
    }
}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDesc)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupGroceryListVC = storyboard?.instantiateViewController(withIdentifier: "GroupGroceryListVC") as? GroupGroceryListVC else { return }
        groupGroceryListVC.initData(forGroup: groupsArray[indexPath.row])
        present(groupGroceryListVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let selectedGroup = groupsArray[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE GROUP") { (rowAction, indexPath) in
            DataService.instance.removeGroup(forGroupUID: selectedGroup.key)
            self.reloadGroupsList()
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [deleteAction]
    }
}
