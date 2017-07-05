//
//  CustomTableCellForAssignmentDetails.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 11/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CustomTableCellForAssignmentDetails: UITableViewCell {

    @IBOutlet weak var upperImageView: UIImageView!
    
    @IBOutlet weak var submittedOnLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var assignmentNameLabel: UILabel!
    
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var markAsRecievedLabel: UILabel!
    
    @IBOutlet weak var circleLabel: UILabel!
    
    
    @IBOutlet weak var checkBoxImageView: UIButton!
    @IBOutlet weak var buttomButton: UIButton!
    
    
    @IBOutlet weak var upperViewForTableCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    @IBAction func bottomButtonTapped(_ sender: Any) {
    }
    @IBAction func downloadButtonTapped(_ sender: Any) {
    }
    
}
