//
//  ItemTextField.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 3/14/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class ItemTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 10
    }
    
    override func becomeFirstResponder() -> Bool {
        let myColor: UIColor = UIColor.blue
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 2.0
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        let myColor: UIColor = UIColor.darkGray
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 1.0
        
        return super.resignFirstResponder()
    }

}
