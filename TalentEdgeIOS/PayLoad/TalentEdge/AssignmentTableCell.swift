//
//  AssignmentTableCell.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 10/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class AssignmentTableCell: UITableViewCell {

    @IBOutlet weak var mainUpperView: UIView!
    @IBOutlet weak var upperImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    @IBOutlet weak var upperView: UIView!
    
    
    @IBOutlet weak var publishedLabel: UILabel!
    
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var multipleSubmissionLabel: UILabel!
    
    @IBOutlet weak var typeLabelValueLabel: UILabel!
    
    @IBOutlet weak var multipleSubmissionValueLabel: UILabel!
    
    @IBOutlet weak var marksLabel: UILabel!
    
    @IBOutlet weak var marksValueLabel: UILabel!
    
    
    @IBOutlet weak var passingMarksLabel: UILabel!
    
    
    @IBOutlet weak var passingMarksValueLabel: UILabel!
    
    
    
    @IBOutlet weak var ModelLabel: UILabel!
    
    
    @IBOutlet weak var modeValueLabel: UILabel!
    
    
    
    @IBOutlet weak var secondDescriptiveLabel: UILabel!
    
    
    @IBOutlet weak var circleLabel: UILabel!
    
    
    /*
     
     
     @IBOutlet weak var upperImageView: UIImageView!
     
     @IBOutlet weak var titleLabel: UILabel!
     
     
     @IBOutlet weak var subtitleLabel: UILabel!
     
     
     
     @IBOutlet weak var upperView: UIView!
     
     
     @IBOutlet weak var publishedLabel: UILabel!
     
     
     @IBOutlet weak var typeLabel: UILabel!
     
     
     @IBOutlet weak var multipleSubmissionLabel: UILabel!
     
     
     @IBOutlet weak var typeLabelValueLabel: UILabel!
     
     
     
     @IBOutlet weak var multipleSubmissionValueLabel: UILabel!
     
     @IBOutlet weak var marksLabel: UILabel!
     
     
     @IBOutlet weak var marksValueLabel: UILabel!
     
     
     @IBOutlet weak var passingMarksLabel: UILabel!
     
     
     @IBOutlet weak var passingMarksValueLabel: UILabel!
     
     @IBOutlet weak var ModelLabel: UILabel!
     
     @IBOutlet weak var modeValueLabel: UILabel!
     
     @IBOutlet weak var secondView: UIView!
     
     
     
     
     @IBOutlet weak var secondDescriptiveLabel: UILabel!
     
     
     
     
     @IBOutlet weak var circleLabel: UILabel!
     
     
     
     @IBOutlet weak var completedLabel: UILabel!
     
     @IBOutlet weak var studentsUploadValueLabel: UILabel!
     
     
     @IBOutlet weak var studentUploadLabel: UILabel!
     @IBOutlet weak var studentImageView: UIImageView!
     
     
     
     @IBOutlet weak var studentNotUploadedValueLabe: UILabel!
     
     
     
     @IBOutlet weak var studentNotImageView: UIImageView!
     
     
     
     @IBOutlet weak var studentNotUploadLabel: UILabel!
     

 */
    @IBOutlet weak var studentImageView: UIImageView!
    
    @IBOutlet weak var studentUploadLabel: UILabel!
    @IBOutlet weak var studentNotUploadLabel: UILabel!
    @IBOutlet weak var studentNotUploadedValueLabe: UILabel!
    @IBOutlet weak var studentsUploadValueLabel: UILabel!
    @IBOutlet weak var studentNotImageView: UIImageView!
    @IBOutlet weak var completedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
