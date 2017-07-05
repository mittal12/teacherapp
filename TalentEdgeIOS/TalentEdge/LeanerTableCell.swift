//
//  LeanerTableCell.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 24/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class LeanerTableCell: UITableViewCell {

    @IBOutlet weak var mostUpperView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastActiveLabel: UILabel!
    
    
    @IBOutlet weak var circelLabel: UILabel!
    
    
    @IBOutlet weak var completedLabel: UILabel!
    
    
    
    @IBOutlet weak var queryLabel: UILabel!
    
    @IBOutlet weak var queryImageView: UIImageView!
    
    @IBOutlet weak var assessmentLabel: UILabel!
    
    @IBOutlet weak var attendanceLabel: UILabel!
    
    
    @IBOutlet weak var assignmentValueLabel: UILabel!
    
    @IBOutlet weak var viewProfileButton: UIButton!
    
    @IBOutlet weak var assessmentValueLabel: UILabel!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var attendanceValueLabel: UILabel!
    
    @IBOutlet weak var assignmentLabel: UILabel!
    
    @IBOutlet weak var assignmentProgressView: UIView!
    
    @IBOutlet weak var assessmentProgressLabel: UIView!
    
    
    @IBOutlet weak var attendanceProgressView: UIView!
    
    
    @IBOutlet weak var assignmentImageView: UIImageView!
    
    @IBOutlet weak var assessmentImageView: UIImageView!
    
    @IBOutlet weak var attendanceImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
