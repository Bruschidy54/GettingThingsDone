//
//  AllItemStore.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/20/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class AllItemStore {
    
    
    let coreDataStack = CoreDataStack(modelName: "GTDModel")
    
    // MARK: To Do Core Data Methods
    
    func fetchMainQueueToDos(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [ToDo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueToDos: [ToDo]?
        var fetchRequestError: Error?
        mainQueueContext.performAndWait({
            do {
                mainQueueToDos = try mainQueueContext.fetch(fetchRequest) as? [ToDo]
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard let toDos = mainQueueToDos else {
            throw fetchRequestError!
        }
        return toDos
    }
    
    func updateToDo(toDoDict: Dictionary<String, Any>) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        fetchRequest.predicate = NSPredicate(format: "id = %@", toDoDict["id"] as! String)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueToDos: [ToDo]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueToDos = try context.fetch(fetchRequest) as? [ToDo]
                let managedObject = mainQueueToDos?.first
                managedObject?.setValue(toDoDict["name"], forKey: "name")
                managedObject?.setValue(toDoDict["details"], forKey: "details")
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueToDos != nil else {
            throw fetchRequestError!
            
        }
    }
    
    
    func deleteToDo(id: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueToDos: [ToDo]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueToDos = try context.fetch(fetchRequest) as? [ToDo]
                let managedObject = mainQueueToDos?[0]
                context.delete(managedObject!)
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueToDos != nil else {
            throw fetchRequestError!
            
        }
        
    }

    
    // MARK: Next Action Core Data Methods
    
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
    
    // MARK: Project Core Data Methods
    
    func fetchMainQueueProjects(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Project] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueProjects: [Project]?
        var fetchRequestError: Error?
        mainQueueContext.performAndWait({
            do {
                mainQueueProjects = try mainQueueContext.fetch(fetchRequest) as? [Project]
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard let projects = mainQueueProjects else {
            throw fetchRequestError!
        }
        return projects
    }
    
    func updateProject(projectDict: Dictionary<String, Any>) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "id = %@", projectDict["id"] as! String)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueProject: [Project]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueProject = try context.fetch(fetchRequest) as? [Project]
                let managedObject = mainQueueProject?.first
                
                // Update dictionary
                managedObject?.setValue(projectDict["name"], forKey: "name")
                managedObject?.setValue(projectDict["duedate"], forKey: "duedate")
                managedObject?.setValue(projectDict["details"], forKey: "details")
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueProject != nil else {
            throw fetchRequestError!
            
        }
    }
    
    
    func deleteProject(id: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let context = coreDataStack.mainQueueContext
        
        var mainQueueProject: [Project]?
        
        var fetchRequestError: Error?
        context.performAndWait({
            do {
                mainQueueProject = try context.fetch(fetchRequest) as? [Project]
                let managedObject = mainQueueProject?[0]
                context.delete(managedObject!)
                try self.coreDataStack.saveChanges()
                
            }
            catch let error {
                fetchRequestError = error
            }
            
        })
        guard mainQueueProject != nil else {
            throw fetchRequestError!
            
        }
        
    }


    
    // MARK: Topic Core Data Methods
    
    func fetchMainQueueTopics(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Topic] {
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
    
    // MARK: Contexts Core Data Methods
    
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

    
    
    // MARK: All Items Core Data Methods


    func fetchMainQueueItems(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> (nextActions: [NextAction], projects: [Project], topics: [Topic], contexts: [Context]) {
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        
        let nextActionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NextAction")
        nextActionFetchRequest.sortDescriptors = sortDescriptors
        nextActionFetchRequest.predicate = predicate
        
        let projectFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        projectFetchRequest.sortDescriptors = sortDescriptors
        projectFetchRequest.predicate = predicate
        
        let topicFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        topicFetchRequest.sortDescriptors = sortDescriptors
        topicFetchRequest.predicate = predicate
        
        let contextFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Context")
        nextActionFetchRequest.sortDescriptors = sortDescriptors
        nextActionFetchRequest.predicate = predicate
        
        var mainQueueNextActions: [NextAction]?
        var mainQueueProjects: [Project]?
        var mainQueueTopics: [Topic]?
        var mainQueueCons: [Context]?
        
        var fetchRequestError: Error?
        mainQueueContext.performAndWait {
            do {
                mainQueueNextActions = try mainQueueContext.fetch(nextActionFetchRequest) as? [NextAction]
                mainQueueProjects = try mainQueueContext.fetch(projectFetchRequest) as? [Project]
                mainQueueTopics = try mainQueueContext.fetch(topicFetchRequest) as? [Topic]
                mainQueueCons = try mainQueueContext.fetch(contextFetchRequest) as? [Context]
            }
            catch let error {
                fetchRequestError = error
            }
            
        }
        guard let nextActions = mainQueueNextActions, let projects = mainQueueProjects, let topics = mainQueueTopics, let contexts = mainQueueCons else {
            throw fetchRequestError!
        }
        return (nextActions, projects, topics, contexts)
    }
        
}
