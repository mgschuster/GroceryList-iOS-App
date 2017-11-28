//
//  FeedVC.swift
//  GroceryList
//
//  Created by Admin on 11/21/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var myListTableView: UITableView!
    
    // Variables

    override func viewDidLoad() {
        super.viewDidLoad()
        myListTableView.delegate = self
        myListTableView.dataSource = self
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell") as? MyListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? MyListCell else { return }
        
        if selectedCell.checkmark.isHidden {
            let checkPopup = UIAlertController(title: "Check off?", message: "Check off this item from your list?", preferredStyle: .actionSheet)
            let checkAction = UIAlertAction(title: "CHECK OFF", style: .destructive, handler: { (checkTapped) in
                    selectedCell.checkmark.isHidden = false
            })
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            checkPopup.addAction(checkAction)
            checkPopup.addAction(cancelAction)
            present(checkPopup, animated: true, completion: nil)
        } else {
            let uncheckPopup = UIAlertController(title: "Uncheck?", message: "Uncheck this item from your list?", preferredStyle: .actionSheet)
            let uncheckAction = UIAlertAction(title: "UNCHECK", style: .destructive, handler: { (uncheckTapped) in
                    selectedCell.checkmark.isHidden = true
            })
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            uncheckPopup.addAction(uncheckAction)
            uncheckPopup.addAction(cancelAction)
            present(uncheckPopup, animated: true, completion: nil)
        }
        
//        let logoutPopup = UIAlertController(title: "Check off?", message: "Check off this item from your list?", preferredStyle: .actionSheet)
//        let logoutAction = UIAlertAction(title: "CHECK", style: .destructive) { (buttonTapped) in
//            do {
//                if selectedCell.checkmark.isHidden {
//                    selectedCell.checkmark.isHidden = false
//                } else {
//                    selectedCell.checkmark.isHidden = true
//                }
//            } catch {
//                print(error)
//            }
//        }
//        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
//        logoutPopup.addAction(logoutAction)
//        logoutPopup.addAction(cancelAction)
//        present(logoutPopup, animated: true, completion: nil)
    }
}

