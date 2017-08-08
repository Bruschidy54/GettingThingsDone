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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TopCloud")!.alpha(0.4).resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        
        
        tableView.delegate = self
        tableView.dataSource = nextActionDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        
        // Fetch contexts and context-unsorted next actions
        
        let allContexts = try! self.allItemStore.fetchMainQueueContext()
        
        let unsortedNextActions = try! self.allItemStore.fetchUnsortedByContextNextActions()
        let scoredUnsortedNextActions = unsortedNextActions.sorted{
            $0.relevanceScore > $1.relevanceScore
        }
        
        
        var contextArray = [Context]()
        var scoredNextActionArrays = [[NextAction]]()
        
        // Rank sorted next actions
        for context in allContexts {
            if let nextActionSet = context.nextActions {
                let nextActionArray = Array(nextActionSet) as! [NextAction]
                
                
                if !nextActionArray.isEmpty{
                    let scoredNextActionArray = nextActionArray.sorted{
                        $0.relevanceScore > $1.relevanceScore
                    }
                    contextArray.append(context)
                    scoredNextActionArrays.append(scoredNextActionArray)
                }
            }
        }
        OperationQueue.main.addOperation {
            self.nextActionDataSource.unsortedNextActions = scoredUnsortedNextActions
            self.nextActionDataSource.contexts = contextArray
            self.nextActionDataSource.sortedNextActions = scoredNextActionArrays
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
        else if segue.identifier == "ViewNextActionSegue" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Get proper nextAction using selectedIndexPath and send it to ItemDetailVC
                
                let destinationVC = segue.destination as! ItemDetailViewController
                
                if selectedIndexPath.section >= 0 && selectedIndexPath.section < self.nextActionDataSource.contexts.count {
                    let nextActionArray = self.nextActionDataSource.sortedNextActions[selectedIndexPath.section]
                    let nextAction = nextActionArray[selectedIndexPath.row]
                    destinationVC.nextAction = nextAction
                    
                } else if selectedIndexPath.section == self.nextActionDataSource.contexts.count {
                    let nextAction = self.nextActionDataSource.unsortedNextActions[selectedIndexPath.row]
                    destinationVC.nextAction = nextAction
                }
                
                destinationVC.allItemStore = allItemStore
                destinationVC.itemType = .nextAction
            }
        }
    }
    
}
