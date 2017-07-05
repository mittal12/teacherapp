//
//  TAttendenceViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 13/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class TAttendenceViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var attendenceTableView: UITableView!
    @IBOutlet weak var totalClassesLabel: UILabel!
    @IBOutlet weak var attendenceLabel: UILabel!
    
    var attenanceModelObj : AttendanceModel!
    var subModuleArray : [TAttendanceModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subModuleArray = [TAttendanceModel]()
        attenanceModelObj = AttendanceModel()
        attendenceTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        attendenceTableView.showsVerticalScrollIndicator = false
        attendenceTableView.tableFooterView = UIView()
        attendenceTableView.delegate = self
        attendenceTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        fetctDataFromServer()
    }
    
    
    func fetctDataFromServer(){
    
    let headers : [String:String] = [
        "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
        "token": ModelManager.singleton.loginData.token,
        "deviceType": "IOS"
    ]
    let str = String(format: "batch_id=%d&content_type_id=",self.selectedCourseObj.id.intValue)
    ServerCommunication.singleton.requestWithPost(API_ATTENDANCE_COUNT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
    print(successResponseDict)
    self.attenanceModelObj = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("AttendanceModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! AttendanceModel
        //self.subModuleArray = self.attenanceModelObj.liveSessionAttendance
        self.totalClassesLabel.text = String(self.attenanceModelObj.liveSessionAttendance.count)
        self.attendenceLabel.text = self.attenanceModelObj.batchPaticipationDetails.class_participation_percentage_in_live_class
        self.attendenceTableView.reloadData()
    
    }) { (errorResponseDict) -> Void in
    DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
    }
}

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

      return  self.attenanceModelObj.liveSessionAttendance.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveClassTableCell", for: indexPath) as! LiveClassTableCell
        cell.titleLabel.text = (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).title
       // cell.titleLabel.text = (self.attenanceModelObj.liveSessionAttendance[indexPath.row]).title
        cell.descriptionTextVIew.text = (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).desc
        
        cell.subTitleLabel.text =  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).module_name
        //cell.bottomBlueButton.setTitle("  " +  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).action + "  ", for: UIControlState())
        cell.plusImageView.image = UIImage(named: "live_class")
        let partOne = NSMutableAttributedString(string:  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).start_date, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string:  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).content_duration_formatted, attributes: yourAttributes)
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
        
        cell.circleAttandanceLabel.text = String(describing:  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).participation_percentage_in_live_class)
        
        cell.circleAttandanceLabel.text =   cell.circleAttandanceLabel.text! + "%"
        
        
        //draw circle
        //  cell.circleAttandanceLabel
        drawFullCircle(end: CGPoint(x: cell.circleAttandanceLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleAttandanceLabel, completionPercentage: Double( (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).participation_percentage_in_live_class))
        
        cell.leftUpperLabel.text  =  String(describing:  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).total_invitees_attended_in_live_class)
        cell.leftUpperLabel.text = cell.leftUpperLabel.text! + " Students"
        
        //  cell.leftMiddleView
        
        cell.leftBottomLabel.text = "Live Session"
        
        // cell.leftImageView.image = UIImage(named:"")
        
        cell.rightUpperLabel.text  = String(describing:  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).total_invitees_attended_in_recorded_class )
        cell.rightUpperLabel.text = cell.rightUpperLabel.text!  + " Stduents"
        
        
        cell.descriptionTextVIew.text =  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).desc
        
        cell.rightBottomLabel.text = "Recorded Sesssion"
        
        //cell.rightImageView.image = UIImage(named:"")
        
        drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing:  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).participation_percentage_in_recorded_class))
        drawLineFromPoint(CGPoint(x: Double(cell.leftMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.leftMiddleView), String(describing:  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).participation_percentage_in_live_class))
        cell.tag = 100 + indexPath.row
        
        
        
        cell.selectionStyle = .none
        //cell.subTitleLabel.sizeToFit()
        //cell.titleLabel.sizeToFit()
        cell.mainUpperViewForCell.layer.cornerRadius = 1
        cell.mainUpperViewForCell.layer.borderColor = UIColor.init(hexString:"D2D4D6").cgColor
        cell.mainUpperViewForCell.layer.borderWidth = 1
        cell.mainUpperViewForCell.layer.cornerRadius = 3
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let addedWidth:CGFloat = DataUtils.getDynamicHeight( (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).desc, width: tableView.frame.size.width - 50)
        return 270+addedWidth
     }

    func setTheDetailModelObj(_ modelObj : TAttendanceModel) -> TEModuleDetailData
    {
        var returnModel = TEModuleDetailData()
//        var module_name = String()
//        var title = String()
//        var id = String()
//        var end_date = String()
//        var start_date_formated = String()
//        var start_date = String()
//        var content_duration_formated = String()
//        var content_duration = String()
//        var total_invitees_in_live_class = String()
//        var total_invitees_attended_in_live_class = String()
//        var total_invitees_attended_in_recorded_class = String()
//        var participation_percentage_in_live_class = String()
//        var participation_percentage_in_recorded_class = String()
//        var attendance_in_recorded_session = Bool()
//        var average_percentage_in_live_class = NSNumber()
//        var recorded_session_attendee_info_section = String()
//        var content_duration_formatted = String()
//        var desc = String()
//        
//        
        
        /*
         
         "id": "109",
         "title": "Assignment 2",
         "start_date": "2017-02-13 00:00:00",
         "start_date_formatted": "Feb 13, 2017",
         "end_date": "2017-07-31 00:00:00",
         "end_date_formatted": "Jul 31, 2017",
         "description": "test",
         "is_grading_done": "1",
         "avg_completion_percentage": "100",
         "is_graded": "Graded",
         "allowed_multiple": "1",
         "total_marks": "100",
         "passing_marks": "50",
         "submission_mode": "Online",
         "cnt_submitted": "2",
         "cnt_not_submitted": "0",
         "module_name": "mods 1"

         */
        
        
        /*
         self.tiitleLabel.text = assignmentObj.title
         self.subTitleLabel.text = assignmentObj.module_name
         //cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
         self.upperImageView.image = UIImage(named: "assignmentnew")
         
         let part1 = NSMutableAttributedString(string: assignmentObj.total_marks_label)
         let part2 = NSMutableAttributedString(string: String(format : "%d",assignmentObj.total_marks.intValue), attributes: yourAttributes)
         let part3 = NSMutableAttributedString(string: assignmentObj.submission_mode, attributes: yourAttributes)
         let combination1 = NSMutableAttributedString()
         combination1.append(part1)
         combination1.append(NSAttributedString(string: " : "))
         combination1.append(part2)
         combination1.append(NSAttributedString(string: " | Mode : "))
         combination1.append(part3)
         self.publishedLabel.attributedText = combination1
         
         let partOne = NSMutableAttributedString(string: assignmentObj.start_date_value, attributes: yourAttributes)
         let partTwo = NSMutableAttributedString(string: assignmentObj.end_date_value, attributes: yourAttributes)
         let combination = NSMutableAttributedString()
         combination.append(NSAttributedString(string: "Published On : "))
         combination.append(partOne)
         combination.append(NSAttributedString(string: " | End Date : "))
         combination.append(partTwo)
         self.publishedLabel.attributedText = combination
         
         self.typeLabel.text = "Type"
         self.typeValueLabel.text = assignmentObj.is_graded
         self.multipleSubmissionLabel.text = "Multiple Submission"
         //cell.multipleSubmissionValueLabel.text =  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).
         //ask it          // cell.multipleSubmissionValueLabel.text =
         self.maxMarksLabel.text = assignmentObj.total_marks_label
         
         // self.maxMarksLabel.text =  self.maxMarksLabel.text! + String(describing: assignmentObj.total_marks)
         self.marksValueLabel.text = String(describing: assignmentObj.total_marks)
         
         self.passingMarksLabel.text = assignmentObj.passing_marks_label
         
         //self.passingMarksLabel.text =  self.passingMarksLabel.text! + assignmentObj.passing_marks
         self.passingMarksValueLabel.text = assignmentObj.passing_marks
         self.modeLabel.text  = "Mode"
         
         //   self.modeLabel.text =   self.modeLabel.text! + assignmentObj.submission_mode
         self.modeValueLabel.text = assignmentObj.submission_mode
         self.DescriptionLabel.text =  assignmentObj.desc
         
         self.completedLabel.text = "Completed"
         
         self.StudentNotUploadedValueLabel.text =  String(describing: assignmentObj.cnt_not_submitted)
         
         self.studentUploadLabel.text = String(describing: assignmentObj.cnt_submitted)
         
         self.studentUploadedValueLabel.text = "Students Uploaded"
         
         self.studentNotUploadedLabel.text = "Stduents Not Uploaded"
         
         self.studentUploadedImageView.image = UIImage(named:"")
         
         self.studentUploadedImageView.image = UIImage(named:"")
         
         
         
         
         //draw circle
         //  cell.circleAttandanceLabel
         drawFullCircle(end: CGPoint(x: self.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: self.circleLabel, completionPercentage: Double(assignmentObj.avg_completion_percentage))
         
         self.circleLabel.text  =  String(describing: assignmentObj.avg_completion_percentage)
         self.circleLabel.text =   self.circleLabel.text! + "%"

         */
        
        
        returnModel.title = modelObj.title
      //  returnModel.
        returnModel.start_date = modelObj.start_date
      //  returnModel.start_date_value = modelObj.start_date_formatted
        returnModel.end_date_label = modelObj.end_date
     //   returnModel.end_date_value = modelObj.end_date_formatted
        returnModel.desc = modelObj.desc
        //returnModel.content_duration = modelObj.content_duration
        //returnModel.content_duration_formatted = modelObj.content_duration_formatted
        // returnModel.is_demo_live_class = modelObj.is_demo_live_class
        // returnModel.total_invitees_in_live_class = modelObj.total_invitees_in_live_class
        returnModel.total_invitees_attended_in_recorded_class = modelObj.total_invitees_attended_in_recorded_class
        returnModel.participation_percentage_in_recorded_class = modelObj.total_invitees_attended_in_recorded_class
        returnModel.participation_percentage_in_live_class = modelObj.participation_percentage_in_live_class
        returnModel.participation_percentage_in_recorded_class = modelObj.participation_percentage_in_recorded_class
        // returnModel.attendance_in_recorded_session = modelObj.attendance_in_recorded_session
        //returnModel.recorded_session_url_synced = modelObj.recorded_session_url_synced
        //returnModel.avg_time_live_class_attended = modelObj.avg_time_live_class_attended
        //returnModel.avg_time_live_class_attended_formatted = modelObj.avg_time_live_class_attended_formatted
        returnModel.module_name = modelObj.module_name
        
        return returnModel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomControllerForLiveClasses") as! CustomControllerForLiveClasses
        detailVC.selectedCourseObj = self.selectedCourseObj
        // detailVC.liveClassObj = self. (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel)
        
        detailVC.liveClassObj =  setTheDetailModelObj (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel)
        detailVC.content_type_id = 7
        detailVC.content_id =  (self.attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).id
        // detailVC.noteObj = noteObj
        self.navigationController?.pushViewController(detailVC, animated: true)

        
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
