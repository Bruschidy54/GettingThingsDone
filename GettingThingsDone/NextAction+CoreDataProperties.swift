//
//  NextAction+CoreDataProperties.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/14/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData


extension NextAction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NextAction> {
        return NSFetchRequest<NextAction>(entityName: "NextAction");
    }

    @NSManaged public var createdate: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var duedate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var processingtime: Int32
    @NSManaged public var id: String?
    @NSManaged public var project: Project?
    @NSManaged public var topic: Topic?

}
