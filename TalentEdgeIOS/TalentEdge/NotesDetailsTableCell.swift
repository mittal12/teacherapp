//
//  NotesDetailsTableCell.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 11/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class NotesDetailsTableCell: UITableViewCell {

    
    @IBOutlet weak var upperImageView: UIImageView!
    
    @IBOutlet weak var lastVisitedLabel: UILabel!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var percentageView: UIView!
    
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
