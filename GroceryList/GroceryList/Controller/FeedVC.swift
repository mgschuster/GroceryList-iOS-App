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
}

