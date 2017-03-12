//
//  Topic+CoreDataProperties.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/9/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData


extension Topic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic");
    }

    @NSManaged public var details: String?
    @NSManaged public var name: String?
    @NSManaged public var review: Bool
    @NSManaged public var nextActions: NSSet?
    @NSManaged public var projects: NSSet?
    @NSManaged public var reviewnotes: NSSet?

}

// MARK: Generated accessors for nextActions
extension Topic {

    @objc(addNextActionsObject:)
    @NSManaged public func addToNextActions(_ value: NextAction)

    @objc(removeNextActionsObject:)
    @NSManaged public func removeFromNextActions(_ value: NextAction)

    @objc(addNextActions:)
    @NSManaged public func addToNextActions(_ values: NSSet)

    @objc(removeNextActions:)
    @NSManaged public func removeFromNextActions(_ values: NSSet)

}

// MARK: Generated accessors for projects
extension Topic {

    @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: Project)

    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: Project)

    @objc(addProjects:)
    @NSManaged public func addToProjects(_ values: NSSet)

    @objc(removeProjects:)
    @NSManaged public func removeFromProjects(_ values: NSSet)

}

// MARK: Generated accessors for reviewnotes
extension Topic {

    @objc(addReviewnotesObject:)
    @NSManaged public func addToReviewnotes(_ value: ToDo)

    @objc(removeReviewnotesObject:)
    @NSManaged public func removeFromReviewnotes(_ value: ToDo)

    @objc(addReviewnotes:)
    @NSManaged public func addToReviewnotes(_ values: NSSet)

    @objc(removeReviewnotes:)
    @NSManaged public func removeFromReviewnotes(_ values: NSSet)

}
