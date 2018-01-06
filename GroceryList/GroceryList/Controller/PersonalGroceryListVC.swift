//
//  PersonalGroceryListVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 1/5/18.
//  Copyright © 2018 TJSchoost. All rights reserved.
//

import UIKit

class PersonalGroceryListVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listTitleLbl: UILabel!
    
    // Variables
    var list: PersonalList?
    
    func initData(forList list: PersonalList) {
        self.list = list
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func reloadPersonalList() {
        
    }
}

