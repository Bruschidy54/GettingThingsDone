//
//  NextActionViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/14/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class NextActionViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    var allItemStore: AllItemStore!
    let nextActionDataSource = NextActionDataSource()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = nextActionDataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        
        let allNextActions = try! self.allItemStore.fetchMainQueueNextActions()
        
        OperationQueue.main.addOperation {
            self.nextActionDataSource.nextActions = allNextActions
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
    else if segue.identifier == "ViewNextActionSegue" {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let nextAction = nextActionDataSource.nextActions[selectedIndexPath.row]
            
            let destinationVC = segue.destination as! ItemDetailViewController
            destinationVC.nextAction = nextAction
            destinationVC.allItemStore = allItemStore
            destinationVC.itemType = "Next Action"
    }
    }
    }
}
