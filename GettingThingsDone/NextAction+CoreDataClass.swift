//
//  NextAction+CoreDataClass.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/20/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData

@objc(NextAction)
public class NextAction: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        name = ""
        details = ""
        createdate = NSDate()
        id = NSUUID().uuidString
        duedate = nil
        priority = 0
        processingtime = 0
    }

}
