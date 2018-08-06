//
//  ToDoViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/7/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let toDoDataSource = ToDoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = toDoDataSource
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        
        do {
        let allToDos = try AllItemStore.shared.fetchMainQueueToDos()
        
        self.toDoDataSource.toDos = allToDos
        } catch let err {
            print("Error fetching To Dos", err)
        }
            
            
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Complete"
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewToDoSegue" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let toDo = toDoDataSource.toDos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! ItemDetailViewController
                destinationVC.toDo = toDo
                destinationVC.itemType = .toDo
            }
        }
    }
    
    
}

