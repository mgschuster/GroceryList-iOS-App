//
//  MyListsVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 1/5/18.
//  Copyright © 2018 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class MyListsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var personalListsTableView: UITableView!

    // Variables
    var listsArray = [PersonalList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        personalListsTableView.delegate = self
        personalListsTableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadPersonalList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPersonalList()
    }

    func reloadPersonalList() {
        let currentUID = Auth.auth().currentUser?.uid
        DataService.instance.getAllUserLists(forUID: currentUID!) { (returnedLists) in
            self.listsArray = returnedLists
            self.personalListsTableView.reloadData()
        }
    }

}

extension MyListsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = personalListsTableView.dequeueReusableCell(withIdentifier: "listsCell", for: indexPath) as? PersonalListsCell else { return UITableViewCell() }

        let list = listsArray[indexPath.row]
        cell.configureCell(title: list.listTitle, description: list.listDescription, listCount: list.listCount, listCheckCount: list.listCheckCount)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let personalGroceryListVC = storyboard?.instantiateViewController(withIdentifier: "PersonalGroceryListVC") as? PersonalGroceryListVC else { return }
        personalGroceryListVC.initData(forList: listsArray[indexPath.row])
        lightHaptic()
        presentDetail(personalGroceryListVC)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let selectedList = listsArray[indexPath.row]
        let uid = Auth.auth().currentUser?.uid

        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE LIST") { (rowAction, indexPath) in
            self.heavyHaptic()
            
            let deleteGroupPopup = UIAlertController(title: "Delete List?", message: "Deleting this list will erase it from memory. This cannot be undone.", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "DELETE", style: .destructive) { (buttonTapped) in
                self.warningHaptic()
                DataService.instance.removeUserList(forUID: uid!, andList: selectedList.listTitle)
                self.reloadPersonalList()
            }
            
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            deleteGroupPopup.addAction(deleteAction)
            deleteGroupPopup.addAction(cancelAction)
            self.present(deleteGroupPopup, animated: true, completion: nil)
            
        }

        deleteAction.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.2352941176, blue: 0.1019607843, alpha: 1)
        return [deleteAction]
    }

}

