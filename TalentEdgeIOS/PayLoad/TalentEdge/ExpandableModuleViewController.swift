//
//  ExpandableModuleViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 10/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class ExpandableModuleViewController: UIViewController  , UITableViewDataSource ,UITableViewDelegate{

    @IBOutlet weak var modulesTableView: UITableView!
    
    var modulesArray : [TEModuleData]!
    var subModuleArray : [TEModuleDetailData]!
    var isCameFromDrawer : Bool!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modulesArray = [TEModuleData]()
        subModuleArray = [TEModuleDetailData]()
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        modulesTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        modulesTableView.showsVerticalScrollIndicator = false
        modulesTableView.tableFooterView = UIView()
        fetctDataFromServer()
        self.tableView.separatorStyle = .none

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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modulesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modulesArray[section].is_default_open.boolValue ? subModuleArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell.tag = 100 + indexPath.row
            return cell
            
        default:
            
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleMajorInnerTableCell", for: indexPath) as! ModuleMajorInnerTableCell
//            cell.titleLabel.text = subModuleArray[indexPath.row].title
          //  cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
            //        if subModuleArray[indexPath.row].content_type_id.integerValue == 4 {
            //        cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
            //        }else if subModuleArray[indexPath.row].content_type_id.integerValue == 8 {
            //            cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
            //        }else {
            //
            //        }
            
            switch subModuleArray[indexPath.row].content_type_id.intValue {
                
                
            case 1:   //notes
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableCell", for: indexPath) as! NotesTableCell
                cell.titleLabel.text = subModuleArray[indexPath.row].title
                cell.descriptiveTextVIew.text = subModuleArray[indexPath.row].desc
                cell.subTitleLabel.text = "  Reference Notes  "
               // cell.bottomBlueButton.setTitle("  Read  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class")
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
                    
                    cell.leftBottomLabel.text = "Completed"
                    cell.rightUpperLabel.text  =  "\(subModuleArray[indexPath.row].cnt_completed) Out of \(subModuleArray[indexPath.row].notes_count)"
                    
                    
                    cell.rightBottomLabel.text = "Completed"
                    cell.leftUpperLabel.text = ""
                    cell.leftUpperLabel.text = String(describing: subModuleArray[indexPath.row].avg_completion_percentage)
                    
                    cell.leftUpperLabel.text = cell.leftUpperLabel.text! + "%"
                    //draw circle   cell.circleAttandanceLabel
                    drawFullCircle(end: CGPoint(x: cell.leftUpperLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.leftUpperLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage))
                    
                    drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing: subModuleArray[indexPath.row].avg_completion_percentage))
                    cell.tag = 100 + indexPath.row
                    
                    
                    
                    cell.leftUpperLabel.textColor = UIColor.init(hexString:"2F9DD4")
                    
                   // cell.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
                   // cell.layer.borderWidth = 1
                    cell.mainView.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
                    cell.mainView.layer.borderWidth = 1
                    cell.mainView.layer.cornerRadius = 3
                    cell.subTitleLabel.layer.cornerRadius = cell.subTitleLabel.frame.size.height/2
                    
                    
//                    cell.mainView.layer.shadowRadius = 1.5
//                    cell.mainView.layer.shadowColor = UIColor(red: CGFloat(0 / 255.0), green: CGFloat(0 / 255.0), blue: CGFloat(0 / 255.0), alpha: CGFloat(1.0)).cgColor
//                    cell.mainView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
//                    cell.mainView.layer.shadowOpacity = 0.9
//                    cell.mainView.layer.masksToBounds = false
//                    let shadowInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, -1.5, 0)
//                    let shadowPath = UIBezierPath(rect: UIEdgeInsetsInsetRect(cell.mainView.bounds, shadowInsets))
//                    cell.mainView.layer.shadowPath = shadowPath.cgPath
                    cell.subTitleLabel.clipsToBounds = true
                    cell.selectionStyle = .none
//                    cell.subTitleLabel.sizeToFit()
//                    cell.titleLabel.sizeToFit()

            }
                
                            return cell
                
            case 2:   //video
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableCell", for: indexPath) as! NotesTableCell
                cell.titleLabel.text = subModuleArray[indexPath.row].title
                cell.descriptiveTextVIew.text = subModuleArray[indexPath.row].desc
                
                cell.subTitleLabel.text = "  Reference Video  "
               // cell.bottomBlueButton.setTitle("  Watch Now  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class")
                
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
                
                
                
                
                
                cell.leftBottomLabel.text = "Completed"
                cell.rightUpperLabel.text  =  "\(subModuleArray[indexPath.row].cnt_completed) Out of \(subModuleArray[indexPath.row].cnt_not_completed)"
                
//                cell.attendanceLabel.text = ""
//                cell.circleAttandanceLabel.text = ""
                
                cell.rightBottomLabel.text = "Completed"
                cell.leftUpperLabel.text = ""
                
                cell.leftUpperLabel.text = String(describing: (subModuleArray[indexPath.row].avg_completion_percentage))
                
                cell.leftUpperLabel.text =  cell.leftUpperLabel.text! + "%"
                
                //draw circle   cell.circleAttandanceLabel
                drawFullCircle(end: CGPoint(x: cell.leftUpperLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.leftUpperLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage))
                
                
                
                drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing: subModuleArray[indexPath.row].avg_completion_percentage))
                
//
//                cell.tag = 100 + indexPath.row
                
//                cell.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
//                cell.layer.borderWidth = 1
                cell.mainView.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
                cell.mainView.layer.borderWidth = 1
                cell.mainView.layer.cornerRadius = 3

                cell.subTitleLabel.layer.cornerRadius = cell.subTitleLabel.frame.size.height/2
                
                
//                cell.mainView.layer.shadowRadius = 1.5
//                cell.mainView.layer.shadowColor = UIColor(red: CGFloat(245.0 / 255.0), green: CGFloat(245.0 / 255.0), blue: CGFloat(245.0 / 255.0), alpha: CGFloat(1.0)).cgColor
//                cell.mainView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
//                cell.mainView.layer.shadowOpacity = 0.9
//                cell.mainView.layer.masksToBounds = false
//                let shadowInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, -1.5, 0)
//                let shadowPath = UIBezierPath(rect: UIEdgeInsetsInsetRect(cell.mainView.bounds, shadowInsets))
//                cell.mainView.layer.shadowPath = shadowPath.cgPath
 cell.subTitleLabel.clipsToBounds = true
                cell.selectionStyle = .none
//                cell.subTitleLabel.sizeToFit()
//                cell.titleLabel.sizeToFit()
                            return cell
                
                
                
            case 3:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableCell", for: indexPath) as! NotesTableCell
                cell.titleLabel.text = subModuleArray[indexPath.row].title
                cell.descriptiveTextVIew.text = subModuleArray[indexPath.row].desc
                
                cell.subTitleLabel.text = "  Interactive Video  "
               // cell.bottomBlueButton.setTitle("  Attempted  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class")
                cell.publishDateLabel.text = subModuleArray[indexPath.row].start_date_label + ":" + subModuleArray[indexPath.row].start_date_value
                
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
                //cell.durationLabel.attributedText = combination1
                
                cell.leftBottomLabel.text = "Completed"
                cell.rightUpperLabel.text  =  "\(subModuleArray[indexPath.row].cnt_completed) Out of \(subModuleArray[indexPath.row].cnt_not_completed)"
                
//                cell.attendanceLabel.text = ""
//                cell.circleAttandanceLabel.text = ""
                
                cell.rightBottomLabel.text = "Completed"
                
                
                
                
                cell.leftUpperLabel.text = ""
                cell.leftUpperLabel.text = String(describing:subModuleArray[indexPath.row].avg_completion_percentage)
                cell.leftUpperLabel.text = cell.leftUpperLabel.text! + "%"
                
                //draw circle   cell.circleAttandanceLabel
                drawFullCircle(end: CGPoint(x: cell.leftUpperLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.leftUpperLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage))
                
                
                //
                //                drawFullCircle(end: CGPoint(x: cell.leftMiddleView.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.leftMiddleView, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage))
                
                drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing: subModuleArray[indexPath.row].avg_completion_percentage))
                cell.tag = 100 + indexPath.row
                
//                cell.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
//                cell.layer.borderWidth = 1
                cell.mainView.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
                cell.mainView.layer.borderWidth = 1
                cell.mainView.layer.cornerRadius = 3

                cell.subTitleLabel.layer.cornerRadius = cell.subTitleLabel.frame.size.height/2
                
//                
//                cell.mainView.layer.shadowRadius = 1.5
//                cell.mainView.layer.shadowColor = UIColor(red: CGFloat(245.0 / 255.0), green: CGFloat(245.0 / 255.0), blue: CGFloat(245.0 / 255.0), alpha: CGFloat(1.0)).cgColor
//                cell.mainView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
//                cell.mainView.layer.shadowOpacity = 0.9
//                cell.mainView.layer.masksToBounds = false
//                let shadowInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, -1.5, 0)
//                let shadowPath = UIBezierPath(rect: UIEdgeInsetsInsetRect(cell.mainView.bounds, shadowInsets))
//                cell.mainView.layer.shadowPath = shadowPath.cgPath
//                cell.subTitleLabel.sizeToFit()
//                cell.titleLabel.sizeToFit()
                 cell.subTitleLabel.clipsToBounds = true
                cell.selectionStyle = .none
                            return cell
   
                
            case 4: //assessment
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentTableCellCustom", for: indexPath) as! AssessmentTableCellCustom
                cell.tittleLabel.text = subModuleArray[indexPath.row].title
                cell.descriptionLabel.text = subModuleArray[indexPath.row].desc
                
                
                cell.subtitleLabel.text = subModuleArray[indexPath.row].module_name
                //cell.bottomBlueButton.setTitle("  Attempted  ", for: UIControlState())
                cell.upperImageView.image = UIImage(named: "assessmentnew")
                
                let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_value, attributes: yourAttributes)
                let combination = NSMutableAttributedString()
                combination.append(NSAttributedString(string: "Published On : "))
                combination.append(partOne)
                combination.append(NSAttributedString(string: " | End Date : "))
                combination.append(partTwo)
                cell.publicationLabel.attributedText = combination
                
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
                
                cell.questionLabel.attributedText = combination1
                
                 cell.circleLabel.text = String(describing:subModuleArray[indexPath.row].avg_completion_percentage)
                cell.circleLabel.text = cell.circleLabel.text! + "%"

                cell.scoreLabel.text = "Average Score"
                cell.studentAttemptedValueLabel.text = String(describing: subModuleArray[indexPath.row].cnt_attempted)
                cell.studentNotAttemptedValueLabel.text = String(describing: subModuleArray[indexPath.row].cnt_not_attempted)
                cell.studentAttemptedLabel.text = "Students Attempted"
                cell.studentNotAttemptedLabel.text  = "Student unAttempted"
                // cell.studentAttemptedImageView.image =  UIImage(named:"")
                
                //cell.studentnotAttemptedImageView.image = UIImage(named:"")
                drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage))
               
               
                
                cell.tag = 100 + indexPath.row
              let partofMode = NSMutableAttributedString(string: subModuleArray[indexPath.row].test_type_label, attributes: yourAttributes)
                
                
                
                let combination2 = NSMutableAttributedString()
                combination2.append(NSAttributedString(string: "Mode:"))
                combination2.append(partofMode)
                cell.modeLabel.attributedText = combination2
               // cell.subtitleLabel.sizeToFit()
                //cell.tittleLabel.sizeToFit()
                
                cell.mainUperView.layer.cornerRadius = 1
                cell.mainUperView.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
                cell.mainUperView.layer.borderWidth = 1
                cell.mainUperView.layer.cornerRadius = 3

                
                
                cell.selectionStyle = .none
                            return cell
                
                
            case 5:  //assignment
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableCell", for: indexPath) as! AssignmentTableCell
                cell.titleLabel.text = subModuleArray[indexPath.row].title
                cell.subtitleLabel.text = subModuleArray[indexPath.row].module_name
                //cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
                cell.upperImageView.image = UIImage(named: "assignmentnew.png")
                
                let part1 = NSMutableAttributedString(string: subModuleArray[indexPath.row].total_marks_label)
                let part2 = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_marks.intValue), attributes: yourAttributes)
                let part3 = NSMutableAttributedString(string: subModuleArray[indexPath.row].submission_mode, attributes: yourAttributes)
                let combination1 = NSMutableAttributedString()
                combination1.append(part1)
                combination1.append(NSAttributedString(string: " : "))
                combination1.append(part2)
                combination1.append(NSAttributedString(string: " | Mode : "))
                combination1.append(part3)
                cell.publishedLabel.attributedText = combination1
                
                
                let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_value, attributes: yourAttributes)
                let combination = NSMutableAttributedString()
                combination.append(NSAttributedString(string: "Published On : "))
                combination.append(partOne)
                combination.append(NSAttributedString(string: " | End Date : "))
                combination.append(partTwo)
                cell.publishedLabel.attributedText = combination
                
                cell.typeLabel.text = "Type"
                cell.typeLabelValueLabel.text = subModuleArray[indexPath.row].is_graded
                cell.multipleSubmissionLabel.text = "Multiple Submission"
                //cell.multipleSubmissionValueLabel.text = subModuleArray[indexPath.row].
                //ask it          // cell.multipleSubmissionValueLabel.text =
                cell.marksLabel.text = subModuleArray[indexPath.row].total_marks_label
                
                cell.marksValueLabel.text =  String(describing: subModuleArray[indexPath.row].total_marks)
                
                cell.passingMarksLabel.text =  subModuleArray[indexPath.row].passing_marks_label
                
                cell.passingMarksValueLabel.text = subModuleArray[indexPath.row].passing_marks
                cell.ModelLabel.text  = "Mode"
                
                cell.modeValueLabel.text =  subModuleArray[indexPath.row].submission_mode
                
                //ask it       //       cell.secondDescriptiveLabel.text =  String(subModuleArray[indexPath.row].desc)
                
                cell.completedLabel.text = "Completed"
                
                cell.studentNotUploadedValueLabe.text =  String(describing: subModuleArray[indexPath.row].cnt_not_submitted)
                
                cell.studentsUploadValueLabel.text = String(describing: subModuleArray[indexPath.row].cnt_submitted)
                
                cell.studentUploadLabel.text = "Students Uploaded"
                
                cell.studentNotUploadLabel.text = "Stduents Not Uploaded"
                
                cell.studentNotImageView.image = UIImage(named:"")
                
                cell.studentImageView.image = UIImage(named:"")
                
                cell.secondDescriptiveLabel.text = subModuleArray[indexPath.row].desc
                
                
                //draw circle
                //  cell.circleAttandanceLabel
                drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage))
                
                cell.circleLabel.text  =  String(describing: subModuleArray[indexPath.row].avg_completion_percentage)
                cell.circleLabel.text =   cell.circleLabel.text! + "%"
                cell.tag = 100 + indexPath.row
                cell.mainUpperView.layer.cornerRadius = 1
                cell.mainUpperView.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
                cell.mainUpperView.layer.borderWidth = 1
                cell.mainUpperView.layer.cornerRadius = 3
                cell.selectionStyle = .none
             //   cell.subtitleLabel.sizeToFit()
               // cell.titleLabel.sizeToFit()
                    return cell
            case 6:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleMajorInnerTableCell", for: indexPath) as! ModuleMajorInnerTableCell
                cell.titleLabel.text = subModuleArray[indexPath.row].title
               // cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
                cell.subTitleLabel.text = "  Module Planner  "
                cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class.PNG")
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
                
                cell.tag = 100 + indexPath.row
//                cell.subTitleLabel.sizeToFit()
//                cell.titleLabel.sizeToFit()
                cell.selectionStyle = .none
                
                            return cell
                
                
                
                
                
            case 7:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LiveClassTableCell", for: indexPath) as! LiveClassTableCell
                cell.titleLabel.text = subModuleArray[indexPath.row].title
                cell.descriptionTextVIew.text = "Live Class"
                
                cell.subTitleLabel.text = subModuleArray[indexPath.row].module_name
                //cell.bottomBlueButton.setTitle("  " + subModuleArray[indexPath.row].action + "  ", for: UIControlState())
                cell.plusImageView.image = UIImage(named: "live_class")
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
                
                cell.attendanceLabel.text = "Attendance"
                
                cell.circleAttandanceLabel.text = String(describing: subModuleArray[indexPath.row].participation_percentage_in_live_class)
                
                cell.circleAttandanceLabel.text =   cell.circleAttandanceLabel.text! + "%"
                
                
                //draw circle
                //  cell.circleAttandanceLabel
                drawFullCircle(end: CGPoint(x: cell.circleAttandanceLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleAttandanceLabel, completionPercentage: Double(subModuleArray[indexPath.row].participation_percentage_in_live_class))
                
                cell.leftUpperLabel.text  =  String(describing: subModuleArray[indexPath.row].total_invitees_attended_in_live_class)
                cell.leftUpperLabel.text = cell.leftUpperLabel.text! + " Students"
                
                //  cell.leftMiddleView
                
                cell.leftBottomLabel.text = "Live Session"
                
                // cell.leftImageView.image = UIImage(named:"")
                
                cell.rightUpperLabel.text  = String(describing: subModuleArray[indexPath.row].total_invitees_attended_in_recorded_class )
                cell.rightUpperLabel.text = cell.rightUpperLabel.text!  + " Stduents"
                
                
                        cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
                
                cell.rightBottomLabel.text = "Recorded Sesssion"
                
                //cell.rightImageView.image = UIImage(named:"")
                
                drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing: subModuleArray[indexPath.row].participation_percentage_in_recorded_class))
                drawLineFromPoint(CGPoint(x: Double(cell.leftMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.leftMiddleView), String(describing: subModuleArray[indexPath.row].participation_percentage_in_live_class))
                cell.tag = 100 + indexPath.row
                
                
                
                cell.selectionStyle = .none
                //cell.subTitleLabel.sizeToFit()
                //cell.titleLabel.sizeToFit()
                cell.mainUpperViewForCell.layer.cornerRadius = 1
                cell.mainUpperViewForCell.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
                cell.mainUpperViewForCell.layer.borderWidth = 1
                cell.mainUpperViewForCell.layer.cornerRadius = 3

                            return cell
            case 8:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleMajorInnerTableCell", for: indexPath) as! ModuleMajorInnerTableCell
                cell.titleLabel.text = subModuleArray[indexPath.row].title
            //    cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
                
                
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
                cell.tag = 100 + indexPath.row
                cell.selectionStyle = .none
//                cell.subTitleLabel.sizeToFit()
//                cell.titleLabel.sizeToFit()
                
                
                
                
                            return cell
            default: break
//                cell.subTitleLabel.text = "N/A"
//                cell.bottomBlueButton.setTitle("N/A", for: UIControlState())
//                cell.tag = 100 + indexPath.row
            }
            
//            cell.subTitleLabel.sizeToFit()
//            //            cell.bottomBlueButton.sizeToFit()
//            cell.selectionStyle = UITableViewCellSelectionStyle.none

        }
return modulesTableView.dequeueReusableCell(withIdentifier: "hi")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch subModuleArray[indexPath.row].content_type_id.intValue {
        case 1:
//            let headers : [String:String] = [
//                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
//                "token": ModelManager.singleton.loginData.token,
//                "deviceType": "IOS"
//            ]
//            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
//            ServerCommunication.singleton.requestWithPost(API_VIEW_NOTES ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
//                print(successResponseDict)
                //let noteObj : TENotes = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TENotes"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TENotes
                
                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotesDetailsViewController") as! NotesDetailsViewController
                detailVC.selectedCourseObj = self.selectedCourseObj
                detailVC.notesObj = self.subModuleArray[indexPath.row]
                detailVC.content_type_id = self.subModuleArray[indexPath.row].content_type_id
                detailVC.content_id = self.subModuleArray[indexPath.row].module_id
                detailVC.type = 1
               // detailVC.noteObj = noteObj
                self.navigationController?.pushViewController(detailVC, animated: true)
//            }) { (errorResponseDict) -> Void in
//                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
//            }
        case 2:
            //            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ReferenceVideoViewController") as! ReferenceVideoViewController
            //            //                detailVC.selectedAssessmentObj = assessmentObj
            //            self.navigationController?.pushViewController(detailVC, animated: true)
            
//            let headers : [String:String] = [
//                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
//                "token": ModelManager.singleton.loginData.token,
//                "deviceType": "IOS"
//            ]
//            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
//            ServerCommunication.singleton.requestWithPost(API_VIEW_INTERACTIVE_VIDEO ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
//                print(successResponseDict)
//                let noteObj : TEModuleVideo = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEModuleVideo"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEModuleVideo
//                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferenceVideoViewController") as! ReferenceVideoViewController
//                detailVC.noteObj = noteObj
//                detailVC.moduleData = self.subModuleArray[indexPath.row]
//                detailVC.selectedCourseObj = self.selectedCourseObj
//                self.navigationController?.pushViewController(detailVC, animated: true)
//                
//            }) { (errorResponseDict) -> Void in
//                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
//            }
            
            
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotesDetailsViewController") as! NotesDetailsViewController
            detailVC.selectedCourseObj = self.selectedCourseObj
            detailVC.notesObj = self.subModuleArray[indexPath.row]
            detailVC.content_type_id = self.subModuleArray[indexPath.row].content_type_id
            detailVC.content_id = self.subModuleArray[indexPath.row].module_id
             detailVC.type = 2
            // detailVC.noteObj = noteObj
            self.navigationController?.pushViewController(detailVC, animated: true)
            
            
        case 3:
//            let headers : [String:String] = [
//                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
//                "token": ModelManager.singleton.loginData.token,
//                "deviceType": "IOS"
//            ]
//            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
//            ServerCommunication.singleton.requestWithPost(API_VIEW_INTERACTIVE_VIDEO ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
//                print(successResponseDict)
//                let noteObj : TEModuleVideo = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEModuleVideo"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEModuleVideo
//                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferenceVideoViewController") as! ReferenceVideoViewController
//                detailVC.noteObj = noteObj
//                detailVC.moduleData = self.subModuleArray[indexPath.row]
//                detailVC.selectedCourseObj = self.selectedCourseObj
//                self.navigationController?.pushViewController(detailVC, animated: true)
//                
//            }) { (errorResponseDict) -> Void in
//                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
//            }
//            
            
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotesDetailsViewController") as! NotesDetailsViewController
            detailVC.selectedCourseObj = self.selectedCourseObj
            detailVC.notesObj = self.subModuleArray[indexPath.row]
            detailVC.content_type_id = self.subModuleArray[indexPath.row].content_type_id
            detailVC.content_id = self.subModuleArray[indexPath.row].module_id
             detailVC.type = 3
            // detailVC.noteObj = noteObj
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        case 4:
//            let headers : [String:String] = [
//                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
//                "token": ModelManager.singleton.loginData.token,
//                "deviceType": "IOS"
//            ]
//            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
//            ServerCommunication.singleton.requestWithPost(API_GET_ASSESSMENT_DETAIL ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
//                print(successResponseDict)
//                let assessmentObj : TEAssessmentDetailData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessmentDetailData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssessmentDetailData
//                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssessmentDetailViewController") as! AssessmentDetailViewController
//                detailVC.moduleData = self.subModuleArray[indexPath.row]
//                detailVC.selectedAssessmentObj = assessmentObj
//                detailVC.selectedCourseObj = self.selectedCourseObj
//                self.navigationController?.pushViewController(detailVC, animated: true)
//                
//            }) { (errorResponseDict) -> Void in
//                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
//                
//            }
            
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomControllerForDetailAssessment") as! CustomControllerForDetailAssessment
            detailVC.selectedCourseObj = self.selectedCourseObj
            detailVC.assignmentObj = self.subModuleArray[indexPath.row]
            detailVC.content_type_id = self.subModuleArray[indexPath.row].content_type_id
            detailVC.content_id = self.subModuleArray[indexPath.row].module_id
            // detailVC.noteObj = noteObj
            self.navigationController?.pushViewController(detailVC, animated: true)

            
        case 5:
//            let headers : [String:String] = [
//                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
//                "token": ModelManager.singleton.loginData.token,
//                "deviceType": "IOS"
//            ]
//            let str = String(format: "content_id=%d",subModuleArray[indexPath.row].id.intValue)
//            ServerCommunication.singleton.requestWithPost(API_GET_ASSIGNMENT_DETAIL ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
//                print(successResponseDict)
//                
//                let assignmentDetailObj : TEAssignmentDetail = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssignmentDetail"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssignmentDetail
//                let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssignmentDetailViewController") as! AssignmentDetailViewController
//                detailVC.moduleData = self.subModuleArray[indexPath.row]
//                detailVC.assignmentDetailObj = assignmentDetailObj
//                detailVC.selectedCourseObj = self.selectedCourseObj
//                self.navigationController?.pushViewController(detailVC, animated: true)
//                
//            }) { (errorResponseDict) -> Void in
//                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
//            }
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomContollerForDetailAssignment") as! CustomContollerForDetailAssignment
            detailVC.selectedCourseObj = self.selectedCourseObj
            detailVC.assignmentObj = self.subModuleArray[indexPath.row]
            detailVC.content_type_id = self.subModuleArray[indexPath.row].content_type_id
            detailVC.content_id = self.subModuleArray[indexPath.row].module_id
            // detailVC.noteObj = noteObj
            self.navigationController?.pushViewController(detailVC, animated: true)
            
            
            
            
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
            
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomControllerForLiveClasses") as! CustomControllerForLiveClasses
            detailVC.selectedCourseObj = self.selectedCourseObj
            detailVC.liveClassObj = self.subModuleArray[indexPath.row]
            detailVC.content_type_id = self.subModuleArray[indexPath.row].content_type_id
            detailVC.content_id = self.subModuleArray[indexPath.row].module_id
            // detailVC.noteObj = noteObj
            self.navigationController?.pushViewController(detailVC, animated: true)

            
//            let str = String(format: "batch_id=%d&content_id=%d",self.selectedCourseObj.id.intValue,subModuleArray[indexPath.row].id.intValue)
//            ServerCommunication.singleton.requestWithPost(API_JOIN_LIVE_CLASS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
//                print(successResponseDict)
//                let cell = self.modulesTableView.cellForRow(at: indexPath) as! ModuleMajorInnerTableCell
//                if ((cell.bottomBlueButton.titleLabel?.text?.contains("Join")) == true) {
//                    if let url = URL(string: ((successResponseDict.value(forKeyPath: "resultData.URL") as? String)?
//                        .replacingOccurrences(of: "http", with: "connectpro"))!) {
//                        let isInstalled = UIApplication.shared.canOpenURL(url)
//                        if isInstalled {
//                            
//                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                            print("Installed")
//                            
//                        }else{
//                            let url1  = URL(string: "https://itunes.apple.com/us/app/adobe-connect/id430437503?mt=8")
//                            if UIApplication.shared.canOpenURL(url1!) == true  {
//                                UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
//                            }
//                        }
//                    }
//                    
//                }else if (((cell.bottomBlueButton.titleLabel?.text?.contains("View Recorded")) == true) || ((cell.bottomBlueButton.titleLabel?.text?.contains("Concluded")) == true)){
//                    if let url = URL(string: ((successResponseDict.value(forKeyPath: "resultData.URL") as? String)?
//                        .replacingOccurrences(of: "http", with: "puffin"))!) {
//                        let isInstalled = UIApplication.shared.canOpenURL(url)
//                        if isInstalled {
//                            
//                            let tempURL = URL(string: "connectpro://www.google.com")
//                            let isInstalled1 = UIApplication.shared.canOpenURL(tempURL!)
//                            if !isInstalled1 {
//                                let url1  = URL(string: "https://itunes.apple.com/us/app/adobe-connect/id430437503?mt=8")
//                                if UIApplication.shared.canOpenURL(url1!) == true  {
//                                    UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
//                                }
//                            }else{
//                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                                print("Installed")
//                            }
//                        }else{
//                            let url1  = URL(string: "https://itunes.apple.com/us/app/puffin-web-browser-free/id472937654?mt=8")
//                            if UIApplication.shared.canOpenURL(url1!) == true  {
//                                UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
//                            }
//                        }
//                    }
//                }
//            }) { (errorResponseDict) -> Void in
//                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
//            }
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
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.00001
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width - 0, height: 50))
        let headerSubView = UIView(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width - 20, height: 40))
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width - 80, height: 40))
        headerSubView.backgroundColor = UIColor.white
        headerView.addSubview(headerSubView)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 13)
        headerLabel.textColor = modulesArray[section].is_default_open.boolValue ? DataUtils.colorWithHexString("299DD5") : UIColor.black
        headerLabel.numberOfLines = 3
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.text = modulesArray[section].name
        headerView.addSubview(headerLabel)
        let headerButton = UIButton(frame: CGRect(x: tableView.frame.size.width - 50, y: 8, width: 30, height: 30))
        headerButton.setImage(modulesArray[section].is_default_open.boolValue == true ? UIImage(named : "minus_icon.png") : UIImage(named : "plus.png"), for: UIControlState())
        headerButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(extractButtonAction(_:)), for: .touchUpInside)
        headerView.addSubview(headerButton)
        return headerView

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch subModuleArray[indexPath.row].content_type_id.intValue {
        case 8:
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 135.0+addedWidth
            
        case 1,2,3:
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 226 + addedWidth
            
        case 4: //assessment
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 280+addedWidth
        case 5:
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 295 + addedWidth
        case 7:
            
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 270+addedWidth

        default:
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
            return 155 + addedWidth
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  60.0
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
               
                self.modulesTableView.reloadData()
                
            }) { (errorResponseDict) -> Void in
                self.modulesTableView.reloadData()
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        }else {
           
            self.modulesTableView.addScalableCover(with:  ModelManager.singleton.courseImage)
            self.modulesTableView.reloadData()
            //            self.modulesTableView.endUpdates()
            
            subModuleArray.removeAll()
        }
    }
    func drawFullCircle(end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, completionPercentage : Double)
    {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(20), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(M_PI/2 + M_PI*2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        //shapeLayer.lineDashPattern = [5 ,5]
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 5.0
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = circlePath.cgPath
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.strokeColor = UIColor.init(hexString:"D2D4D6").cgColor
        shapeLayer1.lineWidth = 5.0
        // shapeLayer1.addSublayer(shapeLayer)
        
        let angle = completionPercentage * 3.6
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(20), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(((90 + angle)/180)*M_PI), clockwise: true)
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = circlePath1.cgPath
        // shapeLayer2.lineDashPattern = [5 ,5]
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.strokeColor = UIColor.white.cgColor
        shapeLayer2.lineWidth = 5.0
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = circlePath1.cgPath
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.strokeColor = UIColor.green.cgColor
        shapeLayer3.strokeColor = UIColor.init(hexString :"2F9DD4").cgColor
        shapeLayer3.lineWidth = 5.0
        // shapeLayer3.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer3)
    }
    
    func drawLineFromPoint(_ end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, _ attendance_percentage: String) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: Double(view.frame.size.width ) * Double(attendance_percentage)!/100, y: 0))
        //
        //        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.strokeColor = UIColor.init(hexString :"2F9DD4").cgColor
        
        shapeLayer.lineWidth = 10.0
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: view.frame.size.width, y: 0))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.strokeColor = UIColor.init(hexString:"D2D4D6").cgColor
        shapeLayer1.lineWidth = 10.0
        //        shapeLayer1.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer)
    }


}
