//
//  ContextStore.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/17/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class ContextStore {
    
    
    let coreDataStack = CoreDataStack(modelName: "GTDModel")
    
    func fetchMainQueueContext(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Context] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Context")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let moc = self.coreDataStack.mainQueueContext
        var mainQueueContexts: [Context]?
        var fetchRequestError: Error?
        moc.performAndWait({
            do {
                mainQueueContexts = try moc.fetch(fetchRequest) as? [Context]
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard let contexts = mainQueueContexts else {
            throw fetchRequestError!
        }
        return contexts
    }
    
    func updateContexts(contextDict: Dictionary<String, Any>) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Context")
        fetchRequest.predicate = NSPredicate(format: "id = %@", contextDict["id"] as! String)
        let moc = coreDataStack.mainQueueContext
        
        var mainQueueContext: [Context]?
        
        var fetchRequestError: Error?
        moc.performAndWait({
            do {
                mainQueueContext = try moc.fetch(fetchRequest) as? [Context]
                let managedObject = mainQueueContext?.first
                
                // Update dictionary
                managedObject?.setValue(contextDict["name"], forKey: "name")
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueContext != nil else {
            throw fetchRequestError!
            
        }
    }
    
    
    func deleteContext(id: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Context")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let moc = coreDataStack.mainQueueContext
        
        var mainQueueContext: [Context]?
        
        var fetchRequestError: Error?
        moc.performAndWait({
            do {
                mainQueueContext = try moc.fetch(fetchRequest) as? [Context]
                let managedObject = mainQueueContext?[0]
                moc.delete(managedObject!)
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueContext != nil else {
            throw fetchRequestError!
            
        }
        
    }
}
