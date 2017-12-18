//
//  AddGroupItemVC.swift
//  GroceryList
//
//  Created by Mitchell Schuster on 12/18/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class AddGroupItemVC: UIViewController {
    
    // Outlet
    @IBOutlet weak var itemTextField: BluePlaceholder!
    @IBOutlet weak var descriptionTextField: BluePlaceholder!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var addBtn: ShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // Actions
    @IBAction func addBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
