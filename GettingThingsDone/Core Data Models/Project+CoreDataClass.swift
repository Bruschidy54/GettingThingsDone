//
//  Project+CoreDataClass.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 6/16/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData

@objc(Project)
public class Project: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        name = ""
        details = ""
        priority = 0
        createdate = NSDate()
        id = NSUUID().uuidString
        duedate = nil
    }

}
