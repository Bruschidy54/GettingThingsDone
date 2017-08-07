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
        if toDos.isEmpty == true {
            cell.textLabel?.text = "In Tray Is Empty"
        } else{
        let toDo = toDos[indexPath.row]
        cell.textLabel?.text = toDo.name
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let toDo: ToDo? = toDos[indexPath.row] {
            let id = toDo?.id
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
            try allItemStore.deleteToDo(id: id!)
            }catch {
                print("Error deleting To Do: \(error)")
            }
        }
        }
    }
    
}
