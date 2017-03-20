//
//  TopicStore.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/9/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class TopicStore {
    
    
    let coreDataStack = CoreDataStack(modelName: "GTDModel")
    
    func fetchMainQueueProjects(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Topic] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueTopics: [Topic]?
        var fetchRequestError: Error?
        mainQueueContext.performAndWait({
            do {
                mainQueueTopics = try mainQueueContext.fetch(fetchRequest) as? [Topic]
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard let topics = mainQueueTopics else {
            throw fetchRequestError!
        }
        return topics
    }
    
    func updateTopic(topicDict: Dictionary<String, Any>) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        fetchRequest.predicate = NSPredicate(format: "id = %@", topicDict["id"] as! String)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueTopic: [Topic]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueTopic = try context.fetch(fetchRequest) as? [Topic]
                let managedObject = mainQueueTopic?.first
                
                // Update dictionary
                managedObject?.setValue(topicDict["name"], forKey: "name")
                managedObject?.setValue(topicDict["details"], forKey: "details")
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueTopic != nil else {
            throw fetchRequestError!
            
        }
    }
    
    
    func deleteTopic(id: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueTopic: [Topic]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueTopic = try context.fetch(fetchRequest) as? [Topic]
                let managedObject = mainQueueTopic?[0]
                context.delete(managedObject!)
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueTopic != nil else {
            throw fetchRequestError!
            
        }
        
    }
}
