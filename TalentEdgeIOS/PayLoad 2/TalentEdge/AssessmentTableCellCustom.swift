//
//  AssessmentTableCellCustom.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 10/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class AssessmentTableCellCustom: UITableViewCell {

    
    @IBOutlet weak var mainUperView: UIView!
    @IBOutlet weak var upperImageView: UIImageView!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tittleLabel: UILabel!
    
    
    @IBOutlet weak var upperView: UIView!
    
    
    @IBOutlet weak var publicationLabel: UILabel!
    
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var studentAttemptedValueLabel: UILabel!
    
    @IBOutlet weak var studentNotAttemptedValueLabel: UILabel!
    
    @IBOutlet weak var studentNotAttemptedLabel: UILabel!
    
    @IBOutlet weak var studentAttemptedLabel: UILabel!
    
    
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var studentAttemptedImageView: UIImageView!
    
    @IBOutlet weak var studentnotAttemptedImageView: UIImageView!
    /*
     
     @IBOutlet weak var upperImageView: UIImageView!
     
     
     @IBOutlet weak var titileLabel: UILabel!
     
     @IBOutlet weak var subtitleLabel: UILabel!
     
     
     
     @IBOutlet weak var upperView: UIView!
     
     
     @IBOutlet weak var publicationLabel: UILabel!
     
     @IBOutlet weak var questionLabel: UILabel!
     
     @IBOutlet weak var descriptionLabel: UILabel!
     
     
     
     @IBOutlet weak var secondView: UIView!
     
     
     
     @IBOutlet weak var circleLabel: UILabel!
     
     
     @IBOutlet weak var scoreLabel: UILabel!
     
     @IBOutlet weak var studentAttemptedValueLabel: UILabel!
     
     @IBOutlet weak var studentAttemptedImageView: UIImageView!
     
     
     
     
     @IBOutlet weak var studentAttemptedLabel: UILabel!
     
     
     @IBOutlet weak var studentNotAttemptedValueLabel: UILabel!
     
     
     @IBOutlet weak var studentnotAttemptedImageView: UIImageView!
     
     @IBOutlet weak var studentNotAttemptedLabel: UILabel!
     
     @IBOutlet weak var modeLabel: UILabel!

     
     
     
 */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
