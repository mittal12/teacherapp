//
//  CellForLiveClassesDetail.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 25/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CellForLiveClassesDetail: UITableViewCell {

    @IBOutlet weak var innerTableView: UITableView!
    @IBOutlet weak var mostUpperView: UIView!
    
    @IBOutlet weak var sessionLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var innerTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
