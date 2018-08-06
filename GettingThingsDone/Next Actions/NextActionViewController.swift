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
    
    let nextActionDataSource = NextActionDataSource()
    var contexts = [Context]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = nextActionDataSource
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        
        // Fetch contexts and context-unsorted next actions
        do {
        let allContexts = try AllItemStore.shared.fetchMainQueueContext()
        
        let unsortedNextActions = try AllItemStore.shared.fetchUnsortedByContextNextActions()
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
            self.contexts = contextArray
            self.nextActionDataSource.sortedNextActions = scoredNextActionArrays
            self.tableView.reloadData()
            
        }
            
        } catch let err {
            print("Error fetching objects", err)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Complete"
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = IndentedLabel()
        
        if section < contexts.count && section >= 0 {
            label.text = contexts[section].name
        }  else if section == contexts.count {
            label.text = "Unsorted"
        }
                
        label.backgroundColor = .themeOrange
        label.textColor = .themePurple
        return label
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            let destinationVC = segue.destination as! AddItemViewController
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
                
                destinationVC.itemType = .nextAction
            }
        }
    }
    
}
