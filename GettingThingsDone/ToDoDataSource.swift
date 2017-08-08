//
//  ToDoDataSource.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/10/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class ToDoDataSource: NSObject, UITableViewDataSource {
    
    var toDos = [ToDo]()
    let allItemStore = AllItemStore()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ToDoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        
        let toDo = toDos[indexPath.row]
        cell.textLabel?.text = toDo.name
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.font = UIFont(name: "GillSans", size: 17)
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if !toDos.isEmpty {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        } else {
            let noToDoLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noToDoLabel.text = "In Tray Is Empty"
            noToDoLabel.textColor = UIColor.darkGray
            noToDoLabel.textAlignment = .center
            tableView.backgroundView = noToDoLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let toDo: ToDo? = toDos[indexPath.row] {
                let id = toDo?.id
                toDos.remove(at: indexPath.row)
                if toDos.isEmpty {
                    tableView.deleteSections(NSIndexSet.init(index: indexPath.section) as IndexSet, with: .fade)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                do {
                    try allItemStore.deleteToDo(id: id!)
                }catch {
                    print("Error deleting To Do: \(error)")
                }
            }
        }
    }
    
}
