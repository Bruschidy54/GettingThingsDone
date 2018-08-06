//
//  NextAction+CoreDataProperties.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 6/16/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData


extension NextAction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NextAction> {
        return NSFetchRequest<NextAction>(entityName: "NextAction")
    }

    @NSManaged public var createdate: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var duedate: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: Float
    @NSManaged public var processingtime: Float
    @NSManaged public var contextSorted: Bool
    @NSManaged public var projectSorted: Bool
    @NSManaged public var contexts: NSSet?
    @NSManaged public var projects: NSSet?
    
    var relevanceScore: Float {
        return ((1.5 * priority) + 0.1)/(processingtime + 0.1)
    }

}

// MARK: Generated accessors for contexts
extension NextAction {

    @objc(addContextsObject:)
    @NSManaged public func addToContexts(_ value: Context)

    @objc(removeContextsObject:)
    @NSManaged public func removeFromContexts(_ value: Context)

    @objc(addContexts:)
    @NSManaged public func addToContexts(_ values: NSSet)

    @objc(removeContexts:)
    @NSManaged public func removeFromContexts(_ values: NSSet)

}

// MARK: Generated accessors for projects
extension NextAction {

    @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: Project)

    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: Project)

    @objc(addProjects:)
    @NSManaged public func addToProjects(_ values: NSSet)

    @objc(removeProjects:)
    @NSManaged public func removeFromProjects(_ values: NSSet)

}
