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

// Remove section if it is empty or add "No project/context" and add ability to delete items on menu
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
            
            
            delegate?.didUpdateRelatedTo(sender: self)
        }
        else {
            switch itemType {
            case .nextAction:
                
               let contextSet = NSSet(array: relatedToContextArray!)
                nextAction?.contexts = contextSet
                nextAction?.addToContexts(contextSet)
               if relatedToContextArray != nil {
                nextAction?.contextSorted = true
               } else {
                nextAction?.contextSorted = false
               }
                // Need to add to other items
                
                let projectSet = NSSet(array: relatedToProjectsArray!)
                nextAction?.projects = projectSet
                nextAction?.addToProjects(projectSet)
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
        
        relatedToNextActionsArray = []
        relatedToProjectsArray = []
        relatedToNextActionsArray = []
        relatedToContextArray = []
        
        switch itemType {
        case .nextAction:
            let newSections = sections.filter{$0 != "Next Action"}
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
            let newSections = sections.filter{$0 != "Project" && $0 != "Context"}
            sections = newSections
            if !addSegue{
            relatedToNextActionsArray = project?.nextActions?.allObjects as! [NextAction]?
            }
            break
        default:
            break
        }
        
        
        tableView.allowsMultipleSelection = true
        
        // Should handle error
        
        let items = try! allItemStore.fetchMainQueueItems()
        
        allNextActions = items.nextActions
        allProjects = items.projects
        allContexts = items.contexts
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        switch itemType {
        case .nextAction:
            if section == 0 {
                count = (allProjects?.count)!
            }
            else if section == 1 {
                count = (allContexts?.count)!
            }
            break
        case .project:
            if section == 0 {
                count = (allNextActions?.count)!
            }
        default:
            count = 0
        }
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedToCell")
        
        switch itemType {
        case .nextAction:
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
            break
        case .project:
            if indexPath.section == 0 {
                // Assign only nonsorted Next Actions?
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
            if indexPath.section == 0 {
                return "Complete"
            } else if indexPath.section == 1 {
                return "Delete"
            }
            break
        case .project:
            return "Complete"
            break
        default:
            return "Complete"
            break
        }
        return "What?"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch itemType {
        case .nextAction:
            if indexPath.section == 0 {
                if let project: Project? = allProjects?[indexPath.row] {
                    let id = project?.id
                    allProjects?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    let nextActionSet = project?.nextActions
                    let nextActions = Array(nextActionSet!) as! [NextAction]
                    for nextAction in nextActions {
                        nextAction.projectSorted = false
                    }
                    do {
                        try allItemStore.deleteProject(id: id!)
                    } catch {
                        print("Error deleting Project: \(error)")
                    }
                }
            } else if indexPath.section == 1 {
                if let context: Context? = allContexts?[indexPath.row] {
                    let id = context?.id
                    allContexts?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    let nextActionSet = context?.nextActions
                    let nextActions = Array(nextActionSet!) as! [NextAction]
                    for nextAction in nextActions {
                        nextAction.contextSorted = false
                    }
                    do {
                        try allItemStore.deleteContext(id: id!)
                    } catch {
                        print("Error deleting Project: \(error)")
                    }
                }
            }
            break
        case .project:
            if let nextAction: NextAction? = allNextActions?[indexPath.row] {
                let id = nextAction?.id
                allNextActions?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                do {
                    try allItemStore.deleteNextAction(id: id!)
                } catch {
                    print("Error deleting Next Action: \(error)")
                }
            }
            break
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
