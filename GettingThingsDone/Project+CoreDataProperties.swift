//
//  Project+CoreDataProperties.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/20/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project");
    }

    @NSManaged public var createdate: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var duedate: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nextActions: NSSet?
    @NSManaged public var topics: NSSet?

}

// MARK: Generated accessors for nextActions
extension Project {

    @objc(addNextActionsObject:)
    @NSManaged public func addToNextActions(_ value: NextAction)

    @objc(removeNextActionsObject:)
    @NSManaged public func removeFromNextActions(_ value: NextAction)

    @objc(addNextActions:)
    @NSManaged public func addToNextActions(_ values: NSSet)

    @objc(removeNextActions:)
    @NSManaged public func removeFromNextActions(_ values: NSSet)

}

// MARK: Generated accessors for topics
extension Project {

    @objc(addTopicsObject:)
    @NSManaged public func addToTopics(_ value: Topic)

    @objc(removeTopicsObject:)
    @NSManaged public func removeFromTopics(_ value: Topic)

    @objc(addTopics:)
    @NSManaged public func addToTopics(_ values: NSSet)

    @objc(removeTopics:)
    @NSManaged public func removeFromTopics(_ values: NSSet)

}
