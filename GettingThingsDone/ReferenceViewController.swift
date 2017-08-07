//
//  ReferenceViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 6/7/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit


// Add Data Source
class ReferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReferenceTableViewCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    var selectedReviewIndex: Int?
    var allItemStore: AllItemStore!
    var cells: AccordionCell!
    var reviews = [Review]()
    var segueType: SegueType = .headerType
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    enum SegueType {
        case headerType
        case subItemType
        case reviewType
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
  self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TopCloud")!.alpha(0.4).resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)

        
        tableView.allowsSelection = false
        cells = AccordionCell()
        self.tableView.estimatedRowHeight = 45
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsMultipleSelection = true
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        cells.removeAll()
        
        // Label Setup
        let allProjects = try! self.allItemStore.fetchMainQueueProjects()
        
        let unsortedNextActions = try! self.allItemStore.fetchUnsortedByProjectNextActions()
        
        self.reviews = try! self.allItemStore.fetchMainQueueReviews()
        
        if !self.reviews.isEmpty{
            let sortedReviews = self.reviews.sorted{
                ($0.createDate as! Date) > ($1.createDate as! Date)
            }
            self.reviews = sortedReviews
        }
        
        for project in allProjects {
            self.cells.append(AccordionCell.HeaderProject(project: project))
            if project.nextActions != nil {
                for nextAction in Array(project.nextActions!) {
                    self.cells.append(AccordionCell.SubNextAction(nextAction: nextAction as! NextAction))
                }
            }
        }
        
        self.cells.append(AccordionCell.HeaderProject())
        for nextAction in unsortedNextActions {
            self.cells.append(AccordionCell.SubNextAction(nextAction: nextAction))
        }
      
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Projects"
        }
        else if section == 1 {
            return "Review"
        } else {
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return self.cells.items.count
        } else {
            return self.reviews.count
        }
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReferenceCell") as! ReferenceTableViewCell? {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            cell.delegate = self
           
            if self.cells.items.count == 1 {
                cell.titleLabel.text = "No Projects"
                cell.selectionStyle = .none
                cell.titleLabel.textColor = UIColor.black
                cell.segueButton.isHidden = true
                cell.backgroundCloudImage.isHidden = true
                cell.titleLabel.font = UIFont(name: cell.titleLabel.font.fontName, size: 17)
                return cell
            } else {
            if item is AccordionCell.HeaderProject {
                cell.backgroundCloudImage.isHidden = false
                  cell.backgroundCloudImage.image = UIImage(named:"MiddleCloud")?.alpha(0.4)
                cell.titleLabel.font = UIFont(name: cell.titleLabel.font.fontName, size: 24)
                if item.unsorted {
                    cell.titleLabel?.text = "Unsorted Next Actions"
                    cell.titleLabel.textColor = UIColor.black
                    cell.segueButton.isHidden = true
                }else {
                let project = item.project!
                cell.titleLabel.text = project.name
                    if (project.duedate! as Date) < Date() {
                        cell.titleLabel.textColor = UIColor.red
                    } else {
                        cell.titleLabel.textColor = UIColor.black
                    }
                cell.segueButton.isHidden = !item.isChecked
            }
            }else {
                let nextAction = item.nextAction!
                cell.backgroundCloudImage.isHidden = true
                cell.titleLabel.text = "\t\(nextAction.name!)"
                cell.titleLabel.font = UIFont(name: cell.titleLabel.font.fontName, size: 17)
                if (nextAction.duedate! as Date) < Date() {
                    cell.titleLabel.textColor = UIColor.red
                } else {
                    cell.titleLabel.textColor = UIColor.black
                }
                cell.segueButton.isHidden = true
            }
            
            cell.selectionStyle = .none
            return cell
        }
            }
        }
        else if indexPath.section == 1 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ReferenceCell") as! ReferenceTableViewCell? {
                cell.titleLabel.font = UIFont(name: cell.titleLabel.font.fontName, size: 17)
                
                if reviews.isEmpty {
                    cell.titleLabel.text = "No Review Notes"
                    cell.segueButton.isHidden = true
                    cell.backgroundCloudImage.isHidden = true
                    return cell
                } else {
                let review = reviews[indexPath.row]
                let date = dateFormatter.string(from: review.createDate as! Date)
                cell.titleLabel?.text = "\(date): \(review.name!)"
                cell.segueButton.isHidden = true
                return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is AccordionCell.HeaderProject {
            return UITableViewAutomaticDimension
        } else if (item.isHidden) {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        
        if item is AccordionCell.HeaderProject {
            segueType = .headerType
            let cell = self.tableView.cellForRow(at: indexPath) as! ReferenceTableViewCell
            if !item.unsorted {
            cell.segueButton.isHidden = false
        }
            if self.selectedHeaderIndex == nil {
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            } else {
                self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row

            }
            
            if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                self.cells.collapse(previouslySelectedHeaderIndex)
                let cell = self.tableView.cellForRow(at: IndexPath(row: previouslySelectedHeaderIndex, section: 0)) as! ReferenceTableViewCell
                cell.segueButton.isHidden = true
            }
            
            if let selectedItemIndex = self.selectedItemIndex {
                let cell = self.tableView.cellForRow(at: IndexPath(row: selectedItemIndex, section: 0)) as! ReferenceTableViewCell
                cell.segueButton.isHidden = true
            }
            
            if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                self.cells.expand(self.selectedHeaderIndex!)
            } else {
                self.selectedHeaderIndex = nil
                self.previouslySelectedHeaderIndex = nil
            }
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        } else {
            segueType = .subItemType
            if (indexPath as NSIndexPath).row != self.selectedItemIndex {
                let cell = self.tableView.cellForRow(at: indexPath) as! ReferenceTableViewCell
                
                if let selectedItemIndex = self.selectedItemIndex {
                    let previousCell = self.tableView.cellForRow(at: IndexPath(row: selectedItemIndex, section: 0)) as! ReferenceTableViewCell
                    cells.items[selectedItemIndex].isChecked = false
                    previousCell.segueButton.isHidden = true
                }
                
                if let selectedHeaderIndex = self.selectedHeaderIndex {
                    let cell = self.tableView.cellForRow(at: IndexPath(row: selectedHeaderIndex, section: 0)) as! ReferenceTableViewCell
                    cell.segueButton.isHidden = true
                }
                
                self.selectedItemIndex = (indexPath as NSIndexPath).row
                cells.items[self.selectedItemIndex!].isChecked = true
            }
            performSegue(withIdentifier: "ViewItemSegue", sender: self)
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
        } else if indexPath.section == 1 {
            // Selecting Reviews
            segueType = .reviewType
            selectedReviewIndex = indexPath.row
            performSegue(withIdentifier: "ViewItemSegue", sender: self)
        }
    }
 
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if indexPath.section == 0 {
            return "Complete"
        } else if indexPath.section == 1 {
        return "Delete"
        
        } else {
            return "Complete"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                if let item: AccordionCell.Item = self.cells.items[(indexPath as NSIndexPath).row] {
                if item is AccordionCell.HeaderProject {
                    let project = item.project
                    let id = project?.id
                    self.cells.items.remove(at: indexPath.row)
                    if let nextActionSet = project?.nextActions {
                        var i = 0
                        for item in self.cells.items {
                            if item is AccordionCell.SubNextAction {
                                self.cells.items.remove(at: i)
                                i += 1
                                continue
                            } else {
                                break
                            }
                        }
                        let nextActions = Array(nextActionSet) as! [NextAction]
                        for nextAction in nextActions {
                            nextAction.projectSorted = false
                        self.cells.append(AccordionCell.SubNextAction(nextAction: nextAction))
                    }
                    }
                    tableView.reloadData()
                    do {
                        try allItemStore.deleteProject(id: id!)
                    } catch {
                        print("Error deleting Project: \(error)")
                    }
                } else if item is AccordionCell.SubNextAction {
                    let nextAction = item.nextAction
                    let id = nextAction?.id
                    self.cells.items.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    if let projects = nextAction?.projects {
                        nextAction?.removeFromProjects(projects)
                    }
                    do {
                        try allItemStore.deleteNextAction(id: id!)
                    } catch {
                        print("Error deleting Next Action: \(error)")
                    }
                    }
                }
            } else if indexPath.section == 1 {
                if let review: Review? = reviews[indexPath.row] {
                let id = review?.id
                reviews.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                do {
                    try allItemStore.deleteReview(id: id!)
                } catch {
                    print("Error deleting Review: \(error)")
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            if let item: AccordionCell.Item = self.cells.items[(indexPath as NSIndexPath).row] {
                if item is AccordionCell.HeaderProject && item.project == nil {
                    return false
                } else {
                    return true
                }
            }
        } else {
            return true
        }
    }
    
    
    func segueToReferenceItem() {
        // Perform Segue to DetailVC
        
        performSegue(withIdentifier: "ViewItemSegue", sender: self)
    }
    
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewItemSegue" {
            let destinationVC = segue.destination as! ItemDetailViewController
            destinationVC.allItemStore = allItemStore
            
            switch segueType {
            case .reviewType:
                if let selectedReviewIndex = self.selectedReviewIndex {
                    let review = reviews[selectedReviewIndex]
                    destinationVC.itemType = .review
                    destinationVC.review = review
                }
                break
            case .headerType:
                if let selectedHeaderIndex = self.selectedHeaderIndex {
                    if self.cells.items[selectedHeaderIndex] is AccordionCell.HeaderProject {
                        let selectedItemProject = self.cells.items[selectedHeaderIndex].project
                        destinationVC.itemType = .project
                        destinationVC.project = selectedItemProject
                    }
                }
                break
            case.subItemType:
                if let selectedItemIndex = self.selectedItemIndex {
                    if self.cells.items[selectedItemIndex] is AccordionCell.SubNextAction {
                        let selectedItemNextAction = self.cells.items[selectedItemIndex].nextAction
                        destinationVC.itemType = .nextAction
                        destinationVC.nextAction = selectedItemNextAction
                    }
                    
                }
                break
            }
        } else if segue.identifier == "AddItemSegue" {
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.allItemStore = allItemStore
        }
    }
    
}
