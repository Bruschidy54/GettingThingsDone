//
//  ItemDetailViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/11/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var durationSlider: UISlider!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDateFullDateLabel: UILabel!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var prioritySlider: UISlider!
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var relatedToButton: UIButton!
    @IBOutlet var classifyButton: UIButton!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var datePickerStackView: UIStackView!
    @IBOutlet var priorityLevelLabel: UILabel!
    @IBOutlet var durationLevelLabel: UILabel!
    @IBOutlet var prioritySliderConstraint: NSLayoutConstraint!
    @IBOutlet var durationSliderContraint: NSLayoutConstraint!
    @IBOutlet var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var notesTextViewHeightConstraint: NSLayoutConstraint!
    
    
    
    // Create enum for itemType instead of string
    
    var toDo: ToDo?
    var project: Project?
    var review: Review?
    var itemType: String = ""
    var nextAction: NextAction?
    var allItemStore: AllItemStore!
    var screenSize: CGRect = UIScreen.main.bounds
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSaveButtonTapped(_ sender: Any) {
        saveItem()
         self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func onPrioritySliderSlid(_ sender: Any) {
        var sliderValue = (sender as! UISlider).value
        
        if sliderValue >= 0 && sliderValue < 0.2  {
            
            self.priorityLevelLabel.text = "Very Low"
            
        } else if sliderValue >= 0.2 && sliderValue < 0.4 {
            
            self.priorityLevelLabel.text = "Low"
            
        } else if sliderValue >= 0.4 && sliderValue < 0.6 {
            
            self.priorityLevelLabel.text = "Medium"
            
        } else if sliderValue >= 0.6 && sliderValue < 0.8 {
            
            self.priorityLevelLabel.text = "High"
            
        } else if sliderValue >= 0.8 && sliderValue <= 1 {
            
            self.priorityLevelLabel.text = "Very High"
            
        }
    }
    
    @IBAction func onDurationSliderSlid(_ sender: Any) {
        
        var sliderValue = (sender as! UISlider).value
        
        if sliderValue == 0 {
            
            self.durationLevelLabel.text = "<2 Min"
            
        }else if sliderValue > 0 && sliderValue < 0.2  {
            
            self.durationLevelLabel.text = "<15 Min"
            
        } else if sliderValue >= 0.2 && sliderValue < 0.4 {
            
            self.durationLevelLabel.text = "<1 Hr"
            
        } else if sliderValue >= 0.4 && sliderValue < 0.6 {
            
            self.durationLevelLabel.text = "<2 Hr"
            
        } else if sliderValue >= 0.6 && sliderValue < 0.8 {
            
            self.durationLevelLabel.text = "<4 Hr"
            
        } else if sliderValue >= 0.8 && sliderValue < 1 {
            
            self.durationLevelLabel.text = "<8 Hr"
            
        } else if sliderValue == 1 {
            
            self.durationLevelLabel.text = ">8 Hr"
            
        }
    }
    
    
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        prioritySliderConstraint.constant = (screenSize.width)/2
        durationSliderContraint.constant = (screenSize.width)/2
        
        
        formatPage()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.datePickerTapped(gestureRecognizer:)))
        datePickerStackView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      self.tabBarController?.tabBar.isHidden = true
        
//        switch itemType {
//        case "To Do":
//            print(toDo)
//            break
//        case "Next Action":
//            print(nextAction)
//            break
//        case "Project":
//            print(project)
//            break
//        case "Review":
//            print(review)
//            break
//        default:
//            break
//        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            
        let point = CGPoint(x: 0, y: 0)
        screenSize = CGRect(origin: point, size: size)
            prioritySliderConstraint.constant = (screenSize.width)/2
            durationSliderContraint.constant = (screenSize.width)/2
            datePickerHeightConstraint.constant = (screenSize.height)/6
            notesTextViewHeightConstraint.constant = (screenSize.height/3)
        } else {
            let point = CGPoint(x: 0, y: 0)
            screenSize = CGRect(origin: point, size: size)
            prioritySliderConstraint.constant = (screenSize.width)/2
            durationSliderContraint.constant = (screenSize.width)/2
            datePickerHeightConstraint.constant = (screenSize.height)/5
            notesTextViewHeightConstraint.constant = 2 * (screenSize.height/5)
        }
    }

    
    func formatPage() {
        let newScreenSize = UIScreen.main.bounds
        screenSize = newScreenSize
        
        switch itemType {
        case "To Do":
            titleTextField.text = toDo?.name
            notesTextView.text = toDo?.details
            titleLabel.isHidden = false
            titleTextField.isHidden = false
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = true
            dueDateFullDateLabel.isHidden = true
            relatedToButton.isHidden = true
            dueDatePicker.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            
            if UIDevice.current.orientation.isLandscape {
                notesTextViewHeightConstraint.constant = (screenSize.height/2)
            } else {
                notesTextViewHeightConstraint.constant = 3 * (screenSize.height/5)
            }
            
            break
        case "Next Action":
            titleTextField.text = nextAction?.name
            notesTextView.text = nextAction?.details
            prioritySlider.value = (nextAction?.priority)!
            durationSlider.value = (nextAction?.processingtime)!
            dueDateFullDateLabel.text = dateFormatter.string(from: nextAction?.duedate as! Date)
            dueDatePicker.date = nextAction?.duedate as! Date
            
            if UIDevice.current.orientation.isLandscape {
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = (screenSize.height/3)
            } else {
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = 2 * (screenSize.height/5)
            }
            
            if Double((nextAction?.priority)!) >= 0.2 && Double((nextAction?.priority)!) < 0.4 {
                
                self.priorityLevelLabel.text = "Low"
                
            } else if Double((nextAction?.priority)!) >= 0.4 && Double((nextAction?.priority)!) < 0.6 {
                
                self.priorityLevelLabel.text = "Medium"
                
            } else if Double((nextAction?.priority)!) >= 0.6 && Double((nextAction?.priority)!) < 0.8 {
                
                self.priorityLevelLabel.text = "High"
                
            } else if Double((nextAction?.priority)!) >= 0.8 && Double((nextAction?.priority)!) <= 1 {
                
                self.priorityLevelLabel.text = "Very High"
                
            }
            
            
            // Localize units of time for other countries
            
            if Double((nextAction?.processingtime)!) == 0 {
                
                self.durationLevelLabel.text = "<2 Min"
                
            }else if Double((nextAction?.processingtime)!) > 0 && Double((nextAction?.processingtime)!) < 0.2  {
                
                self.durationLevelLabel.text = "<15 Min"
                
            } else if Double((nextAction?.processingtime)!) >= 0.2 && Double((nextAction?.processingtime)!) < 0.4 {
                
                self.durationLevelLabel.text = "<1 Hr"
                
            } else if Double((nextAction?.processingtime)!) >= 0.4 && Double((nextAction?.processingtime)!) < 0.6 {
                
                self.durationLevelLabel.text = "<2 Hr"
                
            } else if Double((nextAction?.processingtime)!) >= 0.6 && Double((nextAction?.processingtime)!) < 0.8 {
                
                self.durationLevelLabel.text = "<4 Hr"
                
            } else if Double((nextAction?.processingtime)!) >= 0.8 && Double((nextAction?.processingtime)!) < 1 {
                
                self.durationLevelLabel.text = "<8 Hr"
                
            } else if Double((nextAction?.processingtime)!) == 1 {
                
                self.durationLevelLabel.text = ">8 Hr"
                
            }

            
            titleLabel.isHidden = false
            titleTextField.isHidden = false
            priorityLabel.isHidden = false
            prioritySlider.isHidden = false
            durationLabel.isHidden = false
            durationSlider.isHidden = false
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = false
            dueDateFullDateLabel.isHidden = false
            relatedToButton.isHidden = false
            dueDatePicker.isHidden = true
            classifyButton.isHidden = true
            priorityLevelLabel.isHidden = false
            durationLevelLabel.isHidden = false
            break
        case "Project":
            titleTextField.text = project?.name
            notesTextView.text = project?.details
            dueDateFullDateLabel.text = dateFormatter.string(from: project?.duedate as! Date)
            dueDatePicker.date = project?.duedate as! Date
            titleLabel.isHidden = false
            titleTextField.isHidden = false
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = false
            dueDatePicker.isHidden = true
            dueDateFullDateLabel.isHidden = false
            relatedToButton.isHidden = false
            classifyButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            
            if UIDevice.current.orientation.isLandscape {
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = 2 * (screenSize.height/5)
            } else {
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = (screenSize.height/2)
            }
            break
        case "Review":
            titleTextField.text = review?.name
            notesTextView.text = review?.details
            titleLabel.isHidden = false
            titleTextField.isHidden = false
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            dueDateFullDateLabel.isHidden = true
            relatedToButton.isHidden = false
            classifyButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            
            if UIDevice.current.orientation.isLandscape {
                notesTextViewHeightConstraint.constant = (screenSize.height/2)
            } else {
                notesTextViewHeightConstraint.constant = 3 * (screenSize.height/5)
            }
            break
        default:
            break
        }
    }
    
    
    // Add delegate method and tap gesture recognizer to resign first responder
    
    
    //Change update dictionaries to reflect new data model
    
    func saveItem(){
        switch self.itemType {
        case "To Do":
            let toDoDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "datecreated" : toDo?.datecreated as Any, "details": notesTextView.text as Any, "id": toDo?.id]
            do {
                try self.allItemStore.updateToDo(toDoDict: toDoDict)
                print("To Do successfully updated")
            } catch {
                print(error)
            }
            break
        case "Next Action":
            
            
            // Update dictionary
            let nextActionDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "createdate" : nextAction?.createdate as Any, "duedate" : dueDatePicker.date as Any, "details": notesTextView.text as Any, "id": nextAction?.id, "priority" : prioritySlider.value as Any, "processingtime" : durationSlider.value, "projects" : nextAction?.projects, "contexts" : nextAction?.contexts]
            do {
                try self.allItemStore.updateNextActions(nextActionDict: nextActionDict)
                print("Next Action successfully updated")
            } catch {
                print(error)
            }
            break
        case "Project":
            
            // Update dictionary
            let projectDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "createdate" : project?.createdate as Any, "duedate" : dueDatePicker.date as Any, "details": notesTextView.text as Any, "id": project?.id]
            do {
                try self.allItemStore.updateProject(projectDict: projectDict)
                print("Project successfully updated")
            } catch {
                print(error)
            }
            break
//        case "Review":
            
            // **** Change into review data model
//            let reviewDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "review" : topic?.review as Any, "details": notesTextView.text as Any, "id": topic?.id]
//            do {
//                try self.allItemStore.updateTopic(topicDict: topicDict)
//                print("Topic successfully updated")
//            } catch {
//                print(error)
//            }
//            break
        default:
            break
        }
    }
    

    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReclassifySegue" {
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.allItemStore = allItemStore
            if itemType == "To Do" {
                destinationVC.reclassifiedToDo = toDo
            }
            else if itemType == "Next Action" {
                destinationVC.reclassifiedNextAction = nextAction
       
            }
            else if itemType == "Project" {
                destinationVC.reclassifiedProject = project
            }
        }
        else if segue.identifier == "RelatedToSegue" {
            let destinationVC = segue.destination as! RelatedToViewController
            
            destinationVC.allItemStore = allItemStore
            destinationVC.nextAction = nextAction
            destinationVC.project = project
            destinationVC.addSegue = false
            destinationVC.itemType = itemType
        }
    }

    func datePickerTapped(gestureRecognizer: UITapGestureRecognizer) {
        if dueDatePicker.isHidden == true {
            dueDatePicker.isHidden = false
            dueDateFullDateLabel.isHidden = true
        }
        else if dueDatePicker.isHidden == false {
            dueDateFullDateLabel.text = dateFormatter.string(from: dueDatePicker.date)
            dueDatePicker.isHidden = true
            dueDateFullDateLabel.isHidden = false
        }
        else {
            return
        }
    }


}
