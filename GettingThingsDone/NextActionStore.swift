//
//  NextActionStore.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/9/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class NextActionStore {
    
    
    let coreDataStack = CoreDataStack(modelName: "GTDModel")
    
    func fetchMainQueueNextActions(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [NextAction] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NextAction")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueNextActions: [NextAction]?
        var fetchRequestError: Error?
        mainQueueContext.performAndWait({
            do {
                mainQueueNextActions = try mainQueueContext.fetch(fetchRequest) as? [NextAction]
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard let nextActions = mainQueueNextActions else {
            throw fetchRequestError!
        }
        return nextActions
    }
    
    func updateNextActions(toDoDict: Dictionary<String, Any>) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NextAction")
        fetchRequest.predicate = NSPredicate(format: "id = %@", toDoDict["id"] as! String)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueNextActions: [NextAction]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueNextActions = try context.fetch(fetchRequest) as? [NextAction]
                let managedObject = mainQueueNextActions?.first
                managedObject?.setValue(toDoDict["priority"], forKey: "priority")
                managedObject?.setValue(toDoDict["processingtime"], forKey: "processingtime")
                managedObject?.setValue(toDoDict["name"], forKey: "name")
                    managedObject?.setValue(toDoDict["duedate"], forKey: "duedate")
                managedObject?.setValue(toDoDict["details"], forKey: "details")
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueNextActions != nil else {
            throw fetchRequestError!
            
        }
    }
    
    
    func deleteNextAction(id: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NextAction")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueNextActions: [NextAction]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueNextActions = try context.fetch(fetchRequest) as? [NextAction]
                let managedObject = mainQueueNextActions?[0]
                context.delete(managedObject!)
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueNextActions != nil else {
            throw fetchRequestError!
            
        }
        
    }
}
