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
    
       // Create enum for itemType instead of string
    let pickerData = ["Choose an Option", "To Do", "Next Action", "Project", "Review", "Context"]
    var itemType: String = ""
    var reclassifiedToDo: ToDo?
    var reclassifiedNextAction: NextAction?
    var reclassifiedProject: Project?
    var relatedToNextActionsArray: [NextAction] = []
    var relatedToProjectsArray: [Project] = []
    var relatedToContextArray: [Context] = []
    var allItemStore: AllItemStore!
    
    // Make screensize orthogonal?
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
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        print(durationSliderWidthConstraint.constant)
        
        
        prioritySliderWidthConstraint.constant = (screenSize.width)/2
        durationSliderWidthConstraint.constant = (screenSize.width)/2
        
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
        

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(relatedToProjectsArray)
        
        
        if itemType == "" {
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
        }
        
        
        // Rework reclassified object so I don't have initially unwrap stuff****
        if reclassifiedToDo != nil {
            titleTextField.text = reclassifiedToDo?.name
            notesTextView.text = reclassifiedToDo?.details
            
        }
        else if reclassifiedNextAction != nil{
            titleTextField.text = reclassifiedNextAction?.name
            notesTextView.text = reclassifiedNextAction?.details
            prioritySlider.value = (reclassifiedNextAction?.priority)!
            durationSlider.value = (reclassifiedNextAction?.processingtime)!
            dueDatePicker.date = (reclassifiedNextAction?.duedate)! as Date
            
        }
        
        // Reclassify other objects
    }


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        itemType = pickerData[row]
        print(itemType)
        updateForm()
    }
    
    
    //Change name of func to formatPage()
    func updateForm() {
        
        let newScreenSize = UIScreen.main.bounds
        screenSize = newScreenSize
        
        switch itemType {
        case "Choose an Option":
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
            break
        case "To Do":
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
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            
            if UIDevice.current.orientation.isLandscape {
                
                notesTextViewHeightConstraint.constant = (screenSize.height)/3
            } else {
                notesTextViewHeightConstraint.constant = (screenSize.height)/2
            }
            
            break
        case "Next Action":
            titleLabel.isHidden = false
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
            
            // Localize units of time for other countries
            
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
        case "Project":
            titleLabel.isHidden = false
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
            
            if UIDevice.current.orientation.isLandscape {
                notesTextViewHeightConstraint.constant = (screenSize.height)/4
                dueDatePickerHeightConstraint.constant = (screenSize.height)/5
            } else {
                notesTextViewHeightConstraint.constant = (screenSize.height)/3
                dueDatePickerHeightConstraint.constant = (screenSize.height)/4
            }
            
            break
        case "Review":
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
            relatedToButton.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            
            if UIDevice.current.orientation.isLandscape {
                
                notesTextViewHeightConstraint.constant = (screenSize.height)/3
            } else {
                notesTextViewHeightConstraint.constant = (screenSize.height)/2
            }
            
            break
        case "Context":
            titleLabel.isHidden = false
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
        default:
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
            break
        }
    }
    
    func createItem() {
        if titleTextField.text != "" {
        switch itemType {
        case "Choose an Options":
            return
        case "To Do":
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
        case "Next Action":
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
        case "Project":
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
        case "Review":
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
        case "Context":
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
    
    func createCalendarEvent(forItem item: String, forDate date: Date) {
        
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = "\(self.itemType) Due: \(item)"
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
            
            // Will readd reclassify feature if necessary
            if reclassifiedNextAction != nil {
                destinationVC.nextAction = reclassifiedNextAction
            } else if reclassifiedProject != nil {
                destinationVC.project = reclassifiedProject
            }
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}

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

