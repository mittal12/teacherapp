//
//  SummaryUpperView.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 29/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class SummaryUpperView: UIView {
/*
     firstView.nameLabel.text = self.profileModel.name
     firstView.userProfileImageView.sd_setImage(with: URL(string: self.profileModel.pic))
     firstView.companyNameLabel.text = ""
     firstView.designationLabel.text = ""

 */
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var designationLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
