//
//  NextActionDataStore.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/14/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class NextActionDataSource: NSObject, UITableViewDataSource {
    
    var sortedNextActions = [[NextAction]]()
    var unsortedNextActions = [NextAction]()
    var contexts = [Context]()
    let allItemStore = AllItemStore()
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
        if section < contexts.count && section >= 0 {
            return self.contexts[section].name
        }  else if section == contexts.count {
            return "Unsorted"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == contexts.count {
            return unsortedNextActions.count
        } else {
            if !sortedNextActions.isEmpty {
        return (self.sortedNextActions[section].count)
            } else {
                return 0
            }
    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "NextActionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if indexPath.section < contexts.count && indexPath.section >= 0 {
            let sortedNextActionsForContext = sortedNextActions[indexPath.section]
            let sortedNextAction = sortedNextActionsForContext[indexPath.row]
            cell.textLabel?.text = "\(indexPath.row + 1): \(sortedNextAction.name!)"
        }
        
       else if indexPath.section == contexts.count {
        let unsortedNextAction = unsortedNextActions[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1): \(unsortedNextAction.name!)"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
   
        return contexts.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = unsortedNextActions[indexPath.row].id
            unsortedNextActions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try allItemStore.deleteNextAction(id: id!)
            } catch {
                print("Error deleting To Do: \(error)")
            }
        }
    }
    
}
