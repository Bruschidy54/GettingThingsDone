//
//  ReferenceViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 6/7/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit


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
        
        // Fetch projects and project-unsorted next actions
        let allProjects = try! self.allItemStore.fetchMainQueueProjects()
        
        let unsortedNextActions = try! self.allItemStore.fetchUnsortedByProjectNextActions()
        
        
        // Fetch and sort reviews
        self.reviews = try! self.allItemStore.fetchMainQueueReviews()
        
        if !self.reviews.isEmpty{
            let sortedReviews = self.reviews.sorted{
                ($0.createDate as! Date) > ($1.createDate as! Date)
            }
            self.reviews = sortedReviews
        }
        
        // Fetch sorted next actions
        for project in allProjects {
            self.cells.append(AccordionCell.HeaderProject(project: project))
            if project.nextActions != nil {
                for nextAction in Array(project.nextActions!) {
                    self.cells.append(AccordionCell.SubNextAction(nextAction: nextAction as! NextAction))
                }
            }
        }
        
        // Add a blank header project to serve as a header for unsorted next actions
            self.cells.append(AccordionCell.HeaderProject())
            for nextAction in unsortedNextActions {
                self.cells.append(AccordionCell.SubNextAction(nextAction: nextAction))
            }
        
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
        
    }
    
    func segueToReferenceItem() {
        
        // Perform Segue to DetailVC
        performSegue(withIdentifier: "ViewItemSegue", sender: self)
    }
    
    // MARK: - TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.cells.items.count == 1 && reviews.count == 0 {
            let noItemsLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noItemsLabel.text = "No Projects Or Reviews"
            noItemsLabel.textColor = UIColor.darkGray
            noItemsLabel.textAlignment = .center
            tableView.backgroundView = noItemsLabel
            tableView.separatorStyle = .none
            return 0
        } else {
        if reviews.isEmpty {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 2
        }
        }
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
                cell.titleLabel?.numberOfLines = 0
                cell.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.dueDateLabel?.font = UIFont(name: "GillSans", size: 10)
                cell.titleLabel.textColor = UIColor.darkGray
                
                cell.delegate = self
                
                // Check if cells has any relevant data in it
                if self.cells.items.count == 1 {
                    cell.titleLabel.text = "No Projects"
                    cell.dueDateLabel.text = ""
                    cell.selectionStyle = .none
                    cell.dueDateLabel.textColor = UIColor.darkGray
                    cell.segueButton.isHidden = true
                    cell.backgroundCloudImage.isHidden = true
                    cell.titleLabel.font = UIFont(name: "GillSans-SemiBold", size: 17)
                    return cell
                } else {
                    if item is AccordionCell.HeaderProject {
                        cell.backgroundCloudImage.isHidden = false
                        cell.backgroundCloudImage.image = UIImage(named:"MiddleCloud")?.alpha(0.4)
                        cell.titleLabel.font = UIFont(name: "GillSans-SemiBold", size: 17)
                        if item.unsorted {
                            cell.titleLabel?.text = "Unsorted Next Actions"
                            cell.dueDateLabel.textColor = UIColor.darkGray
                            cell.dueDateLabel.text = ""
                            cell.segueButton.isHidden = true
                        } else {
                            let project = item.project!
                            cell.titleLabel.text = project.name
                            let dueDate = dateFormatter.string(from: project.duedate as! Date)
                            cell.dueDateLabel.text = "  Due \(dueDate)"
                            if (project.duedate! as Date) < Date() {
                                cell.dueDateLabel.textColor = UIColor.red
                            } else {
                                cell.dueDateLabel.textColor = UIColor.darkGray
                            }
                            cell.segueButton.isHidden = !item.isChecked
                        }
                    } else {
                        let nextAction = item.nextAction!
                        cell.backgroundCloudImage.isHidden = true
                        cell.titleLabel.text = "\t\(nextAction.name!)"
                        cell.titleLabel.font = UIFont(name: "GillSans", size: 17)
                        let dueDate = dateFormatter.string(from: nextAction.duedate as! Date)
                        cell.dueDateLabel.text = "\t  Due \(dueDate)"
                        if (nextAction.duedate! as Date) < Date() {
                            cell.dueDateLabel.textColor = UIColor.red
                        } else {
                            cell.dueDateLabel.textColor = UIColor.darkGray
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
                    let review = reviews[indexPath.row]
                    let date = dateFormatter.string(from: review.createDate as! Date)
                    cell.backgroundCloudImage.isHidden = true
                    cell.dueDateLabel.text = ""
                    cell.titleLabel.textColor = UIColor.darkGray
                    cell.titleLabel.font = UIFont(name: "GillSans", size: 17)
                    cell.titleLabel?.text = "\(date): \(review.name!)"
                    cell.segueButton.isHidden = true
                    return cell
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
                
                // Check if header is the header for unsorted next actions
                if !item.unsorted {
                    cell.segueButton.isHidden = false
                }
                
                // Set the selectedHeaderIndex and previouslySelectedHeaderIndex
                if self.selectedHeaderIndex == nil {
                    self.selectedHeaderIndex = (indexPath as NSIndexPath).row
                } else {
                    self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                    self.selectedHeaderIndex = (indexPath as NSIndexPath).row
                    
                }
                
                // If new project is selected, collapses the next actions of the previously selected project
                if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                    self.cells.collapse(previouslySelectedHeaderIndex)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: previouslySelectedHeaderIndex, section: 0)) as! ReferenceTableViewCell
                    cell.segueButton.isHidden = true
                }
                
                if let selectedItemIndex = self.selectedItemIndex {
                    let cell = self.tableView.cellForRow(at: IndexPath(row: selectedItemIndex, section: 0)) as! ReferenceTableViewCell
                    cell.segueButton.isHidden = true
                }
                
                // Expand the next action list of the newly selected project
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
            // Selecting a reviews triggers segue to item detail VC
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
                        guard let project = item.project else { return }
                        let id = project.id
                        self.cells.items.remove(at: indexPath.row)
                        
                        // Delete from core data
                        do {
                            try allItemStore.deleteProject(id: id!)
                        } catch {
                            print("Error deleting Project: \(error)")
                        }
                        
                        // Unsort related next actions
                        if let nextActionSet = project.nextActions {
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
                                if nextAction.projects?.count == 0 {
                                nextAction.projectSorted = false
                                }
                                self.cells.append(AccordionCell.SubNextAction(nextAction: nextAction))
                            }
                        }
                        OperationQueue.main.addOperation {
                        tableView.reloadData()
                        }
                        

                    } else if item is AccordionCell.SubNextAction {
                        guard let nextAction = item.nextAction else { return }
                        let id = nextAction.id
                        self.cells.items.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                        if let projects = nextAction.projects {
                            nextAction.removeFromProjects(projects)
                        }
                        
                        // Delete from core data
                        do {
                            try allItemStore.deleteNextAction(id: id!)
                        } catch {
                            print("Error deleting Next Action: \(error)")
                        }
                    }
                }
            } else if indexPath.section == 1 {
                if let review: Review? = reviews[indexPath.row] {
                    guard let id = review?.id else { return }
                    reviews.remove(at: indexPath.row)
                    
                    if reviews.isEmpty {
                        tableView.deleteSections(NSIndexSet.init(index: indexPath.section) as IndexSet, with: .fade)
                    } else {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                    // Delete from core data
                    do {
                        try allItemStore.deleteReview(id: id)
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
