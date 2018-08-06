//
//  Context+CoreDataProperties.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 8/2/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData


extension Context {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Context> {
        return NSFetchRequest<Context>(entityName: "Context")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var nextActions: NSSet?

}

// MARK: Generated accessors for nextActions
extension Context {

    @objc(addNextActionsObject:)
    @NSManaged public func addToNextActions(_ value: NextAction)

    @objc(removeNextActionsObject:)
    @NSManaged public func removeFromNextActions(_ value: NextAction)

    @objc(addNextActions:)
    @NSManaged public func addToNextActions(_ values: NSSet)

    @objc(removeNextActions:)
    @NSManaged public func removeFromNextActions(_ values: NSSet)

}
