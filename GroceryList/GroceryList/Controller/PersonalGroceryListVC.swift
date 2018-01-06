//
//  PersonalGroceryListVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 1/5/18.
//  Copyright © 2018 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class PersonalGroceryListVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listTitleLbl: UILabel!
    
    // Variables
    var list: PersonalList?
    var listItemsArray = [PersonalGroceryList]()
    
    func initData(forList list: PersonalList) {
        self.list = list
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadPersonalList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTitleLbl.text = list?.listTitle
    }
    
    // Actions
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func createNewItemBtnWasPressed(_ sender: Any) {
        guard let addPersonalItemVC = storyboard?.instantiateViewController(withIdentifier: "AddPersonalItemVC") as? AddPersonalItemVC else { return }
        addPersonalItemVC.initData(forList: list!)
        present(addPersonalItemVC, animated: true, completion: nil)
    }
    
    func reloadPersonalList() {
        if Auth.auth().currentUser != nil {
            DataService.instance.getAllPersonalListItems(forUID: (Auth.auth().currentUser?.uid)!, andListName: (list?.listTitle)!, handler: { (returnedItems) in
                self.listItemsArray = returnedItems
                self.tableView.reloadData()
            })
        } else {
            return
        }
    }
}

extension PersonalGroceryListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalListCell") as? PersonalGroceryListCell else { return UITableViewCell() }
        let personalItem = listItemsArray[indexPath.row]
        cell.configureCell(item: personalItem.item, withDescription: personalItem.description, isSelected: personalItem.isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        successHaptic()
        let uid = Auth.auth().currentUser?.uid
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? PersonalGroceryListCell else { return }
        
        if selectedCell.checkmark.isHidden {
            DataService.instance.checkOffPersonalItem(forUID: uid!, andList: (list?.listTitle)!, andItem: selectedCell.itemLbl.text!)
            DataService.instance.increasePersonalListCheckCount(uid: uid!, listName: (list?.listTitle)!)
            self.reloadPersonalList()
        } else {
            DataService.instance.uncheckPersonalItem(forUID: uid!, andList: (list?.listTitle)!, andItem: selectedCell.itemLbl.text!)
            DataService.instance.decreasePersonalListCheckCount(uid: uid!, listName: (list?.listTitle)!)
            self.reloadPersonalList()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let uid = Auth.auth().currentUser?.uid
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.warningHaptic()
            guard let selectedCell = tableView.cellForRow(at: indexPath) as? PersonalGroceryListCell else { return }
            DataService.instance.removePersonalItem(forUID: uid!, andList: (self.list?.listTitle)!, andItem: selectedCell.itemLbl.text!)
            
            if selectedCell.checkmark.isHidden == false {
                DataService.instance.decreasePersonalListCheckCount(uid: uid!, listName: (self.list?.listTitle)!)
            }
            
            self.reloadPersonalList()
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.2352941176, blue: 0.1019607843, alpha: 1)
        return [deleteAction]
    }
}

