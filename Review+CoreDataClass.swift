//
//  Review+CoreDataClass.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 6/16/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData

@objc(Review)
public class Review: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        name = ""
        details = ""
        createDate = NSDate()
        id = NSUUID().uuidString
    }

}
