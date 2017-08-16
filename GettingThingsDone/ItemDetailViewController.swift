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
    @IBOutlet var titleTextFieldWidthConstraint: NSLayoutConstraint!
    @IBOutlet var priorityLevelLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet var durationLevelLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet var fullStackViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var fullStackViewTopConstaint: NSLayoutConstraint!
    @IBOutlet var titleStackView: UIStackView!
    @IBOutlet var outerStackView: UIStackView!
    @IBOutlet var notesStackView: UIStackView!
    @IBOutlet var buttonStackView: UIStackView!
    
    
    // Create enum for itemType instead of string
    
    var toDo: ToDo?
    var project: Project?
    var review: Review?
    var itemType: ItemType = .nextAction
    var nextAction: NextAction?
    var allItemStore: AllItemStore!
    var screenSize: CGRect = UIScreen.main.bounds
    var notesTextViewIsEditing: Bool = false
    
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
        
        
        // Set the priority level label
        let sliderValue = (sender as! UISlider).value
        
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
        
        
        // Set the duration level label
        let sliderValue = (sender as! UISlider).value
        
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
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        titleLabel.font = UIFont(name: "GillSans-SemiBold", size: 13)
        priorityLabel.font = UIFont(name: "GillSans-SemiBold", size: 11)
        durationLabel.font = UIFont(name: "GillSans-SemiBold", size: 10)
        dueDateLabel.font = UIFont(name: "GillSans-SemiBold", size: 13)
        priorityLevelLabel.font = UIFont(name: "GillSans", size: 15)
        durationLevelLabel.font = UIFont(name: "GillSans", size: 15)
        relatedToButton.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 17)
        classifyButton.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 17)
        notesLabel.font = UIFont(name: "GillSans-SemiBold", size: 13)
        
        
        self.dueDatePicker.datePickerMode = .date
        
        dueDatePicker.setValue(UIColor.darkGray, forKeyPath: "textColor")
        
        self.tabBarController?.tabBar.isHidden = true
        
        // Adjust the horizaontal contraints for UI
        prioritySliderConstraint.constant = (screenSize.width * 15)/30
        durationSliderContraint.constant = (screenSize.width * 15)/30
        titleTextFieldWidthConstraint.constant = (screenSize.width * 22)/30
        priorityLevelLabelWidthConstraint.constant = (screenSize.width * 7)/30
        durationLevelLabelWidthConstraint.constant =  (screenSize.width * 7)/30
        datePickerHeightConstraint.constant = (screenSize.height)/6
        
        
        formatPage()
        
        //  Tap gesture to switch between full date label and date picker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.datePickerTapped(gestureRecognizer:)))
        datePickerStackView.addGestureRecognizer(tapGesture)
        
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Adjust UI size constraints based on orientation
        if UIDevice.current.orientation.isLandscape {
            let point = CGPoint(x: 0, y: 0)
            screenSize = CGRect(origin: point, size: size)
            switch itemType {
            case .toDo, .review:
                notesTextViewHeightConstraint.constant = (screenSize.height/2)
                break
            case .nextAction:
                notesTextViewHeightConstraint.constant = (screenSize.height/3)
                durationLevelLabelWidthConstraint.constant =  (screenSize.width * 7)/30
                priorityLevelLabelWidthConstraint.constant = (screenSize.width * 7)/30
                datePickerHeightConstraint.constant = (screenSize.height)/6
                prioritySliderConstraint.constant = (screenSize.width)/2
                durationSliderContraint.constant = (screenSize.width)/2
                break
            case .project:
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = 2 * (screenSize.height/5)
                break
            default:
                break
            }
            titleTextFieldWidthConstraint.constant = (screenSize.width * 22)/30
        } else {
            let point = CGPoint(x: 0, y: 0)
            screenSize = CGRect(origin: point, size: size)
            switch itemType {
            case .toDo, .review:
                notesTextViewHeightConstraint.constant = (screenSize.height/2)
                break
            case .nextAction:
                notesTextViewHeightConstraint.constant = 2 * (screenSize.height/5)
                prioritySliderConstraint.constant = (screenSize.width * 15)/30
                durationSliderContraint.constant = (screenSize.width * 15)/30
                priorityLevelLabelWidthConstraint.constant = (screenSize.width * 7)/30
                durationLevelLabelWidthConstraint.constant =  (screenSize.width * 7)/30
                datePickerHeightConstraint.constant = (screenSize.height)/6
                break
            case .project:
                notesTextViewHeightConstraint.constant = (screenSize.height/2)
                datePickerHeightConstraint.constant = (screenSize.height)/6
                break
            default:
                break
            }
            titleTextFieldWidthConstraint.constant = (screenSize.width * 22)/30
        }
    }
    
    
    func formatPage() {
        let newScreenSize = UIScreen.main.bounds
        screenSize = newScreenSize
        
        switch itemType {
        case .toDo:
            self.navigationItem.title = toDo?.name
            titleTextField.text = toDo?.name
            notesTextView.text = toDo?.details
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
            dueDateFullDateLabel.isHidden = true
            relatedToButton.isHidden = true
            dueDatePicker.isHidden = true
            priorityLevelLabel.isHidden = true
            durationLevelLabel.isHidden = true
            notesLabel.text = "Notes"
            
            notesTextViewHeightConstraint.constant = (screenSize.height/2)
            
            break
        case .nextAction:
            self.navigationItem.title = nextAction?.name
            titleLabel.text = "Action"
            titleTextField.text = nextAction?.name
            notesTextView.text = nextAction?.details
            prioritySlider.value = (nextAction?.priority)!
            durationSlider.value = (nextAction?.processingtime)!
            dueDateFullDateLabel.text = dateFormatter.string(from: nextAction?.duedate as! Date)
            if (nextAction?.duedate! as! Date) < Date() {
                dueDateFullDateLabel.textColor = UIColor.red
            } else {
                dueDateFullDateLabel.textColor = UIColor.darkGray
            }
            dueDatePicker.date = nextAction?.duedate as! Date
            notesLabel.text = "How I know I'm done"
            
            if UIDevice.current.orientation.isLandscape {
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = (screenSize.height/3)
            } else {
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = 2 * (screenSize.height/5)
            }
            
            if Double((nextAction?.priority)!) >= 0 && Double((nextAction?.priority)!) < 0.2 {
                
                self.priorityLevelLabel.text = "Very Low"
                
            } else if Double((nextAction?.priority)!) >= 0.2 && Double((nextAction?.priority)!) < 0.4 {
                
                self.priorityLevelLabel.text = "Low"
                
            } else if Double((nextAction?.priority)!) >= 0.4 && Double((nextAction?.priority)!) < 0.6 {
                
                self.priorityLevelLabel.text = "Medium"
                
            } else if Double((nextAction?.priority)!) >= 0.6 && Double((nextAction?.priority)!) < 0.8 {
                
                self.priorityLevelLabel.text = "High"
                
            } else if Double((nextAction?.priority)!) >= 0.8 && Double((nextAction?.priority)!) <= 1 {
                
                self.priorityLevelLabel.text = "Very High"
                
            }
            
            
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
        case .project:
            self.navigationItem.title = project?.name
            titleLabel.text = "Project"
            titleTextField.text = project?.name
            notesTextView.text = project?.details
            dueDateFullDateLabel.text = dateFormatter.string(from: project?.duedate as! Date)
            if (project?.duedate! as! Date) < Date() {
                dueDateFullDateLabel.textColor = UIColor.red
            } else {
                dueDateFullDateLabel.textColor = UIColor.darkGray
            }
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
            notesLabel.text = "Planning"
            
            if UIDevice.current.orientation.isLandscape {
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = 2 * (screenSize.height/5)
            } else {
                datePickerHeightConstraint.constant = (screenSize.height)/6
                notesTextViewHeightConstraint.constant = (screenSize.height/2)
            }
            break
        case .review:
            self.navigationItem.title = "Review Your Progress"
            titleLabel.text = "Wins"
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
            notesLabel.text = "How can I improve?"
            
            notesTextViewHeightConstraint.constant = (screenSize.height/2)
            break
        default:
            notesLabel.text = "Notes"
            break
        }
    }
    
    
    func saveItem(){
        switch self.itemType {
        case .toDo:
            
            // Update dictionary
            let toDoDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "datecreated" : toDo?.datecreated as Any, "details": notesTextView.text as Any, "id": toDo?.id]
            do {
                try self.allItemStore.updateToDo(toDoDict: toDoDict)
                print("To Do successfully updated")
            } catch {
                print(error)
            }
            break
        case .nextAction:
            
            // Update dictionary
            let nextActionDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "createdate" : nextAction?.createdate as Any, "duedate" : dueDatePicker.date as Any, "details": notesTextView.text as Any, "id": nextAction?.id, "priority" : prioritySlider.value as Any, "processingtime" : durationSlider.value, "projects" : nextAction?.projects, "contexts" : nextAction?.contexts]
            do {
                try self.allItemStore.updateNextActions(nextActionDict: nextActionDict)
                print("Next Action successfully updated")
            } catch {
                print(error)
            }
            break
        case .project:
            
            // Update dictionary
            let projectDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "createdate" : project?.createdate as Any, "duedate" : dueDatePicker.date as Any, "details": notesTextView.text as Any, "id": project?.id]
            do {
                try self.allItemStore.updateProject(projectDict: projectDict)
                print("Project successfully updated")
            } catch {
                print(error)
            }
            break
        case .review:
            
            // Update dictionary
            let reviewDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "createDate" : review?.createDate as Any, "details": notesTextView.text as Any, "id": review?.id]
            do {
                try self.allItemStore.updateReview(reviewDict: reviewDict)
                print("Topic successfully updated")
            } catch {
                print(error)
            }
            break
        default:
            break
        }
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
        case .toDo, .review:
            notesTextViewHeight = screenSize.height/2
        case .nextAction:
            if UIDevice.current.orientation.isLandscape {
                notesTextViewHeight = screenSize.height/3
            } else {
                notesTextViewHeight = (screenSize.height * 2)/5
            }
        case .project:
            if UIDevice.current.orientation.isLandscape {
                notesTextViewHeight = (screenSize.height * 2)/5
            } else {
                notesTextViewHeight = screenSize.height/2
            }
        default:
            break
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.fullStackViewTopConstaint.constant = 8
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
          if notesTextViewIsEditing {
  
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                let targetOffsetForTopConstraint = 8 - notesStackView.frame.origin.y
            let targetOffsetForNotesTextViewHeight = screenSize.height - 80 - keyboardHeight
                
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.fullStackViewTopConstaint.constant = targetOffsetForTopConstraint
                    self.notesTextViewHeightConstraint.constant = targetOffsetForNotesTextViewHeight
                    self.view.layoutIfNeeded()
                })
            }
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
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ReclassifySegue" {
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.allItemStore = allItemStore
            if itemType == .toDo {
                destinationVC.reclassifiedToDo = toDo
            }
            else if itemType == .nextAction{
                destinationVC.reclassifiedNextAction = nextAction
                
            }
            else if itemType == .project {
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
    
    
    
}
