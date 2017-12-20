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
    
    // Actions
    @IBAction func createGroupBtnWasPressed(_ sender: Any) {
    }
    
    
    func reloadGroupsList() {
        DataService.instance.getAllGroups { (returnedGroupsArray) in
            self.groupsArray = returnedGroupsArray
            self.groupsTableView.reloadData()
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
        
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDesc, listCount: group.listCount, listCheckCount: group.listCheckCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupGroceryListVC = storyboard?.instantiateViewController(withIdentifier: "GroupGroceryListVC") as? GroupGroceryListVC else { return }
        groupGroceryListVC.initData(forGroup: groupsArray[indexPath.row])
        lightHaptic()
        presentDetail(groupGroceryListVC)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let selectedGroup = groupsArray[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE GROUP") { (rowAction, indexPath) in
            self.heavyHaptic()
            
            let deleteGroupPopup = UIAlertController(title: "Delete Group?", message: "Deleting the group will remove all users and erase the group from memory. This cannot be undone.", preferredStyle: .actionSheet)
            
            let logoutAction = UIAlertAction(title: "DELETE", style: .destructive) { (buttonTapped) in
                self.warningHaptic()
                DataService.instance.removeGroup(forGroupUID: selectedGroup.key)
                self.reloadGroupsList()
            }
            
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            deleteGroupPopup.addAction(logoutAction)
            deleteGroupPopup.addAction(cancelAction)
            self.present(deleteGroupPopup, animated: true, completion: nil)
            
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [deleteAction]
    }
}
