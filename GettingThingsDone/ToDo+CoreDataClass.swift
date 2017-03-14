//
//  ToDo+CoreDataClass.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/14/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData

@objc(ToDo)
public class ToDo: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        name = ""
        details = ""
        review = false
        datecreated = NSDate()
        id = NSUUID().uuidString
    }

}
