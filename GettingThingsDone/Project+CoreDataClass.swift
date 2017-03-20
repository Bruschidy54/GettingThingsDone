//
//  Project+CoreDataClass.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/14/17.
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
        createdate = NSDate()
        id = NSUUID().uuidString
        duedate = nil
    }

}
