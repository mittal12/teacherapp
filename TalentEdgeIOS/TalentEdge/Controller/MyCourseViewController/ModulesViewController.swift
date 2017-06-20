//
//  ModulesViewController.swift
//  TalentEdge
//
//

import UIKit
class ModulesViewController: UIViewController {
    
    @IBOutlet weak var modulesTableView: UITableView!
    var modulesArray : [TEModuleData]!
    var subModuleArray : [TEModuleDetailData]!
    var isCameFromDrawer : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //        self.navigationController?.navigationBarHidden = true
        modulesArray = [TEModuleData]()
        subModuleArray = [TEModuleDetailData]()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modulesTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        modulesTableView.showsVerticalScrollIndicator = false
        modulesTableView.tableFooterView = UIView()
        fetctDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func fetctDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "batch_id=%d",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_MODULE_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.modulesArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEModuleData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEModuleData]
            for item in self.modulesArray {
                item.is_default_open = NSNumber(value: false as Bool)
            }
            self.modulesTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }

    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return modulesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        return modulesArray[section].is_default_open.boolValue ? subModuleArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  80.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width - 0, height: 80))
        let headerSubView = UIView(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width - 20, height: 70))
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.size.width - 80, height: 70))
        headerSubView.backgroundColor = UIColor.white
        headerView.addSubview(headerSubView)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 13)
        headerLabel.textColor = modulesArray[section].is_default_open.boolValue ? DataUtils.colorWithHexString("299DD5") : UIColor.black
        headerLabel.numberOfLines = 3
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.text = modulesArray[section].name
        headerView.addSubview(headerLabel)
        let headerButton = UIButton(frame: CGRect(x: tableView.frame.size.width - 50, y: 25, width: 30, height: 30))
        headerButton.setImage(modulesArray[section].is_default_open.boolValue == true ? UIImage(named : "minus_icon.png") : UIImage(named : "plus.png"), for: UIControlState())
        headerButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(extractButtonAction(_:)), for: .touchUpInside)
        headerView.addSubview(headerButton)
        return headerView
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
            cell.subTitleLabel.sizeToFit()
//            cell.bottomBlueButton.sizeToFit()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        default:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleMajorInnerTableCell", for: indexPath) as! ModuleMajorInnerTableCell
            cell.titleLabel.text = subModuleArray[indexPath.row].title
            cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
            //        if subModuleArray[indexPath.row].content_type_id.integerValue == 4 {
            //        cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
            //        }else if subModuleArray[indexPath.row].content_type_id.integerValue == 8 {
            //            cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
            //        }else {
            //
            //        }
            
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
                combination.append(NSAttributedString(string: "Duration : "))
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
                combination1.append(NSAttributedString(string: " | Mode : "))
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
            
            cell.subTitleLabel.sizeToFit()
//            cell.bottomBlueButton.sizeToFit()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
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
                detailVC.selectedCourseObj = self.selectedCourseObj
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                detailVC.noteObj = noteObj
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
                detailVC.selectedCourseObj = self.selectedCourseObj
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
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                detailVC.selectedAssessmentObj = assessmentObj
                detailVC.selectedCourseObj = self.selectedCourseObj
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
                detailVC.selectedCourseObj = self.selectedCourseObj
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
                detailVC.subModuleArray = subModuleArray
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                detailVC.selectedCourseObj = self.selectedCourseObj
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
                let cell = self.modulesTableView.cellForRow(at: indexPath) as! ModuleMajorInnerTableCell
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
                discussionObj.content_type_id = self.subModuleArray[indexPath.row].content_type_id
                detailVC.mainDiscussionObject = discussionObj
                detailVC.moduleData = self.subModuleArray[indexPath.row]
                detailVC.selectedCourseObj = self.selectedCourseObj
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
            return 135.0+addedWidth
        default:
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 155.0+addedWidth
        }
    }
    
    func extractButtonAction (_ sender : UIButton) {
        let headers : [String:String] = [
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        for i in 0..<modulesArray.count {
            if i != sender.tag {
                modulesArray[i].is_default_open = NSNumber(value: false as Bool)
            }
            
        }
        modulesArray[sender.tag].is_default_open = NSNumber(value: !modulesArray[sender.tag].is_default_open.boolValue as Bool)
        if modulesArray[sender.tag].is_default_open.boolValue {
            let str = String(format: "module_id=%d",modulesArray[sender.tag].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_GET_MODULE_CONTENT_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                self.subModuleArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEModuleDetailData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEModuleDetailData]
                //                self.modulesTableView.beginUpdates()
                self.modulesTableView.reloadData()
                //                self.modulesTableView.endUpdates()
                
            }) { (errorResponseDict) -> Void in
                self.modulesTableView.reloadData()
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        }else {
            //            self.modulesTableView.beginUpdates()
            self.modulesTableView.reloadData()
            //            self.modulesTableView.endUpdates()
            subModuleArray.removeAll()
        }
    }
    
}

class ModuleMiniTableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
}

class ModuleMajorTableCell: UITableViewCell {
    @IBOutlet weak var subModuleTableView: UITableView!
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleMajorInnerTableCell", for: indexPath) as! ModuleMajorInnerTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndedfxPath indexPath: IndexPath) -> CGFloat {
        let addedWidth:CGFloat = DataUtils.getDynamicHeight("fgd;gjd;gklj;ygjkl;ghtg;ghk;rttopigtertuep[590rtdfsghldfjkgdf;jkdfzg;dfsghdprgtheieorughipugterfgiogtpuughfjklgdstldhjggklghdfsjgldfsgeriopterghfrtgrtjgdfkl;ghldrstghhijopiltghhjrtgio;rtjgl;grtgkl;j;gghiopj", width: tableView.frame.size.width - 48)
        return 170.0+addedWidth
    }
}

class ModuleMajorInnerTableCell: UITableViewCell {
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
    
}
