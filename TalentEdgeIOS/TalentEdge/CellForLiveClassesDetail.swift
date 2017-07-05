//
//  CellForLiveClassesDetail.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 25/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CellForLiveClassesDetail: UITableViewCell,UITableViewDelegate ,UITableViewDataSource {

   // @IBOutlet weak var innerTableView: UITableView!
    @IBOutlet weak var mostUpperView: UIView!
    
    @IBOutlet weak var shortSummaryLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    
   // @IBOutlet weak var innerTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
  //  @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var tappedButton: UIButton!
    
    var dataModel =  NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("time_details"))
   // var calculateHeight :[Int]?
    var liveClassDetailObj :LiveClassDetailsModel?
    @IBOutlet weak var sendMessageInnerButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTheConfiguration()
    {
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        
        self.updateViewConstraints()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "timingCell", for: indexPath) as! TimingCell
    
        cell.upperRoundView.layer.cornerRadius = cell.upperRoundView.frame.size.height/2
        cell.upperRoundView.backgroundColor = UIColor.red
        cell.lowerRoundView.layer.cornerRadius = cell.lowerRoundView.frame.size.height/2
        cell.lowerRoundView.backgroundColor = UIColor.black
        let yourAttributes = [NSForegroundColorAttributeName: UIColor.init(hexString: "2D9FF4")]
        
        let partOne =  NSMutableAttributedString(string:((dataModel[indexPath.row] as! time_details).in_time), attributes: yourAttributes)
        
        let combination = NSMutableAttributedString()
        combination.append(NSAttributedString(string: "In Time: "))
        combination.append(partOne)
        cell.leftTimingLabel.attributedText = combination
        
        let partOne1 = NSMutableAttributedString(string:((dataModel[indexPath.row] as! time_details).out_time) , attributes: yourAttributes)

        let combination1 = NSMutableAttributedString()
        combination1.append(NSAttributedString(string: "Out Time: "))
        combination1.append(partOne1)
               cell.rightTimingLabel.attributedText = combination1
        updateViewConstraints()
        cell.selectionStyle = .none
        return cell

        
    }
    
     func updateViewConstraints() {
    // super.updateViewConstraints()
        tableViewHeightConstraint?.constant = tableView.contentSize.height
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataModel.count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
