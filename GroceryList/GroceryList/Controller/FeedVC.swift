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
    @IBOutlet weak var trashBtn: UIButton!
    
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
    
    // Actions
    @IBAction func deleteBtnWasPressed(_ sender: Any) {
        
        let logoutPopup = UIAlertController(title: "Delete all items?", message: "Are you sure you want to delete all items?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "DELETE ALL ITEMS", style: .destructive) { (buttonTapped) in
            self.warningHaptic()
            let userUID = Auth.auth().currentUser?.uid
            DataService.instance.removeAllItems(forUID: userUID!)
            self.reloadGroceryList()
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) { (buttonTapped) in
        }
        
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(cancelAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    @IBAction func addItemBtnWasPressed(_ sender: Any) {
    }
    
    func reloadGroceryList() {
        if Auth.auth().currentUser != nil {
            DataService.instance.getAllFeedMessages(forUID: (Auth.auth().currentUser?.uid)!) { (returnedGroceryListArray) in
                self.groceryListArray = returnedGroceryListArray
                self.myListTableView.reloadData()
                if !self.groceryListArray.isEmpty {
                    self.trashBtn.isHidden = false
                } else {
                    self.trashBtn.isHidden = true
                }
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
        let groceryList = groceryListArray[indexPath.row]
        cell.configureCell(product: groceryList.item, withDescription: groceryList.description, isSelected: groceryList.isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        successHaptic()
        let uid = Auth.auth().currentUser?.uid
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? MyListCell else { return }
        
        if selectedCell.checkmark.isHidden {
                DataService.instance.checkOffItem(forUID: uid!, andItemName: selectedCell.productLbl.text!)
                self.reloadGroceryList()
        } else {
                DataService.instance.uncheckItem(forUID: uid!, andItemName: selectedCell.productLbl.text!)
                self.reloadGroceryList()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let uid = Auth.auth().currentUser?.uid
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.warningHaptic()
            guard let selectedCell = tableView.cellForRow(at: indexPath) as? MyListCell else { return }
            DataService.instance.removeItem(forUID: uid!, andItem: selectedCell.productLbl.text!)
            self.reloadGroceryList()
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [deleteAction]
    }
}

