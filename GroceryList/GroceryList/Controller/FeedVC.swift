//
//  FeedVC.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var myListTableView: UITableView!
    
    // Variables
    var groceryListArray = [GroceryList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        myListTableView.delegate = self
        myListTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadGroceryList()
    }
    
    func reloadGroceryList() {
        if Auth.auth().currentUser != nil {
            DataService.instance.getAllFeedMessages(forUID: (Auth.auth().currentUser?.uid)!) { (returnedGroceryListArray) in
                self.groceryListArray = returnedGroceryListArray
                self.myListTableView.reloadData()
            }
        } else {
            return
        }
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell") as? MyListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let groceryList = groceryListArray[indexPath.row]
        cell.configureCell(product: groceryList.item, withDescription: groceryList.description, isSelected: groceryList.isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = Auth.auth().currentUser?.uid
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? MyListCell else { return }
        
        if selectedCell.checkmark.isHidden {
                DataService.instance.checkOffItem(forUID: uid!, andItemName: selectedCell.productLbl.text!)
                self.reloadGroceryList()
        } else {
                DataService.instance.uncheckItem(forUID: uid!, andItemName: selectedCell.productLbl.text!)
                self.reloadGroceryList()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let uid = Auth.auth().currentUser?.uid
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            guard let selectedCell = tableView.cellForRow(at: indexPath) as? MyListCell else { return }
            DataService.instance.removeItem(forUID: uid!, andItem: selectedCell.productLbl.text!)
            self.reloadGroceryList()
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [deleteAction]
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
//            self.removeGoal(atIndexPath: indexPath)
//            self.fetchCoreDataObjects()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//
//        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
//            self.setProgress(atIndexPath: indexPath)
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//
//        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//        addAction.backgroundColor = #colorLiteral(red: 0.961445272, green: 0.650790751, blue: 0.1328578591, alpha: 1)
//
//        let goal = goals[indexPath.row]
//
//        if goal.goalProgress == goal.goalCompletionValue {
//            return [deleteAction]
//        } else {
//            return [deleteAction, addAction]
//        }
//    }
}

