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
    
    func updateNextActions(nextActionDict: Dictionary<String, Any>) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NextAction")
        fetchRequest.predicate = NSPredicate(format: "id = %@", nextActionDict["id"] as! String)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueNextActions: [NextAction]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueNextActions = try context.fetch(fetchRequest) as? [NextAction]
                let managedObject = mainQueueNextActions?.first
                managedObject?.setValue(nextActionDict["priority"], forKey: "priority")
                managedObject?.setValue(nextActionDict["processingtime"], forKey: "processingtime")
                managedObject?.setValue(nextActionDict["name"], forKey: "name")
                    managedObject?.setValue(nextActionDict["duedate"], forKey: "duedate")
                managedObject?.setValue(nextActionDict["details"], forKey: "details")
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
