//
//  Topic+CoreDataClass.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/16/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData

@objc(Topic)
public class Topic: NSManagedObject {

    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        name = ""
        details = ""
        id = NSUUID().uuidString
    }
}
