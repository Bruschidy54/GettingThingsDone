//
//  ProjectStore.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/9/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class ProjectStore {
    
    
    let coreDataStack = CoreDataStack(modelName: "GTDModel")
    
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
}
