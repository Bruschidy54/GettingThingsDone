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
    var allItemStore: AllItemStore!
    var cells: AccordionCell!
    var reviews = [Review]()
    var headerBool: Bool = true
    

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
        
        // Label Setup
        let allProjects = try! self.allItemStore.fetchMainQueueProjects()
        
        let unsortedNextActions = try! self.allItemStore.fetchUnsortedByProjectNextActions()
        
        self.reviews = try! self.allItemStore.fetchMainQueueReviews()
        
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
      
        self.tableView.reloadData()
        
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
    
    // Add Section for Reviews. Append Date to Review Title
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReferenceCell") as! ReferenceTableViewCell? {
            
            cell.delegate = self
            
            // Update format to make more maintainable?
            if item is AccordionCell.HeaderProject {
                if item.unsorted == true{
                    cell.titleLabel?.text = "Unsorted Next Actions"
                    cell.segueButton.isHidden = true
                }else {
                let project = item.project!
                cell.titleLabel.text = project.name
                cell.segueButton.isHidden = !item.isChecked
            }
            }else {
                let nextAction = item.nextAction!
                cell.titleLabel.text = "\t\(nextAction.name!)"
                cell.segueButton.isHidden = !item.isChecked
            }
            
            if item as? AccordionCell.HeaderProject != nil {
                    cell.backgroundColor = UIColor.lightGray
                }
            else {
                    cell.backgroundColor = UIColor.white
                }
            cell.selectionStyle = .none
            return cell
        }
        }
        else {
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is AccordionCell.HeaderProject {
            return 60
        } else if (item.isHidden) {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        
        if item is AccordionCell.HeaderProject {
            headerBool = true
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
            headerBool = false
            if (indexPath as NSIndexPath).row != self.selectedItemIndex {
                let cell = self.tableView.cellForRow(at: indexPath) as! ReferenceTableViewCell
                cell.segueButton.isHidden = false
                
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
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
 
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Complete"
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
            
            // Change headerBool logic for new sections
            if headerBool == true {
            if let selectedHeaderIndex = self.selectedHeaderIndex {
                if self.cells.items[selectedHeaderIndex] is AccordionCell.HeaderProject {
                    let selectedItemProject = self.cells.items[selectedHeaderIndex].project
                    destinationVC.itemType = "Project"
                    destinationVC.project = selectedItemProject
                    }
                }
            } else if headerBool == false {
                if let selectedItemIndex = self.selectedItemIndex {
                    if self.cells.items[selectedItemIndex] is AccordionCell.SubNextAction {
                        let selectedItemNextAction = self.cells.items[selectedItemIndex].nextAction
                        destinationVC.itemType = "Next Action"
                        destinationVC.nextAction = selectedItemNextAction
                    }
                }
            }
        } else if segue.identifier == "AddItemSegue" {
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.allItemStore = allItemStore
        }
    }
    
}
