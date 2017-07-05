//
//  LearnerVireController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 24/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class LearnerVireController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    var learnerObj : [LearnerModel]? = []
    
    var preIndex:IndexPath?
    var currentIndexPath:IndexPath?
    @IBOutlet weak var tableView: UITableView!
    
    var isInStateOFOnlyOne:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//LearnerCell
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.isHidden = true
        preIndex = IndexPath(row: 0, section: 0)
    
        currentIndexPath = IndexPath(row: 0, section: 0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetctDataFromServer()
    }
    
    fileprivate func fetctDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "batch_id=%d",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GETBATCH_STUDENTS_LISTING ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.learnerObj = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("LearnerModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [LearnerModel]
            
            
            self.tableView.isHidden = false
            //self.setUpUIUpperView()
            self.tableView.reloadData()
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
//    func setUpUIUpperView()
//    {
//        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
//        self.tiitleLabel.text = assignmentObj.title
//        self.subTitleLabel.text = assignmentObj.module_name
//        //cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
//        self.upperImageView.image = UIImage(named: "assignmentnew")
//        
//        let part1 = NSMutableAttributedString(string: assignmentObj.total_marks_label)
//        let part2 = NSMutableAttributedString(string: String(format : "%d",assignmentObj.total_marks.intValue), attributes: yourAttributes)
//        let part3 = NSMutableAttributedString(string: assignmentObj.submission_mode, attributes: yourAttributes)
//        let combination1 = NSMutableAttributedString()
//        combination1.append(part1)
//        combination1.append(NSAttributedString(string: " : "))
//        combination1.append(part2)
//        combination1.append(NSAttributedString(string: " | Mode : "))
//        combination1.append(part3)
//        self.publishedLabel.attributedText = combination1
//        
//        let partOne = NSMutableAttributedString(string: assignmentObj.start_date_value, attributes: yourAttributes)
//        let partTwo = NSMutableAttributedString(string: assignmentObj.end_date_value, attributes: yourAttributes)
//        let combination = NSMutableAttributedString()
//        combination.append(NSAttributedString(string: "Published On : "))
//        combination.append(partOne)
//        combination.append(NSAttributedString(string: " | End Date : "))
//        combination.append(partTwo)
//        self.publishedLabel.attributedText = combination
//        
//        self.typeLabel.text = "Type"
//        self.typeValueLabel.text = assignmentObj.is_graded
//        self.multipleSubmissionLabel.text = "Multiple Submission"
//        //cell.multipleSubmissionValueLabel.text = subModuleArray[indexPath.row].
//        //ask it          // cell.multipleSubmissionValueLabel.text =
//        self.maxMarksLabel.text = assignmentObj.total_marks_label
//        
//        // self.maxMarksLabel.text =  self.maxMarksLabel.text! + String(describing: assignmentObj.total_marks)
//        self.marksValueLabel.text = String(describing: assignmentObj.total_marks)
//        
//        self.passingMarksLabel.text = assignmentObj.passing_marks_label
//        
//        //self.passingMarksLabel.text =  self.passingMarksLabel.text! + assignmentObj.passing_marks
//        self.passingMarksValueLabel.text = assignmentObj.passing_marks
//        self.modeLabel.text  = "Mode"
//        
//        //   self.modeLabel.text =   self.modeLabel.text! + assignmentObj.submission_mode
//        self.modeValueLabel.text = assignmentObj.submission_mode
//        self.DescriptionLabel.text =  assignmentObj.desc
//        
//        self.completedLabel.text = "Completed"
//        
//        self.StudentNotUploadedValueLabel.text =  String(describing: assignmentObj.cnt_not_submitted)
//        
//        self.studentUploadLabel.text = String(describing: assignmentObj.cnt_submitted)
//        
//        self.studentUploadedValueLabel.text = "Students Uploaded"
//        
//        self.studentNotUploadedLabel.text = "Stduents Not Uploaded"
//        
//        self.studentUploadedImageView.image = UIImage(named:"")
//        
//        self.studentUploadedImageView.image = UIImage(named:"")
//        
//        
//        
//        
//        //draw circle
//        //  cell.circleAttandanceLabel
//        drawFullCircle(end: CGPoint(x: self.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: self.circleLabel, completionPercentage: Double(assignmentObj.avg_completion_percentage))
//        
//        self.circleLabel.text  =  String(describing: assignmentObj.avg_completion_percentage)
//        self.circleLabel.text =   self.circleLabel.text! + "%"
//        
//    }
//    
    
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
        shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor
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
        shapeLayer3.strokeColor = UIColor.init(hexString: "2F9DD4").cgColor
        shapeLayer3.lineWidth = 5.0
        // shapeLayer3.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer3)
    }
  
    
    
    func drawLineFromPoint(_ end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, _ attendance_percentage: String) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: Double(view.frame.size.width ) * Double(attendance_percentage)!/100, y: 10))
        //
        //        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.strokeColor = UIColor.init(hexString: "2F9DD4").cgColor
        shapeLayer.lineWidth = 10.0
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 10))
        path1.addLine(to: CGPoint(x: view.frame.size.width, y: 10))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor
        shapeLayer1.lineWidth = 10.0
        //        shapeLayer1.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.mostUpperViewHeight.constant = self.completedLabel.frame.origin.y + self.completedLabel.frame.size.height + 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
        return (learnerObj!.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LearnerCell", for: indexPath) as! LeanerTableCell
        
        cell.nameLabel.text = learnerObj?[indexPath.row].name
        cell.lastActiveLabel.text = "Last Active: " + (learnerObj?[indexPath.row].last_active)!

        cell.profileImageView?.sd_setImage(with: URL(string: (learnerObj?[indexPath.row].image)!))
        cell.completedLabel.text = "Completed"
        cell.queryLabel.text = String(describing: learnerObj![indexPath.row].query) + "Query"
        
        cell.queryImageView.image = UIImage(named: "disscusstion")
        
        cell.assessmentLabel.text = "Assessment"
        cell.assignmentLabel.text = "Assignment"
        cell.attendanceLabel.text = "Attendance"
        cell.assessmentValueLabel.text = String(describing: learnerObj?[indexPath.row].query.intValue)
        
        cell.attendanceValueLabel.text = String(describing: learnerObj![indexPath.row].attendance) + "%"
        
        cell.assessmentValueLabel.text = "\(learnerObj![indexPath.row].assessment.completed.intValue) /\(learnerObj![indexPath.row].assessment.total.intValue)"
    cell.assignmentValueLabel.text =  "\(learnerObj![indexPath.row].assignment.completed.intValue) /\(learnerObj![indexPath.row].assignment.total.intValue)"
    
        var assignPercentage = 0
        if(learnerObj![indexPath.row].assignment.total.intValue != 0){
           assignPercentage  = learnerObj![indexPath.row].assignment.completed.intValue / learnerObj![indexPath.row].assignment.total.intValue}
      
        
        var assessmentPercentage = 0
        

        if(learnerObj![indexPath.row].assessment.total.intValue != 0){
            assignPercentage  = learnerObj![indexPath.row].assessment.completed.intValue / learnerObj![indexPath.row].assessment.total.intValue}
        
        cell.viewProfileButton.layer.cornerRadius = cell.viewProfileButton.frame.size.height/2
        cell.viewProfileButton.layer.borderColor = UIColor.init(hexString: "2D9FF4").cgColor
        cell.viewProfileButton.layer.borderWidth = 2

        cell.sendMessageButton.layer.cornerRadius = cell.sendMessageButton.frame.size.height/2
        cell.sendMessageButton.layer.borderColor = UIColor.init(hexString: "2D9FF4").cgColor
        cell.sendMessageButton.layer.borderWidth = 2
        
         drawLineFromPoint(CGPoint(x: Double(cell.attendanceProgressView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.attendanceProgressView ), String((learnerObj?[indexPath.row].attendance)!))
        
        
               //assessment
         drawLineFromPoint(CGPoint(x: Double(cell.assessmentProgressLabel.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.assessmentProgressLabel ), String(assessmentPercentage))
        
        //assignment
           drawLineFromPoint(CGPoint(x: Double(cell.assignmentProgressView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.assignmentProgressView ), String(assignPercentage))
        
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height/2
        cell.profileImageView.clipsToBounds = true
        cell.mostUpperView.layer.cornerRadius = 3
        cell.viewProfileButton.tag = indexPath.row
        cell.sendMessageButton.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if( currentIndexPath == indexPath )
      {
//            preIndex = currentIndexPath
//            currentIndexPath = IndexPath(row: 0, section: 1)
//           
//            tableView.reloadRows(at: [preIndex!], with: UITableViewRowAnimation.top)
//            isInStateOFOnlyOne = true
        }
        else
        {
            preIndex = currentIndexPath
            currentIndexPath = indexPath
            tableView.reloadRows(at: [preIndex!,currentIndexPath!], with: UITableViewRowAnimation.top)
            isInStateOFOnlyOne = false
        }

    }
    

    
    @IBAction func backButtonAction(_ sender : AnyObject){
        _ =   self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(isInStateOFOnlyOne == true )
        {
        
            if(indexPath == preIndex)   {
                return 90
                }
                    else
                {
                    return 90
                }
        }
        else
        {
            if (currentIndexPath == indexPath || ( currentIndexPath == indexPath && indexPath == preIndex))
            {
                return 262
            }
            else if(indexPath == preIndex)
            {
                return 90
            }
            
        }
        return 90
    }

    
    
    @IBAction func viewProfileButtonTapped(_ sender: Any) {
       // sender = sender as UIButton
      //  learnerObj![(sender as! UIButton).tag].user_id.intValue
        
        let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        featuredVC.selectedCourseObj = self.selectedCourseObj
        //        featuredVC.selectedCourseObjImage = self.selectedCourseObjImage
        featuredVC.userID = learnerObj?[(sender as! UIButton).tag].id.intValue
        self.navigationController?.pushViewController(featuredVC, animated: true)
    }
    
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        
    }

}
