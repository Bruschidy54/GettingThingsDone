//
//  RelatedToViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/18/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

protocol RelatedToViewControllerDelegate: class {
    func didUpdateRelatedTo(sender: RelatedToViewController)
}

class RelatedToViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var allItemStore: AllItemStore!
    var nextAction: NextAction?
    var project: Project?
    var sections = ["Next Action", "Project", "Context"]
    var allNextActions: [NextAction]?
    var allProjects: [Project]?
    var allContexts: [Context]?
    var relatedToNextActionsArray: [NextAction]?
    var relatedToProjectsArray: [Project]?
    var relatedToContextArray: [Context]?
    var addSegue: Bool = false
    var itemType: ItemType = .nextAction
    let coreDataStack = CoreDataStack(modelName: "GTDModel")
    weak var delegate:RelatedToViewControllerDelegate?
    
    
    
    @IBAction func onDoneButtonTapped(_ sender: Any) {
        
        // Save relationships
        
        if addSegue{
            
            // Send the relationships to AddItemVC using custom delegation
            delegate?.didUpdateRelatedTo(sender: self)
        }
        else {
            switch itemType {
            case .nextAction:
                
                let contextSet = NSSet(array: relatedToContextArray!)
                nextAction?.contexts = contextSet
                nextAction?.addToContexts(contextSet)
                
                // Next action is context sorted
                if relatedToContextArray != nil {
                    nextAction?.contextSorted = true
                } else {
                    nextAction?.contextSorted = false
                }
                
                let projectSet = NSSet(array: relatedToProjectsArray!)
                nextAction?.projects = projectSet
                nextAction?.addToProjects(projectSet)
                
                // Next action is project sorted
                if relatedToProjectsArray != nil {
                    nextAction?.projectSorted = true
                } else {
                    nextAction?.projectSorted = false
                }
                break
            case .project:
                let nextActionSet = NSSet(array: relatedToNextActionsArray!)
                project?.nextActions = nextActionSet
                project?.addToNextActions(nextActionSet)
                for nextAction in relatedToNextActionsArray! {
                    nextAction.projectSorted = true
                }
                break
            default:
                break
            }
        }
        
        do {
            try self.coreDataStack.saveChanges()
        }
        catch {
            print("Error saving relationship")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set back button color to match theme
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 153/255, blue: 0, alpha: 1)
        
        
        
        tableView.allowsMultipleSelection = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        relatedToNextActionsArray = []
        relatedToProjectsArray = []
        relatedToNextActionsArray = []
        relatedToContextArray = []
        
        let items = try! allItemStore.fetchMainQueueItems()
        
        allNextActions = items.nextActions
        allProjects = items.projects
        allContexts = items.contexts
        
        
        switch itemType {
        case .nextAction:
            var newSections = sections.filter{$0 != "Next Action"}
            if allContexts?.count == 0 {
                newSections = newSections.filter{$0 != "Context"}
            }
            if allProjects?.count == 0 {
                newSections = newSections.filter{$0 != "Project"
                }
            }
            sections = newSections
            if !addSegue{
                let relatedProjects = nextAction?.value(forKeyPath: "projects") as! NSSet
                print(relatedProjects)
                let relatedContexts = nextAction?.value(forKeyPath: "contexts") as! NSSet
                print(relatedContexts)
                
                relatedToProjectsArray = relatedProjects.allObjects as! [Project]
                relatedToContextArray = relatedContexts.allObjects as! [Context]
            }
            break
        case .project:
            var newSections = sections.filter{$0 != "Project" && $0 != "Context"}
            if allNextActions?.count == 0 {
                newSections = newSections.filter{$0 != "Next Action"}
            }
            sections = newSections
            if !addSegue{
                relatedToNextActionsArray = project?.nextActions?.allObjects as! [NextAction]?
            }
            break
        default:
            break
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let headerView = tableView.headerView(forSection: section)
        let title = headerView?.textLabel?.text
        
        var count = 0
        switch itemType {
        case .nextAction:
            
            if (allContexts?.isEmpty)! && (allProjects?.isEmpty)! {
                break
            } else if (allContexts?.isEmpty)! {
                if section == 0 {
                    count = (allProjects?.count)!
                }
            } else if (allProjects?.isEmpty)! {
                if section == 0 {
                    count = (allContexts?.count)!
                }
            } else {
                
                if section == 0 {
                    count = (allProjects?.count)!
                }
                else if section == 1 {
                    count = (allContexts?.count)!
                }
            }
            break
        case .project:
            if !(allNextActions?.isEmpty)! {
                if section == 0 {
                    count = (allNextActions?.count)!
                }
            } else {
                break
            }
        default:
            break
        }
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty {
            let noItemsLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noItemsLabel.text = "No Relatable Items"
            noItemsLabel.textColor = UIColor.darkGray
            noItemsLabel.textAlignment = .center
            tableView.backgroundView = noItemsLabel
            tableView.separatorStyle = .none
        }
        else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedToCell")
        
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell?.textLabel?.font = UIFont(name: "GillSans", size: 17)
        cell?.textLabel?.textColor = UIColor.darkGray
        
        
        
        switch itemType {
        case .nextAction:
            if (allContexts?.isEmpty)! && (allProjects?.isEmpty)! {
                break
            } else if (allContexts?.isEmpty)! {
                if indexPath.section == 0 {
                    let currentProject = allProjects?[indexPath.row]
                    if (relatedToProjectsArray?.contains(currentProject!))! {
                        cell?.accessoryType = .checkmark
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
                    }
                    else {
                        cell?.accessoryType = .none
                        
                    }
                    cell?.textLabel?.text = currentProject?.name
                }
            }else if (allProjects?.isEmpty)! {
                if indexPath.section == 0 {
                    let currentContext = allContexts?[indexPath.row]
                    if (relatedToContextArray?.contains(currentContext!))! {
                        cell?.accessoryType = .checkmark
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
                    }
                    else {
                        cell?.accessoryType = .none
                        
                    }
                    cell?.textLabel?.text = currentContext?
                        .name
                }
            } else {
                if indexPath.section == 0 {
                    let currentProject = allProjects?[indexPath.row]
                    if (relatedToProjectsArray?.contains(currentProject!))! {
                        cell?.accessoryType = .checkmark
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
                    }
                    else {
                        cell?.accessoryType = .none
                        
                    }
                    cell?.textLabel?.text = currentProject?.name
                }
                else if indexPath.section == 1 {
                    let currentContext = allContexts?[indexPath.row]
                    if (relatedToContextArray?.contains(currentContext!))! {
                        cell?.accessoryType = .checkmark
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
                    }
                    else {
                        cell?.accessoryType = .none
                        
                    }
                    cell?.textLabel?.text = currentContext?
                        .name
                }
            }
            break
        case .project:
            if indexPath.section == 0 {
                let currentNextAction = allNextActions?[indexPath.row]
                if (relatedToNextActionsArray?.contains(currentNextAction!))! {
                    cell?.accessoryType = .checkmark
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
                }
                else {
                    cell?.accessoryType = .none
                    
                }
                cell?.textLabel?.text = currentNextAction?.name
            }
            break
            
        default:
            break
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        switch itemType {
        case .nextAction:
            if (allContexts?.isEmpty)! && (allProjects?.isEmpty)! {
                break
            } else if (allContexts?.isEmpty)! {
                if indexPath.section == 0 {
                    let project = allProjects?[indexPath.row]
                    let indexes = relatedToProjectsArray?.enumerated().filter({ $0.element == project}).map{ $0.offset }
                    for index in (indexes?.reversed())! {
                        relatedToProjectsArray?.remove(at: index)
                    }
                    cell?.accessoryType = .none
                }
            }else if (allProjects?.isEmpty)! {
                if indexPath.section == 0 {
                    let context = allContexts?[indexPath.row]
                    let indexes = relatedToContextArray?.enumerated().filter({ $0.element == context}).map{ $0.offset }
                    for index in (indexes?.reversed())! {
                        relatedToContextArray?.remove(at: index)
                    }
                    cell?.accessoryType = .none
                }
            }else {
                if indexPath.section == 0 {
                    let project = allProjects?[indexPath.row]
                    let indexes = relatedToProjectsArray?.enumerated().filter({ $0.element == project}).map{ $0.offset }
                    for index in (indexes?.reversed())! {
                        relatedToProjectsArray?.remove(at: index)
                    }
                    cell?.accessoryType = .none
                }
                else if indexPath.section == 1 {
                    let context = allContexts?[indexPath.row]
                    let indexes = relatedToContextArray?.enumerated().filter({ $0.element == context}).map{ $0.offset }
                    for index in (indexes?.reversed())! {
                        relatedToContextArray?.remove(at: index)
                    }
                    cell?.accessoryType = .none
                }
            }
            break
        case .project:
            if indexPath.section == 0 {
                let nextAction = allNextActions?[indexPath.row]
                let indexes = relatedToNextActionsArray?.enumerated().filter({ $0.element == nextAction}).map{ $0.offset }
                for index in (indexes?.reversed())! {
                    relatedToNextActionsArray?.remove(at: index)
                }
                cell?.accessoryType = .none
            }
            break
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        switch itemType {
        case .nextAction:
            if (allContexts?.isEmpty)! && (allProjects?.isEmpty)! {
                break
            } else if (allContexts?.isEmpty)! {
                if indexPath.section == 0 {
                    let project = allProjects?[indexPath.row]
                    relatedToProjectsArray?.append(project!)
                    cell?.accessoryType = .checkmark
                }
            } else if (allProjects?.isEmpty)! {
                if indexPath.section == 0 {
                    let context = allContexts?[indexPath.row]
                    relatedToContextArray?.append(context!)
                    
                    cell?.accessoryType = .checkmark
                }
            } else {
                if indexPath.section == 0 {
                    let project = allProjects?[indexPath.row]
                    relatedToProjectsArray?.append(project!)
                    cell?.accessoryType = .checkmark
                }
                else if indexPath.section == 1 {
                    let context = allContexts?[indexPath.row]
                    relatedToContextArray?.append(context!)
                    
                    cell?.accessoryType = .checkmark
                }
            }
            break
        case .project:
            if indexPath.section == 0 {
                let nextAction = allNextActions?[indexPath.row]
                relatedToNextActionsArray?.append(nextAction!)
                cell?.accessoryType = .checkmark
            }
            break
        default:
            break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        switch itemType {
        case .nextAction:
            if sections.isEmpty {
                break
            } else if (allContexts?.isEmpty)! {
                if indexPath.section == 0 {
                    return "Complete"
                }
            } else if (allProjects?.isEmpty)! {
                if indexPath.section == 0 {
                    return "Delete"
                }
            } else {
                
                if indexPath.section == 0 {
                    return "Complete"
                } else if indexPath.section == 1 {
                    return "Delete"
                }
            }
        case .project:
            return "Complete"
        default:
            return "Complete"
        }
        return "What?"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch itemType {
        case .nextAction:
            if (allContexts?.isEmpty)! && (allProjects?.isEmpty)! {
                break
            } else if (allContexts?.isEmpty)! {
                if indexPath.section == 0 {
                    if let project: Project? = allProjects?[indexPath.row] {
                        guard let id = project?.id else { return }
                        allProjects?.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        let nextActionSet = project?.nextActions
                        let nextActions = Array(nextActionSet!) as! [NextAction]
                        
                        // Delete from core data
                        do {
                            try allItemStore.deleteProject(id: id)
                        } catch {
                            print("Error deleting Project: \(error)")
                        }
                        
                        // Unsort relevant next actions
                        for nextAction in nextActions {
                            if nextAction.projects?.count == 0 {
                                nextAction.projectSorted = false
                            }
                        }
                    }
                }
            } else if (allProjects?.isEmpty)! {
                if indexPath.section == 0 {
                    if let context: Context? = allContexts?[indexPath.row] {
                        guard let id = context?.id else { return }
                        allContexts?.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        let nextActionSet = context?.nextActions
                        let nextActions = Array(nextActionSet!) as! [NextAction]
                        
                        // Delete from core data
                        do {
                            try allItemStore.deleteContext(id: id)
                        } catch {
                            print("Error deleting Context: \(error)")
                        }
                        
                        // Unsort relevant next actions
                        for nextAction in nextActions {
                            if nextAction.contexts?.count == 0 {
                                nextAction.contextSorted = false
                            }
                        }
                    }
                }
            } else {
                if indexPath.section == 0 {
                    if let project: Project? = allProjects?[indexPath.row] {
                        guard let id = project?.id else { return }
                        allProjects?.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        let nextActionSet = project?.nextActions
                        let nextActions = Array(nextActionSet!) as! [NextAction]
                        
                        // Delete from core data
                        do {
                            try allItemStore.deleteProject(id: id)
                        } catch {
                            print("Error deleting Project: \(error)")
                        }
                        
                        // Unsort relevant next actions
                        for nextAction in nextActions {
                            if nextAction.projects?.count == 0 {
                                nextAction.projectSorted = false
                            }
                        }
                    }
                } else if indexPath.section == 1 {
                    if let context: Context? = allContexts?[indexPath.row] {
                        guard let id = context?.id else { return }
                        allContexts?.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        let nextActionSet = context?.nextActions
                        let nextActions = Array(nextActionSet!) as! [NextAction]
                        
                        // Delete from core data
                        do {
                            try allItemStore.deleteContext(id: id)
                        } catch {
                            print("Error deleting Context: \(error)")
                        }
                        
                        // Unsort relevant next actions
                        for nextAction in nextActions {
                            if nextAction.contexts?.count == 0 {
                                nextAction.contextSorted = false
                            }
                        }
                    }
                }
            }
            break
        case .project:
            if let nextAction: NextAction? = allNextActions?[indexPath.row] {
                guard let id = nextAction?.id else { return }
                allNextActions?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Delete from core data
                do {
                    try allItemStore.deleteNextAction(id: id)
                } catch {
                    print("Error deleting Next Action: \(error)")
                }
            }
            break
        default:
            break
        }
    }
    
    
    
}
