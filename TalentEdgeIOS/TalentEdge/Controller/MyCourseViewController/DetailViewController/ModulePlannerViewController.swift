//
//  ModulePlannerViewController.swift
//  TalentEdge
//
//

import UIKit

class ModulePlannerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var modulePlannerTableView: UITableView!
    var subModuleArray : [TEModuleDetailData]!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    var moduleData : TEModuleDetailData!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subNavTitleLabel.text = moduleData.module_name
        self.descLabel.text = moduleData.desc
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of anyO resources that can be recreated.
    }
    
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        return subModuleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        
        //        if subModuleArray[indexPath.row].content_type_id.integerValue <= 2 {
        switch subModuleArray[indexPath.row].content_type_id.intValue {
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleMajorInnerTableCell1", for: indexPath) as! ModuleMajorInnerTableCell
            cell.titleLabel.text = subModuleArray[indexPath.row].title
            cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
            
            cell.subTitleLabel.text = "  Discussion  "
            cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
            cell.plusImageView.image = UIImage(named: "live_class1.PNG")
            let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
            let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_value, attributes: yourAttributes)
            let combination = NSMutableAttributedString()
            combination.append(NSAttributedString(string: "Published On : "))
            combination.append(partOne)
            combination.append(NSAttributedString(string: " | End Date : "))
            combination.append(partTwo)
            cell.durationLabel.attributedText = combination
            
            cell.topEyeImageView.image = subModuleArray[indexPath.row].is_locked.boolValue ? UIImage(named:  "lock_icon.png") : subModuleArray[indexPath.row].completion_percentage.intValue == 100 ? UIImage(named:  "eye_open.png") : UIImage(named:  "eye_continue.png")
            if indexPath.row == 0 {
                cell.topEyeImageView.image = subModuleArray[indexPath.row].completion_percentage.intValue == 0 ? UIImage(named:  "unlock_icon.png") : cell.topEyeImageView.image
            }
            
            cell.subTitleLabel.sizeToFit()
//            cell.bottomBlueButton.sizeToFit()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        default:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleMajorInnerTableCell", for: indexPath) as! ModuleMajorInnerTableCell
            cell.titleLabel.text = subModuleArray[indexPath.row].title
            cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
            cell.topEyeImageView.image = subModuleArray[indexPath.row].is_locked.boolValue ? UIImage(named:  "lock_icon.png") : subModuleArray[indexPath.row].completion_percentage.intValue == 100 ? UIImage(named:  "eye_open.PNG") : UIImage(named:  "eye_continue.PNG")
            
            switch subModuleArray[indexPath.row].content_type_id.intValue {
            case 1:
                cell.subTitleLabel.text = "  Reference Notes  "
                cell.bottomBlueButton.setTitle("  Read  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
                
                let part1 = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_label)
                let part2 = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
                let part3 = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_label)
                let part4 = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_value, attributes: yourAttributes)
                
                let combination3 = NSMutableAttributedString()
                combination3.append(part1)
                combination3.append(NSAttributedString(string: " : "))
                combination3.append(part2)
                combination3.append(NSAttributedString(string: " | "))
                combination3.append(part3)
                combination3.append(NSAttributedString(string: " : "))
                combination3.append(part4)
                cell.publishDateLabel.attributedText = combination3
                
                let partOne = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].notes_count.intValue), attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].content_duration_formated, attributes: yourAttributes)
                if subModuleArray[indexPath.row].notes_count.intValue == 1 {
                    let combination1 = NSMutableAttributedString()
                    combination1.append(NSAttributedString(string: "Duration : "))
                    combination1.append(partTwo)
                    cell.durationLabel.attributedText = combination1
                }else{
                    let combination1 = NSMutableAttributedString()
                    combination1.append(NSAttributedString(string: "Pages : "))
                    combination1.append(partOne)
                    combination1.append(NSAttributedString(string: " | Duration : "))
                    combination1.append(partTwo)
                    cell.durationLabel.attributedText = combination1
                }
                
            case 2:
                cell.subTitleLabel.text = "  Reference Video  "
                cell.bottomBlueButton.setTitle("  Watch Now  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
                
                let part1 = NSMutableAttributedString(string: subModuleArray[indexPath.row].content_duration_formated , attributes: yourAttributes)
                let combination = NSMutableAttributedString()
                combination.append(NSAttributedString(string: "Duration:"))
                combination.append(part1)
                cell.durationLabel.attributedText = combination
                
                let part2 = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_label)
                let part3 = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
                let combination1 = NSMutableAttributedString()
                combination1.append(part2)
                combination1.append(NSAttributedString(string: " : "))
                combination1.append(part3)
                cell.publishDateLabel.attributedText = combination1
                
            case 3:
                cell.subTitleLabel.text = "  Interactive Video  "
                cell.bottomBlueButton.setTitle("  Attempted  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
                //                cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
                
                let part1 = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_label)
                let part2 = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
                let combination = NSMutableAttributedString()
                combination.append(part1)
                combination.append(NSAttributedString(string: " : "))
                combination.append(part2)
                cell.publishDateLabel.attributedText = combination
                
                
                let partOne = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].notes_count.intValue), attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].content_duration_formated, attributes: yourAttributes)
                let combination1 = NSMutableAttributedString()
                combination1.append(NSAttributedString(string: "Duration : "))
                combination1.append(partOne)
                combination1.append(NSAttributedString(string: "Pages : "))
                combination1.append(partTwo)
                cell.durationLabel.attributedText = combination1
                
            case 4:
                cell.subTitleLabel.text = "  Assessment  "
                cell.bottomBlueButton.setTitle("  Attempted  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "assessment1.png")
                
                let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_value, attributes: yourAttributes)
                let combination = NSMutableAttributedString()
                combination.append(NSAttributedString(string: "Published On : "))
                combination.append(partOne)
                combination.append(NSAttributedString(string: " | End Date : "))
                combination.append(partTwo)
                cell.publishDateLabel.attributedText = combination
                
                let partThree = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_questions.intValue), attributes: yourAttributes)
                let partFour = NSMutableAttributedString(string: subModuleArray[indexPath.row].total_duration, attributes: yourAttributes)
                let partFive = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_marks.intValue), attributes: yourAttributes)
                
                let combination1 = NSMutableAttributedString()
                combination1.append(NSAttributedString(string: "Question : "))
                combination1.append(partThree)
                combination1.append(NSAttributedString(string: " | Duration : "))
                combination1.append(partFour)
                combination1.append(NSAttributedString(string: " | Max Marks : "))
                combination1.append(partFive)
                
                cell.durationLabel.attributedText = combination1
                
            case 5:
                cell.subTitleLabel.text = "  Assignment  "
                cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "Assignment1.png")
                
                let part1 = NSMutableAttributedString(string: subModuleArray[indexPath.row].total_marks_label)
                let part2 = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_marks.intValue), attributes: yourAttributes)
                let part3 = NSMutableAttributedString(string: subModuleArray[indexPath.row].submission_mode, attributes: yourAttributes)
                let combination1 = NSMutableAttributedString()
                combination1.append(part1)
                combination1.append(NSAttributedString(string: " : "))
                combination1.append(part2)
                combination1.append(NSAttributedString(string: " | Mode:"))
                combination1.append(part3)
                cell.publishDateLabel.attributedText = combination1
                
                
                let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_value, attributes: yourAttributes)
                let combination = NSMutableAttributedString()
                combination.append(NSAttributedString(string: "Published On : "))
                combination.append(partOne)
                combination.append(NSAttributedString(string: " | End Date : "))
                combination.append(partTwo)
                cell.durationLabel.attributedText = combination
                
            case 6:
                cell.subTitleLabel.text = "  Module Planner  "
                cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
                cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
                
                let partOne = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].notes_count.intValue), attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_video.intValue), attributes: yourAttributes)
                let partThree = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_assessment.intValue), attributes: yourAttributes)
                let partFour = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_assignment.intValue), attributes: yourAttributes)
                
                let partFive = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_interactive_video.intValue), attributes: yourAttributes)
                
                let combination = NSMutableAttributedString()
                combination.append(NSAttributedString(string: "Notes : "))
                combination.append(partOne)
                combination.append(NSAttributedString(string: ", Videos : "))
                combination.append(partTwo)
                combination.append(NSAttributedString(string: ", Assessment : "))
                combination.append(partThree)
                combination.append(NSAttributedString(string: ", Assignment : "))
                combination.append(partFour)
                cell.publishDateLabel.attributedText = combination
                
                let combination1 = NSMutableAttributedString()
                combination1.append(NSAttributedString(string: "Interactive Video : "))
                combination1.append(partFive)
                cell.durationLabel.attributedText = combination1
                
            case 7:
                cell.subTitleLabel.text = "  Live Classes  "
                cell.bottomBlueButton.setTitle("  " + subModuleArray[indexPath.row].action + "  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
                let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date, attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].content_duration_formated, attributes: yourAttributes)
                let combination = NSMutableAttributedString()
                combination.append(NSAttributedString(string: "Session Date : "))
                combination.append(partOne)
                combination.append(NSAttributedString(string: " | Duration : "))
                combination.append(partTwo)
                cell.publishDateLabel.attributedText = combination
                
                let combination1 = NSMutableAttributedString()
                combination1.append(NSAttributedString(string: "Duration : "))
                combination1.append(partTwo)
                cell.durationLabel.attributedText = combination1
                
            case 8:
                cell.subTitleLabel.text = "  Discussion  "
                cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
                cell.publishDateLabel.text = ""
                let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_value, attributes: yourAttributes)
                let combination = NSMutableAttributedString()
                combination.append(NSAttributedString(string: "Published On : "))
                combination.append(partOne)
                combination.append(NSAttributedString(string: " | End Date : "))
                combination.append(partTwo)
                cell.durationLabel.attributedText = combination
                
            default:
                cell.subTitleLabel.text = "N/A"
                cell.bottomBlueButton.setTitle("N/A", for: UIControlState())
            }
            if indexPath.row == 0 {
                cell.topEyeImageView.image = subModuleArray[indexPath.row].completion_percentage.intValue == 0 ? UIImage(named:  "unlock_icon.png") : cell.topEyeImageView.image
            }
            
            cell.subTitleLabel.sizeToFit()
            cell.bottomBlueButton.sizeToFit()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        //
        //        switch subModuleArray[indexPath.row].content_type_id.integerValue {
        //        case 8:
        //            let cell = tableView.dequeueReusableCellWithIdentifier("ModuleMajorInnerTableCell1", forIndexPath: indexPath) as! ModuleMajorInnerTableCell
        //            cell.titleLabel.text = subModuleArray[indexPath.row].title
        //            cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
        //            cell.topEyeImageView.image = subModuleArray[indexPath.row].is_locked.boolValue ? UIImage(named:  "lock_icon.png") : subModuleArray[indexPath.row].completion_percentage.integerValue == 100 ? UIImage(named:  "eye_open.png") : UIImage(named:  "eye_continue.png")
        //            if indexPath.row == 0 {
        //                cell.topEyeImageView.image = subModuleArray[indexPath.row].completion_percentage.integerValue == 0 ? UIImage(named:  "unlock_icon.png") : cell.topEyeImageView.image
        //            }
        //            cell.userInteractionEnabled = !subModuleArray[indexPath.row].is_locked.boolValue
        //
        //            cell.subTitleLabel.text = "  Discussion  "
        //            cell.bottomBlueButton.setTitle("  View  ", forState: .Normal)
        //            cell.plusImageView.image = UIImage(named: "live_class1.PNG")
        //            cell.durationLabel.text = "Published On:" + subModuleArray[indexPath.row].start_date_value + "|" + "End Date:" + subModuleArray[indexPath.row].end_date_value
        //            cell.subTitleLabel.sizeToFit()
        //            cell.bottomBlueButton.sizeToFit()
        //            cell.selectionStyle = UITableViewCellSelectionStyle.None
        //            return cell
        //
        //        default:
        //
        //
        //            let cell = tableView.dequeueReusableCellWithIdentifier("ModuleMajorInnerTableCell", forIndexPath: indexPath) as! ModuleMajorInnerTableCell
        //            cell.titleLabel.text = subModuleArray[indexPath.row].title
        //            cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
        //            cell.topEyeImageView.image = subModuleArray[indexPath.row].is_locked.boolValue ? UIImage(named:  "lock_icon.png") : subModuleArray[indexPath.row].completion_percentage.integerValue == 100 ? UIImage(named:  "eye_open.png") : UIImage(named:  "eye_continue.png")
        //            cell.userInteractionEnabled = !subModuleArray[indexPath.row].is_locked.boolValue
        //
        //            switch subModuleArray[indexPath.row].content_type_id.integerValue {
        //            case 1:
        //                cell.subTitleLabel.text = "  Reference Note  "
        //                cell.bottomBlueButton.setTitle("  Read  ", forState: .Normal)
        //                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
        //                cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value + "|" + subModuleArray[indexPath.row].end_date_label + ":" + subModuleArray[indexPath.row].end_date_value
        //                cell.durationLabel.text = subModuleArray[indexPath.row].notes_count.integerValue == 1 ? String(format : "Duration:%@",subModuleArray[indexPath.row].content_duration_formated) : String(format : "Pages:%d | Duration:%@",subModuleArray[indexPath.row].notes_count.integerValue ,subModuleArray[indexPath.row].content_duration_formated)
        //            case 2:
        //                cell.subTitleLabel.text = "  Reference Video  "
        //                cell.bottomBlueButton.setTitle("  Watch Now  ", forState: .Normal)
        //                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
        //                cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
        //                cell.durationLabel.text = "Duration:" + subModuleArray[indexPath.row].content_duration_formated
        //
        //            case 3:
        //                cell.subTitleLabel.text = "  Interactive Video  "
        //                cell.bottomBlueButton.setTitle("  Attempted  ", forState: .Normal)
        //                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
        //                cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
        //                cell.durationLabel.text = subModuleArray[indexPath.row].notes_count.integerValue == 1 ? String(format : "Duration:%@",subModuleArray[indexPath.row].content_duration_formated) : String(format : "Pages:%d | Duration:%@",subModuleArray[indexPath.row].notes_count.integerValue ,subModuleArray[indexPath.row].content_duration_formated)
        //            case 4:
        //                cell.subTitleLabel.text = "  Assessment  "
        //                cell.bottomBlueButton.setTitle("  Attempted  ", forState: .Normal)
        //                cell.plusImageView.image = UIImage(named: "assessment1.png")
        //                cell.publishDateLabel.text = String(format: "Question:%d|Duration:%@|Max Marks:%d", subModuleArray[indexPath.row].total_questions.integerValue,subModuleArray[indexPath.row].total_duration,subModuleArray[indexPath.row].total_marks.integerValue)
        //                cell.durationLabel.text = "Published On:" + subModuleArray[indexPath.row].start_date_value + "|" + "End Date:" + subModuleArray[indexPath.row].end_date_value
        //            case 5:
        //                cell.subTitleLabel.text = "  Assignment  "
        //                cell.bottomBlueButton.setTitle("  View  ", forState: .Normal)
        //                cell.plusImageView.image = UIImage(named: "Assignment1.png")
        //                cell.publishDateLabel.text = String(format: "%@:%d|Mode:%@",subModuleArray[indexPath.row].total_marks_label,subModuleArray[indexPath.row].total_marks.integerValue,subModuleArray[indexPath.row].submission_mode)
        //                cell.durationLabel.text = "Published On:" + subModuleArray[indexPath.row].start_date_value + "|" + "End Date:" + subModuleArray[indexPath.row].end_date_value
        //            case 6:
        //                cell.subTitleLabel.text = "  Module Planner  "
        //                cell.bottomBlueButton.setTitle("  View  ", forState: .Normal)
        //                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
        //                cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
        //                cell.durationLabel.text = String(format : "Notes:%d, Videos:%d, Assessment: %d, Assignment:%d",subModuleArray[indexPath.row].notes_count.integerValue ,subModuleArray[indexPath.row].total_video.integerValue, subModuleArray[indexPath.row].total_assessment.integerValue, subModuleArray[indexPath.row].total_assignment.integerValue)
        //            case 7:
        //                cell.subTitleLabel.text = "  Live Classes  "
        //                cell.bottomBlueButton.setTitle("  " + subModuleArray[indexPath.row].action + "  ", forState: .Normal)
        //                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
        //                cell.publishDateLabel.text = "Session Date:" + subModuleArray[indexPath.row].start_date + "|Duration:" + subModuleArray[indexPath.row].content_duration_formated
        //                cell.durationLabel.text = String(format : "Duration:%@",subModuleArray[indexPath.row].content_duration_formated)
        //            case 8:
        //                cell.subTitleLabel.text = "  Discussion  "
        //                cell.bottomBlueButton.setTitle("  View  ", forState: .Normal)
        //                cell.plusImageView.image = UIImage(named: "live_class1.PNG")
        //                cell.publishDateLabel.text = ""
        //                cell.durationLabel.text = "Published On:" + subModuleArray[indexPath.row].start_date_value + "|" + "End Date:" + subModuleArray[indexPath.row].end_date_value
        //
        //            default:
        //                cell.subTitleLabel.text = "N/A"
        //                cell.bottomBlueButton.setTitle("N/A", forState: .Normal)
        //            }
        //            if indexPath.row == 0 {
        //                cell.topEyeImageView.image = subModuleArray[indexPath.row].completion_percentage.integerValue == 0 ? UIImage(named:  "unlock_icon.png") : cell.topEyeImageView.image
        //            }
        //            cell.subTitleLabel.sizeToFit()
        //            cell.bottomBlueButton.sizeToFit()
        //            cell.selectionStyle = UITableViewCellSelectionStyle.None
        //            return cell
        //        }
        //
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        switch subModuleArray[indexPath.row].content_type_id.intValue {
        case 1:
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_VIEW_NOTES ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                let noteObj : TENotes = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TENotes"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TENotes
                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferenceNoteViewController") as! ReferenceNoteViewController
                detailVC.noteObj = noteObj
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        case 2:
            //            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ReferenceVideoViewController") as! ReferenceVideoViewController
            //            //                detailVC.selectedAssessmentObj = assessmentObj
            //            self.navigationController?.pushViewController(detailVC, animated: true)
            
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_VIEW_INTERACTIVE_VIDEO ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                let noteObj : TEModuleVideo = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEModuleVideo"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEModuleVideo
                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferenceVideoViewController") as! ReferenceVideoViewController
                detailVC.noteObj = noteObj
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
                
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
            
        case 3:
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_VIEW_INTERACTIVE_VIDEO ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                let noteObj : TEModuleVideo = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEModuleVideo"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEModuleVideo
                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferenceVideoViewController") as! ReferenceVideoViewController
                detailVC.noteObj = noteObj
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                detailVC.selectedCourseObj = self.selectedCourseObj
                self.navigationController?.pushViewController(detailVC, animated: true)
                
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
            
        case 4:
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_GET_ASSESSMENT_DETAIL ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                let assessmentObj : TEAssessmentDetailData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessmentDetailData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssessmentDetailData
                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssessmentDetailViewController") as! AssessmentDetailViewController
                detailVC.selectedAssessmentObj = assessmentObj
                self.navigationController?.pushViewController(detailVC, animated: true)
                
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        case 5:
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_GET_ASSIGNMENT_DETAIL ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                
                let assignmentDetailObj : TEAssignmentDetail = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssignmentDetail"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssignmentDetail
                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssignmentDetailViewController") as! AssignmentDetailViewController
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                detailVC.assignmentDetailObj = assignmentDetailObj
                self.navigationController?.pushViewController(detailVC, animated: true)
                
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        case 6:
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_MODULE_PLANNER_CONTENT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                
                let subModuleArray : [TEModuleDetailData] = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEModuleDetailData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEModuleDetailData]
                
                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModulePlannerViewController") as! ModulePlannerViewController
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                detailVC.subModuleArray = subModuleArray
                self.navigationController?.pushViewController(detailVC, animated: true)
                
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        case 7:
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "batch_id=%d&content_id=%d",self.selectedCourseObj.id.intValue,subModuleArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_JOIN_LIVE_CLASS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                
                let cell = self.modulePlannerTableView.cellForRow(at: indexPath) as! ModuleMajorInnerTableCell
                if ((cell.bottomBlueButton.titleLabel?.text?.contains("Join")) == true) {
                    if let url = URL(string: ((successResponseDict.value(forKeyPath: "resultData.URL") as? String)?
                        .replacingOccurrences(of: "http", with: "connectpro"))!) {
                        let isInstalled = UIApplication.shared.canOpenURL(url)
                        if isInstalled {
                            
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            print("Installed")
                        }else{
                            let url1  = URL(string: "https://itunes.apple.com/us/app/adobe-connect/id430437503?mt=8")
                            if UIApplication.shared.canOpenURL(url1!) == true  {
                                UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    
                }else if (((cell.bottomBlueButton.titleLabel?.text?.contains("View Recorded")) == true) || ((cell.bottomBlueButton.titleLabel?.text?.contains("Concluded")) == true)){
                    if let url = URL(string: ((successResponseDict.value(forKeyPath: "resultData.URL") as? String)?
                        .replacingOccurrences(of: "http", with: "puffin"))!) {
                        let isInstalled = UIApplication.shared.canOpenURL(url)
                        if isInstalled {
                            
                            let tempURL = URL(string: "connectpro://www.google.com")
                            let isInstalled1 = UIApplication.shared.canOpenURL(tempURL!)
                            if !isInstalled1 {
                                let url1  = URL(string: "https://itunes.apple.com/us/app/adobe-connect/id430437503?mt=8")
                                if UIApplication.shared.canOpenURL(url1!) == true  {
                                    UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
                                }
                            }else{
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                print("Installed")
                            }
                        }else{
                            let url1  = URL(string: "https://itunes.apple.com/us/app/puffin-web-browser-free/id472937654?mt=8")
                            if UIApplication.shared.canOpenURL(url1!) == true  {
                                UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
//
//                if let url = NSURL(string: ((successResponseDict.valueForKeyPath("resultData.URL") as? String)?
//                    .stringByReplacingOccurrencesOfString("http", withString: "puffin"))!) {
//                    let isInstalled = UIApplication.sharedApplication().canOpenURL(url)
//                    if isInstalled {
//                        
//                        let tempURL = NSURL(string: "connectpro://www.google.com")
//                        let isInstalled1 = UIApplication.sharedApplication().canOpenURL(tempURL!)
//                        if !isInstalled1 {
//                            let url1  = NSURL(string: "https://itunes.apple.com/us/app/adobe-connect/id430437503?mt=8")
//                            if UIApplication.sharedApplication().canOpenURL(url1!) == true  {
//                                UIApplication.sharedApplication().openURL(url1!, options: [:], completionHandler: nil)
//                            }
//                        }else{
//                            UIApplication.sharedApplication().openURL(url, options: [:], completionHandler: nil)
//                            print("Installed")
//                        }
//                    }else{
//                        let url1  = NSURL(string: "https://itunes.apple.com/us/app/puffin-web-browser-free/id472937654?mt=8")
//                        if UIApplication.sharedApplication().canOpenURL(url1!) == true  {
//                            UIApplication.sharedApplication().openURL(url1!, options: [:], completionHandler: nil)
//                        }
//                    }
//                }
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        case 8:
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_GET_DISCUSSION_COMMENT_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                let discussionDetailData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEDiscussionCommentData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEDiscussionCommentData
                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DiscussionListViewController") as! DiscussionListViewController
                detailVC.discussionDetailData = discussionDetailData
                let discussionObj = TEDiscussionData()
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                discussionObj.content_type_id = self.subModuleArray[indexPath.row].content_type_id
                detailVC.mainDiscussionObject = discussionObj
                self.navigationController?.pushViewController(detailVC, animated: true)
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        default:
            print("")
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        switch subModuleArray[indexPath.row].content_type_id.intValue {
        case 8:
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 195.0+addedWidth
        default:
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 220.0+addedWidth
        }
    }
    
}
