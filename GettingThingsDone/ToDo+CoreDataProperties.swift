//
//  ToDo+CoreDataProperties.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/14/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo");
    }

    @NSManaged public var datecreated: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var name: String?
    @NSManaged public var review: Bool
    @NSManaged public var id: String?
    @NSManaged public var reviewtopic: Topic?

}
