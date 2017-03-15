//
//  AddItemViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/10/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    
    // Make contexts a Core Data object instead
    let pickerData = ["Choose an Option", "To Do", "Next Action", "Project", "Topic"]
    var itemType: String = ""
    var reclassifiedToDo: ToDo!
    var reclassifiedNextAction: NextAction!
    var toDoStore: ToDoStore!
    var nextActionStore: NextActionStore!
    
    
    
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func onDoneButtonTapped(_ sender: Any) {
        // Insert code saving new item
        
        // Show error if form is incomplete or itemType = "Choose an option"
        createItem()
        
        if reclassifiedToDo != nil {
            let id = reclassifiedToDo?.id
            do  {
                try toDoStore.deleteToDo(id: id!)
            } catch {
                print("Error deleting To Do: \(error)")
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        else if reclassifiedNextAction != nil {
            let id = reclassifiedNextAction?.id
            do  {
                try nextActionStore.deleteNextAction(id: id!)
            } catch {
                print("Error deleting To Do: \(error)")
            }
            self.navigationController?.popToRootViewController(animated: true)
        } else {

     self.navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func updateForm() {
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
            break
        case "Project":
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
                let context = self.toDoStore.coreDataStack.mainQueueContext
                let newToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
            newToDo.setValue(toDoTitle, forKey: "name")
            newToDo.setValue(toDoNotes, forKey: "details")
            
            do {
                try self.toDoStore?.coreDataStack.saveChanges()
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
            let context = self.nextActionStore.coreDataStack.mainQueueContext
            let newNextAction = NSEntityDescription.insertNewObject(forEntityName: "NextAction", into: context)
            newNextAction.setValue(title, forKey: "name")
            newNextAction.setValue(priority, forKey: "priority")
            newNextAction.setValue(duration, forKey: "processingtime")
            newNextAction.setValue(date, forKey: "duedate")
            newNextAction.setValue(notes, forKey: "details")
            
            do {
                try self.nextActionStore?.coreDataStack.saveChanges()
                print("Save Complete")
            }
            catch let error {
                print("Core data save failed: \(error)")
            }
            
            break
        case "Project":
            break
        case "Topic":
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
    

    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToDoSegue" {
//            let destinationVC = segue.destination as! ToDoViewController
//            destinationVC.nextActionStore = nextActionStore
//            destinationVC.toDoStore = toDoStore
//        }
//        else if segue.identifier == "NextActionSegue" {
//            let destinationVC = segue.destination as! NextActionViewController
//            destinationVC.nextActionStore = nextActionStore
//            destinationVC.toDoStore = toDoStore
//        }
//        
//        // Complete with Reference Segue
//    }

}
