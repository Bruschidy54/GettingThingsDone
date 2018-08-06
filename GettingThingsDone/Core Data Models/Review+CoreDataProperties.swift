//
//  Review+CoreDataProperties.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 6/16/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var name: String?
    @NSManaged public var createDate: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var id: String?

}
