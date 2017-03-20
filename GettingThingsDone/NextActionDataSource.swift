//
//  NextActionDataStore.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/14/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class NextActionDataSource: NSObject, UITableViewDataSource {
    
    var nextActions = [NextAction]()
    let allItemStore = AllItemStore()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nextActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "NextActionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let nextAction = nextActions[indexPath.row]
        cell.textLabel?.text = nextAction.name
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = nextActions[indexPath.row].id
            nextActions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try allItemStore.deleteNextAction(id: id!)
            }catch {
                print("Error deleting To Do: \(error)")
            }
        }
    }
    
}
