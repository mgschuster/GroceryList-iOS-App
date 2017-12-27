//
//  GroupGroceryListVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/18/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class GroupGroceryListVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupMembersLbl: UILabel!
    @IBOutlet weak var groupTitleLbl: UILabel!
    
    // Variables
    var group: Group?
    var groupListArray = [GroupList]()
    var currentUser = ""
    var groupMembersArray = [String]()
    
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
        getCurrentUsername()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getUsernamesFor(group: group!) { (returnedUsernames) in
            self.groupMembersLbl.text = returnedUsernames.joined(separator: ", ")
            self.groupMembersArray = returnedUsernames
        }
    }
    
    // Actions
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
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
    
    func getCurrentUsername() {
        let userUID = (Auth.auth().currentUser?.uid)!
        DataService.instance.printUsername(forUID: userUID) { (returnedUsername) in
            self.currentUser = returnedUsername
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let uid = (group?.key)!
        var rowActionsArray = [UITableViewRowAction]()
        
        let currentCell = tableView.cellForRow(at: indexPath) as? GroupGroceryListCell
        
        let addedByStart = currentCell!.addedByLbl.text!.index(currentCell!.addedByLbl.text!.startIndex, offsetBy: 10)
        let addedByEnd = currentCell!.addedByLbl.text!.index(before: currentCell!.addedByLbl.text!.endIndex)
        let markedByStart = currentCell!.markedByLbl.text!.index(currentCell!.markedByLbl.text!.startIndex, offsetBy: 16)
        let markedByEnd = currentCell!.markedByLbl.text!.index(before: currentCell!.markedByLbl.text!.endIndex)
        
        let addedByUser = currentCell!.addedByLbl.text![addedByStart...addedByEnd]
        let markedByUser = currentCell!.markedByLbl.text![markedByStart...markedByEnd]

        let addedBy = String(describing: addedByUser)
        let markedBy = String(describing: markedByUser)
        
        print(addedBy)
        print(markedBy)
        print(groupMembersArray)
        
        if !(groupMembersArray.contains(markedBy)) && currentCell?.markedByLbl.text! != "Checked off by: - -" {
            if !(currentCell?.markedByLbl.text?.contains(currentUser))! {
                let uncheckAction = UITableViewRowAction(style: .default, title: "UNCHECK", handler: { (rowAction, indexPath) in
                    self.successHaptic()
                    guard let selectedCell = tableView.cellForRow(at: indexPath) as? GroupGroceryListCell else { return }
                    let groupUID = (self.group?.key)!
                    DataService.instance.uncheckUser(forGroupUid: groupUID, andItem: selectedCell.itemLbl.text!)
                    self.reloadGroupList()
                })
                uncheckAction.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.5607843137, blue: 1, alpha: 1)
                rowActionsArray.append(uncheckAction)
            }
        }
        
        if !(groupMembersArray.contains(addedBy)) {
            if !(currentCell?.addedByLbl.text?.contains(currentUser))! {
                let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
                    self.warningHaptic()
                    guard let selectedCell = tableView.cellForRow(at: indexPath) as? GroupGroceryListCell else { return }
                    
                    if selectedCell.checkmark.isHidden == false {
                        DataService.instance.decreaseListCheckCount(forGroupUid: uid)
                    }
                    
                    DataService.instance.removeGroupItem(forUID: uid, andItem: selectedCell.itemLbl.text!)
                    self.reloadGroupList()
                }
                deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                rowActionsArray.append(deleteAction)
            }
        }
        
        if (currentCell?.addedByLbl.text?.contains(currentUser))! {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
                self.warningHaptic()
                guard let selectedCell = tableView.cellForRow(at: indexPath) as? GroupGroceryListCell else { return }
                
                if selectedCell.checkmark.isHidden == false {
                    DataService.instance.decreaseListCheckCount(forGroupUid: uid)
                }
                
                DataService.instance.removeGroupItem(forUID: uid, andItem: selectedCell.itemLbl.text!)
                self.reloadGroupList()
            }
            deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            rowActionsArray.append(deleteAction)
        }
        
        if (currentCell?.markedByLbl.text?.contains(currentUser))! {
            let uncheckAction = UITableViewRowAction(style: .default, title: "UNCHECK", handler: { (rowAction, indexPath) in
                self.successHaptic()
                guard let selectedCell = tableView.cellForRow(at: indexPath) as? GroupGroceryListCell else { return }
                let groupUID = (self.group?.key)!
                DataService.instance.uncheckUser(forGroupUid: groupUID, andItem: selectedCell.itemLbl.text!)
                self.reloadGroupList()
            })
            uncheckAction.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.5607843137, blue: 1, alpha: 1)
            rowActionsArray.append(uncheckAction)
        }
        
        if (currentCell?.checkmark.isHidden)! {
            let markOffAction = UITableViewRowAction(style: .default, title: "CHECK OFF") { (rowAction, indexPath) in
                self.successHaptic()
                guard let selectedCell = tableView.cellForRow(at: indexPath) as? GroupGroceryListCell else { return }
                let username = self.currentUser
                let groupUID = (self.group?.key)!
                DataService.instance.markeOffUser(forGroupUid: groupUID, andItem: selectedCell.itemLbl.text!, withUser: username)
                self.reloadGroupList()
            }
            markOffAction.backgroundColor = #colorLiteral(red: 0.2685465515, green: 0.6267361641, blue: 0.2813494205, alpha: 1)
            rowActionsArray.append(markOffAction)
        }
        return rowActionsArray
    }
}
