//
//  Extensions.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 8/3/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return  UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let themeOrange = UIColor.rgb(red: 232, green: 142, blue: 12)
    static let lightBlue = UIColor.rgb(red: 122, green: 214, blue: 253)
    static let themePurple = UIColor.rgb(red: 79, green: 33, blue: 150)
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Use custom delegation to send relationships information from relatedToVC to AddItemVC
extension AddItemViewController: RelatedToViewControllerDelegate {
    func didUpdateRelatedTo(sender: RelatedToViewController) {
            self.relatedToNextActionsArray = sender.relatedToNextActionsArray
            self.relatedToProjectsArray = sender.relatedToProjectsArray
            self.relatedToContextArray = sender.relatedToContextArray
     
    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
}

}

