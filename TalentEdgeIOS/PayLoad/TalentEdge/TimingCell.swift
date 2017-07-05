//
//  TimingCell.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 25/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class TimingCell: UITableViewCell {

    
    
    @IBOutlet weak var mostUpperView: UIView!
    
    @IBOutlet weak var upperRoundView: UIView!
    
    @IBOutlet weak var lowerRoundView: UIView!
    
    @IBOutlet weak var rightTimingLabel: UILabel!
    
    @IBOutlet weak var leftTimingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
