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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
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
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.font = UIFont(name: "GillSans", size: 17)
        cell.textLabel?.textColor = UIColor.darkGray
        cell.detailTextLabel?.font = UIFont(name: "GillSans", size: 10)
        
        if indexPath.section < contexts.count && indexPath.section >= 0 {
            if let sortedNextActionsForContext: [NextAction] = sortedNextActions[indexPath.section] {
                let sortedNextAction = sortedNextActionsForContext[indexPath.row]
                cell.textLabel?.text = "\(indexPath.row + 1): \(sortedNextAction.name!)"
                let dueDate = dateFormatter.string(from: sortedNextAction.duedate as! Date)
                cell.detailTextLabel?.text = "     Due \(dueDate)"
                if (sortedNextAction.duedate! as Date) < Date() {
                    cell.detailTextLabel?.textColor = UIColor.red
                } else {
                    cell.detailTextLabel?.textColor = UIColor.darkGray
                }
            }
        }
            
        else if indexPath.section == contexts.count {
                if let unsortedNextAction: NextAction? = unsortedNextActions[indexPath.row] {
                    cell.textLabel?.text = "\(indexPath.row + 1): \(unsortedNextAction!.name!)"
                    let dueDate = dateFormatter.string(from: unsortedNextAction?.duedate as! Date)
                    cell.detailTextLabel?.text = "     Due \(dueDate)"
                    if (unsortedNextAction?.duedate! as! Date) < Date() {
                        cell.detailTextLabel?.textColor = UIColor.red
                    } else {
                        cell.detailTextLabel?.textColor = UIColor.darkGray
                    }
                }
            }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if !unsortedNextActions.isEmpty || !sortedNextActions.isEmpty {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            if !unsortedNextActions.isEmpty{
            numOfSections = sortedNextActions.count + 1
            } else {
                numOfSections = sortedNextActions.count
            }
        } else {
            let noNextActionLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noNextActionLabel.text = "No Next Actions"
            noNextActionLabel.textColor = UIColor.darkGray
            noNextActionLabel.textAlignment = .center
            tableView.backgroundView = noNextActionLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section < contexts.count && indexPath.section >= 0 {
                let sortedNextActionsForContext = sortedNextActions[indexPath.section]
                if let sortedNextAction: NextAction? = sortedNextActionsForContext[indexPath.row] {
                    let id = sortedNextAction?.id
                    sortedNextActions[indexPath.section].remove(at: indexPath.row)
                
                    if let contexts = sortedNextAction?.contexts {
                        sortedNextAction?.removeFromContexts(contexts)
                    }
                    if let projects = sortedNextAction?.projects {
                        sortedNextAction?.removeFromProjects(projects)
                    }
                    // Delete from core data
                    do {
                        try allItemStore.deleteNextAction(id: id!)
                    } catch {
                        print("Error deleting Next Action: \(error)")
                    }
                    
                    tableView.reloadData()
                }
            } else if indexPath.section == contexts.count {
                if let unsortedNextAction: NextAction? = unsortedNextActions[indexPath.row] {
                    let id = unsortedNextAction?.id
                    unsortedNextActions.remove(at: indexPath.row)
                    // Delete from core data
                    do {
                        try allItemStore.deleteNextAction(id: id!)
                    } catch {
                        print("Error deleting Next Action: \(error)")
                    }
                    tableView.reloadData()
                }
            }
        }
    }
    
}
