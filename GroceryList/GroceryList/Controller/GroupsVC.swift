//
//  SecondViewController.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

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
}
