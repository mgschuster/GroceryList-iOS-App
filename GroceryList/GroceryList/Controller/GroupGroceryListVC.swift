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
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
