//
//  ItemDetailViewController.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/11/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
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
    
    
    var toDo: ToDo?
    var toDoStore: ToDoStore!
    
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
