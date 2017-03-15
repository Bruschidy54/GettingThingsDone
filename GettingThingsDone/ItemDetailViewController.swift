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
    
    
    
    var toDo: ToDo?
    var toDoStore: ToDoStore!
    var itemType: String = ""
    var nextActionStore: NextActionStore!
    var nextAction: NextAction?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onEditButtonTapped(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
        sender.title = "Done"
        print("Begin editing")
            
            switch itemType {
            case "To Do":
                titleTextField.isEnabled = true
                prioritySlider.isEnabled = true
                durationSlider.isEnabled = true
                notesTextView.isEditable = true
                break
            case "Next Action":
                titleTextField.isEnabled = true
                prioritySlider.isEnabled = true
                durationSlider.isEnabled = true
                notesTextView.isEditable = true
                dueDatePicker.isHidden = false
                dueDateFullDateLabel.isHidden = true
            break
            default:
                break
            }
    }
        else if sender.title == "Done" {
            // To do: Save item
            sender.title = "Edit"
            print("End editing")
            switch itemType {
            case "To Do":
                titleTextField.isEnabled = false
                prioritySlider.isEnabled = false
                durationSlider.isEnabled = false
                notesTextView.isEditable = false
                saveItem()
                break
            case "Next Action":
                titleTextField.isEnabled = false
                prioritySlider.isEnabled = false
                durationSlider.isEnabled = false
                notesTextView.isEditable = false
                dueDatePicker.isHidden = true
                dueDateFullDateLabel.isHidden = false
                saveItem()
                break
            default:
                break
            }
         
    }
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch itemType {
        case "To Do":
            print(toDo)
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
            prioritySlider.isEnabled = false
            durationSlider.isEnabled = false
            notesTextView.isEditable = false
            titleTextField.isEnabled = false
            break
        case "Next Action":
            print(nextAction)
            titleTextField.text = nextAction?.name
            notesTextView.text = nextAction?.details
            prioritySlider.value = (nextAction?.priority)!
            durationSlider.value = (nextAction?.processingtime)!
            dueDateFullDateLabel.text = dateFormatter.string(from: nextAction?.duedate as! Date)
            dueDatePicker.date = nextAction?.duedate as! Date
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
            prioritySlider.isEnabled = false
            durationSlider.isEnabled = false
            notesTextView.isEditable = false
            titleTextField.isEnabled = false
            break
        case "Project":
            
            //Update after project object is created
            titleLabel.isHidden = false
            titleTextField.isHidden = false
            priorityLabel.isHidden = false
            prioritySlider.isHidden = false
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = false
            dueDatePicker.isHidden = false
            relatedToButton.isHidden = false
            break
        case "Topic":
            
            //Update after topic object is created
            titleLabel.isHidden = false
            titleTextField.isHidden = false
            priorityLabel.isHidden = false
            prioritySlider.isHidden = false
            durationLabel.isHidden = true
            durationSlider.isHidden = true
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = true
            relatedToButton.isHidden = true
            break
        default:
            break
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveItem(){
        switch self.itemType {
        case "To Do":
            let toDoDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "datecreated" : toDo?.datecreated as Any, "review" : toDo?.review as Any, "details": notesTextView.text as Any, "id": toDo?.id]
            do {
                try self.toDoStore.updateToDo(toDoDict: toDoDict)
                print("To Do successfully updated")
            } catch {
                print(error)
            }
            break
        case "Next Action":
            
            // Update dictionary
            let nextActionDict: Dictionary<String, Any> = ["name" : titleTextField.text as Any, "createdate" : nextAction?.createdate as Any, "duedate" : dueDatePicker.date as Any, "details": notesTextView.text as Any, "id": nextAction?.id, "priority" : prioritySlider.value as Any, "processingtime" : durationSlider.value]
            do {
                try self.nextActionStore.updateNextActions(nextActionDict: nextActionDict)
                print("Next Action successfully updated")
            } catch {
                print(error)
            }
            break
        default:
            break
        }
    }
    

    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReclassifySegue" {
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.toDoStore = toDoStore
            destinationVC.nextActionStore = nextActionStore
            if itemType == "To Do" {
                destinationVC.reclassifiedToDo = toDo
            
            }
            else if itemType == "Next Action" {
                destinationVC.reclassifiedNextAction = nextAction
       
            }
        }
    }


}
