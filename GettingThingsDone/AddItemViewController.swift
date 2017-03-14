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
    
    
    let pickerData = ["Choose an Option", "To Do", "Next Action", "Project", "Topic"]
    var itemType: String = ""
    var toDoStore: ToDoStore!
    
    
    
    
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func onDoneButtonTapped(_ sender: Any) {
        // Insert code saving new item
        
        // Show error if form is incomplete or itemType = "Choose an option"
        createItem()
        
         self.navigationController?.popViewController(animated: true)
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
            // Make form hidden
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
        case "Project":
            break
        case "Topic":
            break
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
