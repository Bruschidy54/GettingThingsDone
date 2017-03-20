//
//  RelatedToViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/18/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class RelatedToViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    var allItemStore: AllItemStore!
    var nextAction: NextAction?
    var project: Project?
    var topic: Topic?
    var sections = ["Next Action", "Project", "Topic", "Context"]
    var allNextActions: [NextAction]?
    var allProjects: [Project]?
    var allTopics: [Topic]?
    var allContexts: [Context]?
    var relatedToNextActionsArray: [NextAction]?
    var relatedToProjectsArray: [Project]?
    var relatedToTopicArray: [Topic]?
    var relatedToContextArray: [Context]?
    var addSegue: Bool = false
    var itemType: String = ""
    let coreDataStack = CoreDataStack(modelName: "GTDModel")
    
    
    @IBAction func onDoneButtonTapped(_ sender: Any) {
        
        // Save relationships
        
        if addSegue{
            // Use custom delegation to set arrays in AddItemViewController
        }
        else {
            switch itemType {
            case "Next Action":
                let contextSet = NSSet(array: relatedToContextArray!)
                nextAction?.contexts = contextSet
                
                let projectSet = NSSet(array: relatedToProjectsArray!)
                nextAction?.projects = projectSet
                break
            case "Project":
                let nextActionSet = NSSet(array: relatedToNextActionsArray!)
                project?.addToNextActions(nextActionSet)
//                project?.topic = project?.managedObjectContext?.object(with: (relatedToTopic?.objectID)!) as! Topic? 
                break
            case "Topic":
                let projectSet = NSSet(array: relatedToProjectsArray!)
                topic?.addToProjects(projectSet)
                break
            default:
                break
            }
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
        case "Next Action":
            let newSections = sections.filter{$0 != "Next Action" && $0 != "Topic"}
            sections = newSections
            relatedToProjectsArray = nextAction?.projects?.allObjects as! [Project]?
            relatedToContextArray = nextAction?.contexts?.allObjects as! [Context]?
            break
        case "Project":
            let newSections = sections.filter{$0 != "Project" && $0 != "Context"}
            sections = newSections
            relatedToNextActionsArray = project?.nextActions?.allObjects as! [NextAction]?
            // Fix ******
//            relatedToTopic = project?.topics
            
            break
        case "Topic":
            let newSections = sections.filter{$0 != "Topic" && $0 != "Context" && $0 != "Next Action"}
            sections = newSections
            relatedToProjectsArray = topic?.projects?.allObjects as! [Project]?
            break
        default:
            break
        }
        
        
        tableView.allowsMultipleSelection = true
        
        // Should handle error
        
        let items = try! allItemStore.fetchMainQueueItems()
        
        allNextActions = items.nextActions
        allProjects = items.projects
        allTopics = items.topics
        allContexts = items.contexts
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        
//        
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        switch itemType {
        case "Next Action":
            if section == 0 {
                count = (allProjects?.count)!
            }
            else if section == 1 {
                count = (allContexts?.count)!
            }
            break
        case "Project":
            if section == 0 {
                count = (allNextActions?.count)!
            }
            else if section == 1 {
                count = (allTopics?.count)!
            }
            break
        case "Topic":
            count = (allProjects?.count)!
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
        case "Next Action":
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
        case "Project":
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
            else if indexPath.section == 1 {
                let currentTopic = allTopics?[indexPath.row]
                if (relatedToTopicArray?.contains(currentTopic!))! {
                    cell?.accessoryType = .checkmark
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
                }
                else {
                    cell?.accessoryType = .none
                    
                }
                cell?.textLabel?.text = currentTopic?.name
            }
            break
        case "Topic":
            let currentProject = allProjects?[indexPath.row]
            if (relatedToProjectsArray?.contains(currentProject!))! {
                cell?.accessoryType = .checkmark
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
            }
            else {
                cell?.accessoryType = .none
                
            }
            cell?.textLabel?.text = currentProject?.name
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
        case "Next Action":
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
        case "Project":
            if indexPath.section == 0 {
                // Assign only nonsorted Next Actions?
                let nextAction = allNextActions?[indexPath.row]
                let indexes = relatedToNextActionsArray?.enumerated().filter({ $0.element == nextAction}).map{ $0.offset }
                for index in (indexes?.reversed())! {
                    relatedToNextActionsArray?.remove(at: index)
                }
                cell?.accessoryType = .none
            }
            else if indexPath.section == 1 {
                let topic = allTopics?[indexPath.row]
                let indexes = relatedToTopicArray?.enumerated().filter({ $0.element == topic}).map{ $0.offset }
                for index in (indexes?.reversed())! {
                    relatedToTopicArray?.remove(at: index)
                }
                cell?.accessoryType = .none
            }
            break
        case "Topic":
            // Assign only nonsorted Projects?
            let project = allProjects?[indexPath.row]
            let indexes = relatedToProjectsArray?.enumerated().filter({ $0.element == project}).map{ $0.offset }
            for index in (indexes?.reversed())! {
                relatedToProjectsArray?.remove(at: index)
            }
            cell?.accessoryType = .none
            break
        default:
            break
        }
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        switch itemType {
        case "Next Action":
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
        case "Project":
            if indexPath.section == 0 {
                let nextAction = allNextActions?[indexPath.row]
                relatedToNextActionsArray?.append(nextAction!)
                cell?.accessoryType = .checkmark
            }
            else if indexPath.section == 1 {
                let topic = allTopics?[indexPath.row]
                relatedToTopicArray?.append(topic!)
                cell?.accessoryType = .checkmark
            }
            break
        case "Topic":
            let project = allProjects?[indexPath.row]
            relatedToProjectsArray?.append(project!)
            cell?.accessoryType = .checkmark
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
