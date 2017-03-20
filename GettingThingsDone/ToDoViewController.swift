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
    
    var toDoStore: ToDoStore!
    var nextActionStore: NextActionStore!
    let toDoDataSource = ToDoDataSource()
    var projectStore: ProjectStore!
    var topicStore: TopicStore!
    var contextStore: ContextStore!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = toDoDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         self.tabBarController?.tabBar.isHidden = false
  
        let allToDos = try! self.toDoStore.fetchMainQueueToDos()
        
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
            destinationVC.toDoStore = toDoStore
            destinationVC.nextActionStore = nextActionStore
            destinationVC.projectStore = projectStore
            destinationVC.topicStore = topicStore
            destinationVC.contextStore = contextStore
        }
        else if segue.identifier == "ViewToDoSegue" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let toDo = toDoDataSource.toDos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! ItemDetailViewController
                destinationVC.toDo = toDo
                destinationVC.toDoStore = toDoStore
                destinationVC.nextActionStore = nextActionStore
                destinationVC.projectStore = projectStore
                destinationVC.topicStore = topicStore
                destinationVC.contextStore = contextStore
                destinationVC.itemType = "To Do"
            }
        }
    }
    

}
