//
//  AddItemViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/10/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var prioritySlider: UISlider!
    @IBOutlet var durationSlider: UISlider!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var relatedToButton: UIButton!
    @IBOutlet var priorityLevelLabel: UILabel!
    @IBOutlet var durationLevelLabel: UILabel!
    @IBOutlet var itemTypePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var notesTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var dueDatePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var prioritySliderWidthConstraint: NSLayoutConstraint!
    @IBOutlet var durationSliderWidthConstraint: NSLayoutConstraint!
    @IBOutlet var titleTextFieldWidthConstraint: NSLayoutConstraint!
    @IBOutlet var priorityLevelLabelWidthContraint: NSLayoutConstraint!
    @IBOutlet var durationLevelLabelWidthConstraint: NSLayoutConstraint!
    
    let pickerData = ["Choose an Option", "To Do", "Next Action", "Project", "Review", "Context"]
    var itemType: ItemType = .none
    var reclassifiedToDo: ToDo?
    var reclassifiedNextAction: NextAction?
    var reclassifiedProject: Project?
    var relatedToNextActionsArray: [NextAction] = []
    var relatedToProjectsArray: [Project] = []
    var relatedToContextArray: [Context] = []
    var allItemStore: AllItemStore!
    
    var screenSize: CGRect = UIScreen.main.bounds
    
    
    
    
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onDoneButtonTapped(_ sender: Any) {
        createItem()
        
        if reclassifiedToDo != nil {
            let id = reclassifiedToDo?.id
            do  {
                try allItemStore.deleteToDo(id: id!)
            } catch {
                print("Error deleting To Do: \(error)")
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
            
            // Integrate reclassified next actions and projects in a later patch
        else if reclassifiedNextAction != nil {
            let id = reclassifiedNextAction?.id
            do  {
                try allItemStore.deleteNextAction(id: id!)
            } catch {
                print("Error deleting Next Action: \(error)")
            }
            self.navigationController?.popToRootViewController(animated: true)
        } else if reclassifiedProject != nil {
            let id = reclassifiedProject?.id
            do {
                try allItemStore.deleteProject(id: id!)
            } catch {
                print("Error deleting Project: \(error)")
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
            
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        
        view.endEditing(true)
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        relatedToButton.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 17)
        

        dueDatePicker.setValue(UIColor.darkGray, forKeyPath: "textColor")
        
        self.dueDatePicker.datePickerMode = .date
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        // Set UI horizontal constraints proportional to screen width
        prioritySliderWidthConstraint.constant = (screenSize.width * 11)/30
        durationSliderWidthConstraint.constant = (screenSize.width * 11)/30
        titleTextFieldWidthConstraint.constant = (screenSize.width * 19)/30
        priorityLevelLabelWidthContraint.constant = (screenSize.width * 7)/30
        durationLevelLabelWidthConstraint.constant = (screenSize.width * 7)/30
        
        
        // Adjust vertical constraint proporations based on device orientation
        if UIDevice.current.orientation.isLandscape {
            
            itemTypePickerHeightConstraint.constant = (screenSize.height)/6
            dueDatePickerHeightConstraint.constant = (screenSize.height)/6
            notesTextViewHeightConstraint.constant = (screenSize.height)/5
        }
        else {
            
            itemTypePickerHeightConstraint.constant = (screenSize.height)/5
            dueDatePickerHeightConstraint.constant = (screenSize.height)/5
            notesTextViewHeightConstraint.constant = (screenSize.height)/4
        }
        
        updateForm()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if itemType == .none {
            titleLabel.isHidden = true
            titleTextField.isHidden = true
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = true
            notesTextView.isHidden = true
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
        }
        
        

        if let toDo = reclassifiedToDo {
            titleTextField.text = toDo.name
            notesTextView.text = toDo.details
            
        }
        
    }

    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Update constraints based on device orientation changes
        if UIDevice.current.orientation.isLandscape {
            let point = CGPoint(x: 0, y: 0)
            screenSize = CGRect(origin: point, size: size)
            itemTypePickerHeightConstraint.constant = (screenSize.height)/6
            notesTextViewHeightConstraint.constant = (screenSize.height)/5
            dueDatePickerHeightConstraint.constant = (screenSize.height)/6
            prioritySliderWidthConstraint.constant = (screenSize.width)/2
            durationSliderWidthConstraint.constant = (screenSize.width)/2
        } else {
            let point = CGPoint(x: 0, y: 0)
            screenSize = CGRect(origin: point, size: size)
            itemTypePickerHeightConstraint.constant = (screenSize.height)/5
            notesTextViewHeightConstraint.constant = (screenSize.height)/4
            dueDatePickerHeightConstraint.constant = (screenSize.height)/5
            prioritySliderWidthConstraint.constant = (screenSize.width)/2
            durationSliderWidthConstraint.constant = (screenSize.width)/2
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - PickerView Delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
        
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerData[row]
        let attributedTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
        return attributedTitle
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let pickerSelection = pickerData[row]
        
        switch pickerSelection {
        case "Choose an Option":
            itemType = .chooseAnOption
            break
        case "To Do":
            itemType = .toDo
            break
        case "Next Action":
            itemType = .nextAction
            break
        case "Project":
            itemType = .project
            break
        case "Review":
            itemType = .review
            break
        case "Context":
            itemType = .context
            break
        default:
            break
        }
        
        updateForm()
    }
    
    func updateForm() {
        
        let newScreenSize = UIScreen.main.bounds
        screenSize = newScreenSize
        
        switch itemType {
        case .none:
            titleLabel.isHidden = true
            titleTextField.isHidden = true
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = true
            notesTextView.isHidden = true
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            notesLabel.text = "Notes"
            break
        case .chooseAnOption:
            titleLabel.isHidden = true
            titleTextField.isHidden = true
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = true
            notesTextView.isHidden = true
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            notesLabel.text = "Notes"
            break
        case .toDo:
            titleLabel.isHidden = false
            titleLabel.text = "What's on my mind?"
            titleTextField.isHidden = false
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            notesLabel.text = "Notes"
            
            if UIDevice.current.orientation.isLandscape {
                
                notesTextViewHeightConstraint.constant = (screenSize.height)/3
            } else {
                notesTextViewHeightConstraint.constant = (screenSize.height)/2
            }
            
            break
        case .nextAction:
            titleLabel.isHidden = false
            titleLabel.text = "Action to take"
            titleTextField.isHidden = false
            priorityLabel.isHidden = false
            prioritySlider.isHidden = false
            durationLabel.isHidden = false
            durationSlider.isHidden = false
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = false
            dueDatePicker.isHidden = false
            relatedToButton.isHidden = false
            priorityLevelLabel.isHidden = false
            durationLevelLabel.isHidden = false
            notesLabel.text = "How I know I'm done"
            
            if UIDevice.current.orientation.isLandscape {
                notesTextViewHeightConstraint.constant = (screenSize.height)/5
                dueDatePickerHeightConstraint.constant = (screenSize.height)/6
            } else {
                notesTextViewHeightConstraint.constant = (screenSize.height)/4
                dueDatePickerHeightConstraint.constant = (screenSize.height)/5
            }
            
            if Double(prioritySlider.value) >= 0 && Double(prioritySlider.value) < 0.2 {
                self.priorityLevelLabel.text = "Very Low"
            }
            else if Double(prioritySlider.value) >= 0.2 && Double(prioritySlider.value) < 0.4 {
                
                self.priorityLevelLabel.text = "Low"
                
            } else if Double(prioritySlider.value) >= 0.4 && Double(prioritySlider.value) < 0.6{
                
                self.priorityLevelLabel.text = "Medium"
                
            } else if Double(prioritySlider.value) >= 0.6 && Double(prioritySlider.value) < 0.8 {
                
                self.priorityLevelLabel.text = "High"
                
            } else if Double(prioritySlider.value) >= 0.8 && Double(prioritySlider.value) < 1 {
                
                self.priorityLevelLabel.text = "Very High"
                
            }
            
            
            if Double(durationSlider.value) == 0 {
                
                self.durationLevelLabel.text = "<2 Min"
                
            }else if Double(durationSlider.value) > 0 && Double(durationSlider.value) < 0.2  {
                
                self.durationLevelLabel.text = "<15 Min"
                
            } else if Double(durationSlider.value) > 0.2 && Double(durationSlider.value) < 0.4  {
                
                self.durationLevelLabel.text = "<1 Hr"
                
            } else if Double(durationSlider.value) > 0.4 && Double(durationSlider.value) < 0.6  {
                
                self.durationLevelLabel.text = "<2 Hr"
                
            } else if Double(durationSlider.value) > 0.6 && Double(durationSlider.value) < 0.8  {
                
                self.durationLevelLabel.text = "<4 Hr"
                
            } else if Double(durationSlider.value) > 0.8 && Double(durationSlider.value) < 1  {
                
                self.durationLevelLabel.text = "<8 Hr"
                
            } else if Double(durationSlider.value) == 1 {
                
                self.durationLevelLabel.text = ">8 Hr"
                
            }
            
            break
        case .project:
            titleLabel.isHidden = false
            titleLabel.text = "Project"
            titleTextField.isHidden = false
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = false
            dueDatePicker.isHidden = false
            relatedToButton.isHidden = false
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            notesLabel.text = "Planning"
            
            if UIDevice.current.orientation.isLandscape {
                notesTextViewHeightConstraint.constant = (screenSize.height)/4
                dueDatePickerHeightConstraint.constant = (screenSize.height)/5
            } else {
                notesTextViewHeightConstraint.constant = (screenSize.height)/3
                dueDatePickerHeightConstraint.constant = (screenSize.height)/5
            }
            
            break
        case .review:
            titleLabel.isHidden = false
            titleLabel.text = "What I've accomplished"
            titleTextField.isHidden = false
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            notesLabel.text = "How can I improve?"
            
            if UIDevice.current.orientation.isLandscape {
                
                notesTextViewHeightConstraint.constant = (screenSize.height)/3
            } else {
                notesTextViewHeightConstraint.constant = (screenSize.height)/2
            }
            
            break
        case .context:
            titleLabel.isHidden = false
            titleLabel.text = "Context"
            titleTextField.isHidden = false
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = true
            notesTextView.isHidden = true
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            notesLabel.text = "Notes"
            break
        default:
            titleLabel.isHidden = true
            titleLabel.text = "Title"
            titleTextField.isHidden = true
            priorityLabel.isHidden = true
            prioritySlider.isHidden = true
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = true
            notesTextView.isHidden = true
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            notesLabel.text = "Notes"
            break
        }
    }
    
    func createItem() {
        if titleTextField.text != "" || itemType == .chooseAnOption {
            switch itemType {
            case .chooseAnOption:
                return
            case .toDo:
                guard let toDoTitle = titleTextField.text, let toDoNotes = notesTextView.text else {
                    print("Error: Title and/or notes came back as nil")
                    return
                }
                let context = self.allItemStore.coreDataStack.mainQueueContext
                let newToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
                newToDo.setValue(toDoTitle, forKey: "name")
                newToDo.setValue(toDoNotes, forKey: "details")
                
                do {
                    try self.allItemStore?.coreDataStack.saveChanges()
                    print("Save Complete")
                }
                catch let error {
                    print("Core data save failed: \(error)")
                }
                
                break
            case .nextAction:
                guard let title = titleTextField.text, let notes = notesTextView.text else {
                    print("Error: Title and/or notes came back as nil")
                    return
                }
                let priority = prioritySlider.value
                let duration = durationSlider.value
                let date = dueDatePicker.date
                
                createCalendarEvent(forItem: title, forDate: date)
                let context = self.allItemStore.coreDataStack.mainQueueContext
                let newNextAction = NSEntityDescription.insertNewObject(forEntityName: "NextAction", into: context)
                newNextAction.setValue(title, forKey: "name")
                newNextAction.setValue(priority, forKey: "priority")
                newNextAction.setValue(duration, forKey: "processingtime")
                newNextAction.setValue(date, forKey: "duedate")
                newNextAction.setValue(notes, forKey: "details")
                newNextAction.setValue(NSSet(array: relatedToProjectsArray), forKey: "projects")
                if relatedToProjectsArray.isEmpty {
                    newNextAction.setValue(false, forKey: "projectSorted")
                } else {
                    newNextAction.setValue(true, forKey: "projectSorted")
                }
                newNextAction.setValue(NSSet(array: relatedToContextArray), forKey: "contexts")
                if relatedToContextArray.isEmpty {
                    newNextAction.setValue(false, forKey: "contextSorted")
                } else {
                    newNextAction.setValue(true, forKey: "contextSorted")
                }
                
                do {
                    try self.allItemStore.coreDataStack.saveChanges()
                    print("Save Complete")
                }
                catch let error {
                    print("Core data save failed: \(error)")
                }
                
                break
            case .project:
                guard let title = titleTextField.text, let notes = notesTextView.text else {
                    print("Error: Title and/or notes came back as nil")
                    return
                }
                let date = dueDatePicker.date
                createCalendarEvent(forItem: title, forDate: date)
                let context = self.allItemStore.coreDataStack.mainQueueContext
                let newProject = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context)
                newProject.setValue(title, forKey: "name")
                newProject.setValue(date, forKey: "duedate")
                newProject.setValue(notes, forKey: "details")
                let nextActions = newProject.mutableSetValue(forKey: "nextActions")
                for nextAction in relatedToNextActionsArray {
                    nextActions.add(nextAction)
                }
                do {
                    try self.allItemStore.coreDataStack.saveChanges()
                    print("Save Complete")
                }
                catch let error {
                    print("Core data save failed: \(error)")
                }
                break
            case .review:
                guard let title = titleTextField.text, let notes = notesTextView.text else {
                    print("Error: Title and/or notes came back as nil")
                    return
                }
                
                let context = self.allItemStore.coreDataStack.mainQueueContext
                let newReview = NSEntityDescription.insertNewObject(forEntityName: "Review", into: context)
                newReview.setValue(title, forKey: "name")
                newReview.setValue(notes, forKey: "details")
                
                do {
                    try self.allItemStore.coreDataStack.saveChanges()
                    print("Save Complete")
                }
                catch let error {
                    print("Core data save failed: \(error)")
                }
                break
            case .context:
                guard let title = titleTextField.text else {
                    print("Error: Title and/or notes came back as nil")
                    return
                }
                let context = self.allItemStore.coreDataStack.mainQueueContext
                let newContext = NSEntityDescription.insertNewObject(forEntityName: "Context", into: context)
                newContext.setValue(title, forKey: "name")
                
                do {
                    try self.allItemStore.coreDataStack.saveChanges()
                    print("Save Complete")
                }
                catch let error {
                    print("Core data save failed: \(error)")
                }
                break
                
            default:
                break
            }
        }
        else {
            let title = "Item not created"
            let message = "Please enter a title and resubmit"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            present(ac, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Calendar method
    func createCalendarEvent(forItem item: String, forDate date: Date) {
        
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                switch self.itemType {
                case .nextAction:
                    event.title = "Next Action Due: \(item)"
                    break
                case .project:
                    event.title = "Project Due: \(item)"
                    break
                default:
                    event.title = "Item Due: \(item)"
                    break
                }
                event.notes = self.notesTextView.text
                event.isAllDay = true
                event.startDate = date
                event.endDate = date
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            } else {
                print("Failed to save event with error: \(error) or access not granted")
            }
        })
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RelatedToSegue" {
            let destinationVC = segue.destination as! RelatedToViewController
            destinationVC.addSegue = true
            destinationVC.itemType = itemType
            destinationVC.allItemStore = allItemStore
            destinationVC.delegate = self
            
            
            
        }
    }
    
    
    
}

// Use custom delegation to send relationships information from relatedToVC to AddItemVC
extension AddItemViewController: RelatedToViewControllerDelegate {
    func didUpdateRelatedTo(sender: RelatedToViewController) {
        if sender.relatedToNextActionsArray != nil {
            self.relatedToNextActionsArray = sender.relatedToNextActionsArray!
        }else {
            self.relatedToNextActionsArray = []
        }
        
        if sender.relatedToProjectsArray != nil {
            self.relatedToProjectsArray = sender.relatedToProjectsArray!
        }
        else {
            self.relatedToProjectsArray = []
        }
        
        
        if sender.relatedToContextArray != nil {
            self.relatedToContextArray = sender.relatedToContextArray!
        }
        else {
            self.relatedToContextArray = []
        }
    }
}

