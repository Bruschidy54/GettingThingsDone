//
//  IndentedLabel.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 8/4/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import UIKit

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}
