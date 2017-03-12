//
//  ToDoStore.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/9/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit
import CoreData

class ToDoStore {
    
    
    let coreDataStack = CoreDataStack(modelName: "GTDModel")
    
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
    
}
