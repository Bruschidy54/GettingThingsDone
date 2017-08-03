//
//  Context+CoreDataClass.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 8/2/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation
import CoreData

@objc(Context)
public class Context: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        name = ""
        id = NSUUID().uuidString
    }
}
