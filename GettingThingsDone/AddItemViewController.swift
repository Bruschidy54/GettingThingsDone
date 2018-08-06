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
    @IBOutlet var fullStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var fullStackView: UIStackView!
    @IBOutlet var pickerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var notesStackView: UIStackView!
    
    let pickerData = ["Choose an Option", "To Do", "Next Action", "Project", "Review", "Context"]
    var itemType: ItemType = .none
    var reclassifiedToDo: ToDo?
    var reclassifiedNextAction: NextAction?
    var reclassifiedProject: Project?
    var relatedToNextActionsArray: [NextAction] = []
    var relatedToProjectsArray: [Project] = []
    var relatedToContextArray: [Context] = []
    var notesTextViewIsEditing: Bool = false
    var screenSize: CGRect = UIScreen.main.bounds
    
    
    
    
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onDoneButtonTapped(_ sender: Any) {
        
        createItem()
        if titleTextField.text != "" {
            
            if reclassifiedToDo != nil {
                guard let id = reclassifiedToDo?.id else { return }
                
                // Delete To Do from Core Data
                do  {
                    try AllItemStore.shared.deleteToDo(id: id)
                } catch {
                    print("Error deleting To Do: \(error)")
                }
                self.navigationController?.popToRootViewController(animated: true)
                
            }
                
                //            // Integrate reclassified next actions and projects in a later patch
                //        else if reclassifiedNextAction != nil {
                //            let id = reclassifiedNextAction?.id
                //            do  {
                //                try allItemStore.deleteNextAction(id: id!)
                //            } catch {
                //                print("Error deleting Next Action: \(error)")
                //            }
                //            self.navigationController?.popToRootViewController(animated: true)
                //        } else if reclassifiedProject != nil {
                //            let id = reclassifiedProject?.id
                //            do {
                //                try allItemStore.deleteProject(id: id!)
                //            } catch {
                //                print("Error deleting Project: \(error)")
                //            }
                //            self.navigationController?.popToRootViewController(animated: true)
                //        }
                
            else {
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            switch itemType {
            case .chooseAnOption, .none, .toDo:
                self.navigationController?.tabBarController?.selectedIndex = 0
            case .nextAction, .context:
                self.navigationController?.tabBarController?.selectedIndex = 1
            case .project, .review:
                self.navigationController?.tabBarController?.selectedIndex = 2
            }
        }
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        
        view.endEditing(true)
    }
    
    @IBAction func onPrioritySliderSlid(_ sender: Any) {
        let sliderValue = (sender as! UISlider).value
        
        let newValue = Int(sliderValue/20) * 20
        (sender as! UISlider).setValue(Float(newValue), animated: false)
        
       setPrioritySliderLabel(for: Double(newValue))
        
    }
    
    @IBAction func onDurationSliderSlid(_ sender: Any) {
        let sliderValue = (sender as! UISlider).value
        
        // Round value to step
        let newValue = Int(sliderValue/20) * 20
        (sender as! UISlider).setValue(Float(newValue), animated: false)
        
        setDurationSliderLabel(for: Double(newValue))
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        setupUI()
        
        updateConstraintsForOrientation()
        
        updateForm()
        
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
        
        let point = CGPoint(x: 0, y: 0)
                    screenSize = CGRect(origin: point, size: size)
        updateConstraintsForOrientation()
        
    }
    
    private func setPrioritySliderLabel(for value: Double) {
        switch value {
        case 0:
            self.priorityLevelLabel.text = "Very Low"
        case 20:
            self.priorityLevelLabel.text = "Low"
        case 40:
            self.priorityLevelLabel.text = "Medium"
        case 60:
            self.priorityLevelLabel.text = "High"
        case 80:
            self.priorityLevelLabel.text = "Very High"
        case 100:
            self.priorityLevelLabel.text = "Highest"
        default:
            self.priorityLevelLabel.text = "Highest"
        }
    }
    
    private func setDurationSliderLabel(for value: Double) {
        switch value {
        case 0:
            self.durationLevelLabel.text = "<2 Min"
        case 20:
            self.durationLevelLabel.text = "<30 Min"
        case 40:
            self.durationLevelLabel.text = "<2 Hr"
        case 60:
            self.durationLevelLabel.text = "<4 Hr"
        case 80:
            self.durationLevelLabel.text = "<8 Hr"
        case 100:
            self.durationLevelLabel.text = ">8 Hr"
        default:
            self.durationLevelLabel.text = ">8 Hr"
        }
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem?.tintColor = .themeOrange
        navigationItem.rightBarButtonItem?.tintColor = .themeOrange
        
        titleLabel.font = UIFont(name: "GillSans-SemiBold", size: 13)
        notesLabel.font = UIFont(name: "GillSans-SemiBold", size: 13)
        priorityLabel.font = UIFont(name: "GillSans-SemiBold", size: 11)
        durationLabel.font = UIFont(name: "GillSans-SemiBold", size: 11)
        dueDateLabel.font = UIFont(name: "GillSans-SemiBold", size: 13)
        priorityLevelLabel.font = UIFont(name: "GillSans", size: 15)
        durationLevelLabel.font = UIFont(name: "GillSans", size: 15)
        
        relatedToButton.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 17)
        
        
        dueDatePicker.setValue(UIColor.darkGray, forKeyPath: "textColor")
        
        self.dueDatePicker.datePickerMode = .date
        
        pickerView.delegate = self
        pickerView.dataSource = self
        notesTextView.delegate = self
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    private func updateConstraintsForOrientation() {
        // Set UI horizontal constraints proportional to screen width
        prioritySliderWidthConstraint.constant = (screenSize.width * 15)/30
        durationSliderWidthConstraint.constant = (screenSize.width * 15)/30
        titleTextFieldWidthConstraint.constant = (screenSize.width * 22)/30
        priorityLevelLabelWidthContraint.constant = (screenSize.width * 7)/30
        durationLevelLabelWidthConstraint.constant = (screenSize.width * 7)/30
        
        
        // Adjust vertical constraint proporations based on device orientation
        if UIDevice.current.orientation.isLandscape {
            
            itemTypePickerHeightConstraint.constant = (screenSize.height)/5
            dueDatePickerHeightConstraint.constant = (screenSize.height)/6
            notesTextViewHeightConstraint.constant = (screenSize.height)/2
        }
        else {
            
            itemTypePickerHeightConstraint.constant = (screenSize.height)/4
            dueDatePickerHeightConstraint.constant = (screenSize.height)/5
            notesTextViewHeightConstraint.constant = (screenSize.height * 5)/12
        }
        
        switch itemType {
        case .toDo, .review:
            if UIDevice.current.orientation.isLandscape {
                
                notesTextViewHeightConstraint.constant = (screenSize.height)/3
            } else {
                notesTextViewHeightConstraint.constant = (screenSize.height * 5)/12
            }
        case .nextAction:
            if UIDevice.current.orientation.isLandscape {
                dueDatePickerHeightConstraint.constant = (screenSize.height)/7
                notesTextViewHeightConstraint.constant = (screenSize.height)/7
            } else {
                dueDatePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = (screenSize.height)/6
            }
        case .project:
            notesTextViewHeightConstraint.constant = (screenSize.height)/4
            dueDatePickerHeightConstraint.constant = (screenSize.height)/6
        default:
            break
        }
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
        
        updateConstraintsForOrientation()
        
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
            titleLabel.text = "To Do"
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
            
            
            break
        case .nextAction:
            titleLabel.isHidden = false
            titleLabel.text = "Action"
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
            
            
            setPrioritySliderLabel(for: Double(prioritySlider.value))
            
            setDurationSliderLabel(for: Double(durationSlider.value))
            
            
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
            notesTextViewHeightConstraint.constant = (screenSize.height)/4
            dueDatePickerHeightConstraint.constant = (screenSize.height)/6
            
            break
        case .review:
            titleLabel.isHidden = false
            titleLabel.text = "Wins"
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
                let context = AllItemStore.shared.coreDataStack.mainQueueContext
                let newToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
                newToDo.setValue(toDoTitle, forKey: "name")
                newToDo.setValue(toDoNotes, forKey: "details")
                
                do {
                    try AllItemStore.shared.coreDataStack.saveChanges()
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
                
                createCalendarEvent(forItem: title, forDate: date, with: notes)
                let context = AllItemStore.shared.coreDataStack.mainQueueContext
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
                    try AllItemStore.shared.coreDataStack.saveChanges()
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
                createCalendarEvent(forItem: title, forDate: date, with: notes)
                let context = AllItemStore.shared.coreDataStack.mainQueueContext
                let newProject = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context)
                newProject.setValue(title, forKey: "name")
                newProject.setValue(date, forKey: "duedate")
                newProject.setValue(notes, forKey: "details")
                let nextActions = newProject.mutableSetValue(forKey: "nextActions")
                for nextAction in relatedToNextActionsArray {
                    nextActions.add(nextAction)
                }
                do {
                    try AllItemStore.shared.coreDataStack.saveChanges()
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
                
                let context = AllItemStore.shared.coreDataStack.mainQueueContext
                let newReview = NSEntityDescription.insertNewObject(forEntityName: "Review", into: context)
                newReview.setValue(title, forKey: "name")
                newReview.setValue(notes, forKey: "details")
                
                do {
                    try AllItemStore.shared.coreDataStack.saveChanges()
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
                let context = AllItemStore.shared.coreDataStack.mainQueueContext
                let newContext = NSEntityDescription.insertNewObject(forEntityName: "Context", into: context)
                newContext.setValue(title, forKey: "name")
                
                do {
                    try AllItemStore.shared.coreDataStack.saveChanges()
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
            
            ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(ac, animated: true, completion: nil)
        }
    }
    
    // MARK: - TextField/TextView Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.notesTextViewIsEditing = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.notesTextViewIsEditing = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
        notesTextView.resignFirstResponder()
        self.view.layoutIfNeeded()
        var notesTextViewHeight: CGFloat = 0
        
        switch itemType {
        case .chooseAnOption, .context, .toDo, .review:
            notesTextViewHeight = (screenSize.height * 5)/12
        case .nextAction:
            if UIDevice.current.orientation.isLandscape {
                notesTextViewHeight = screenSize.height/7
            } else {
                notesTextViewHeight = screenSize.height/6
            }
        case .project:
            notesTextViewHeight = screenSize.height/4
        default:
            break
        }
        
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: { self.pickerViewTopConstraint.constant = 0
            self.notesTextViewHeightConstraint.constant = notesTextViewHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if notesTextViewIsEditing {
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                
                let targetOffsetForTopConstraint = 8 - (pickerView.frame.height + notesStackView.frame.origin.y)
                let targetOffsetForNotesTextViewHeight = screenSize.height - 100 - keyboardHeight
                
                self.view.layoutIfNeeded()
                
                 UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                    self.pickerViewTopConstraint.constant = targetOffsetForTopConstraint
                    self.notesTextViewHeightConstraint.constant = targetOffsetForNotesTextViewHeight
                    self.view.layoutIfNeeded()
                 }, completion: nil)
            }
        }
    }
    
    // MARK: - Calendar method
    func createCalendarEvent(forItem item: String, forDate date: Date, with notes: String) {
        
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if (granted) && (error == nil) {
                
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
                event.notes = notes
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
                print("Failed to save event with error: \(error?.localizedDescription ?? "") or access not granted")
            }
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RelatedToSegue" {
            let destinationVC = segue.destination as! RelatedToViewController
            destinationVC.addSegue = true
            destinationVC.itemType = itemType
            destinationVC.delegate = self
        }
    }
    
}



