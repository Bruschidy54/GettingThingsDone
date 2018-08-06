//
//  ReferenceTableViewCell.swift
//  GettingThingsDone
//
//  Created by Dylan Bruschi on 6/15/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

protocol ReferenceTableViewCellDelegate {
    func segueToReferenceItem()
}


class ReferenceTableViewCell: UITableViewCell {
    
    var delegate: ReferenceTableViewCellDelegate?
    
    
    @IBOutlet var backgroundCloudImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var segueButton: UIButton!
    
    @IBAction func onSegueButtonTapped(_ sender: Any) {
        delegate?.segueToReferenceItem()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
