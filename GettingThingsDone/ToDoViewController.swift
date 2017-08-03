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
    var allItemStore: AllItemStore!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = toDoDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         self.tabBarController?.tabBar.isHidden = false
  
        let allToDos = try! self.allItemStore.fetchMainQueueToDos()
        
        OperationQueue.main.addOperation {
            self.toDoDataSource.toDos = allToDos
            self.tableView.reloadData()
        }
        
    }


    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Complete"
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.allItemStore = allItemStore
        }
        else if segue.identifier == "ViewToDoSegue" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let toDo = toDoDataSource.toDos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! ItemDetailViewController
                destinationVC.toDo = toDo
                destinationVC.allItemStore = allItemStore
                destinationVC.itemType = .toDo
            }
        }
    }
    

}
