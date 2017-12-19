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
    var groupListArray = [GroupList]()
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadGroupList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getUsernamesFor(group: group!) { (returnedUsernames) in
            self.groupMembersLbl.text = returnedUsernames.joined(separator: ", ")
        }
    }
    
    // Actions
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNewItemBtnWasPressed(_ sender: Any) {
        guard let addGroupItemVC = storyboard?.instantiateViewController(withIdentifier: "AddGroupItemVC") as? AddGroupItemVC else { return }
        addGroupItemVC.initData(forGroup: group!)
        present(addGroupItemVC, animated: true, completion: nil)
    }
    
    func reloadGroupList() {
        DataService.instance.getAllGroupLists(forUID: (group?.key)!) { (returnedGroupListArray) in
            self.groupListArray = returnedGroupListArray
            self.tableView.reloadData()
        }
    }
    
}

extension GroupGroceryListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupGroceryListCell") as? GroupGroceryListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let groupList = groupListArray[indexPath.row]
        cell.configureCell(item: groupList.item, description: groupList.description, addedBy: groupList.addedBy, markedBy: groupList.markedOffBy, isSelected: groupList.isSelected)
        return cell
    }
}
