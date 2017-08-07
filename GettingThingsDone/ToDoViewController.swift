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

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TopCloud")!.alpha(0.4).resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         self.tabBarController?.tabBar.isHidden = false
  
        let allToDos = try! self.allItemStore.fetchMainQueueToDos()
        
        OperationQueue.main.addOperation {
            self.toDoDataSource.toDos = allToDos
//            ** Set background table view to view with label
//            tableView.backgroundView
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

extension UIImage{
    
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}
