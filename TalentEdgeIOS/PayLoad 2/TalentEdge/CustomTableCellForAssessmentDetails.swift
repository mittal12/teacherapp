//
//  CustomTableCellForAssessmentDetails.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 12/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CustomTableCellForAssessmentDetails: UITableViewCell {

    @IBOutlet weak var upperViewFortableCell: UIView!
    
    @IBOutlet weak var upperImageView: UIImageView!
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var howmanyAnsweredLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    
    @IBOutlet weak var belowImageView: UIImageView!
    @IBOutlet weak var mouseButton: UIButton!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
