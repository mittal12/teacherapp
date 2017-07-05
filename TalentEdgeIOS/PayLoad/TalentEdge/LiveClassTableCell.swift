//
//  LiveClassTableCell.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 10/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class LiveClassTableCell: UITableViewCell {

    
    @IBOutlet weak var mainUpperViewForCell: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var plusImageView: UIImageView!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    
    @IBOutlet weak var publishDateLabel: UILabel!
    
    
    
    @IBOutlet weak var descriptionTextVIew: UILabel!
    
    @IBOutlet weak var circleAttandanceLabel: UILabel!
    /*
 
 @IBOutlet weak var titleLabel: UILabel!
 @IBOutlet weak var topEyeImageView: UIImageView!
 @IBOutlet weak var plusImageView: UIImageView!
 @IBOutlet weak var subTitleLabel: UILabel!
 @IBOutlet weak var durationLabel: UILabel!
 @IBOutlet weak var publishDateLabel: UILabel!
 @IBOutlet weak var descriptionTextVIew: UITextView!
 @IBOutlet weak var bottomBlueButton: UIButton!
 @IBOutlet weak var modeSubmissionLabel: UILabel!
 
 
 @IBOutlet weak var circleAttandanceLabel: UILabel!
 
 @IBOutlet weak var attendanceLabel: UILabel!
 
 
 @IBOutlet weak var leftImageView: UIImageView!
 
 @IBOutlet weak var leftUpperLabel: UILabel!
 
 
 @IBOutlet weak var leftMiddleView: UIView!
 
 
 @IBOutlet weak var leftBottomLabel: UILabel!
 
 
 @IBOutlet weak var rightImageView: UIImageView!
 
 @IBOutlet weak var rightUpperLabel: UILabel!
 
 
 @IBOutlet weak var rightMiddleView: UIView!
 @IBOutlet weak var rightBottomLabel: UILabel!
 
 @IBOutlet weak var specialLabelForCirlcle: UILabel!
 
 */
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!

    @IBOutlet weak var leftMiddleView: UIView!

    
    @IBOutlet weak var rightMiddleView: UIView!
    @IBOutlet weak var leftBottomLabel: UILabel!
    @IBOutlet weak var rightUpperLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var leftUpperLabel: UILabel!
    
    @IBOutlet weak var rightBottomLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
