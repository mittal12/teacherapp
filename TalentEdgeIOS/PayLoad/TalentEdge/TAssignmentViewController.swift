//
//  TAssignmentViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 13/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class TAssignmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var assignmentTableView: UITableView!
    //var assignmentArray : [TEAssignmentData]!

    var subModuleArray : [AssignmentModel]!

    override func viewDidLoad() {
        super.viewDidLoad()

        subModuleArray = [AssignmentModel]()
        
        assignmentTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        assignmentTableView.showsVerticalScrollIndicator = false
        assignmentTableView.tableFooterView = UIView()
        assignmentTableView.delegate = self
        assignmentTableView.dataSource = self

        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
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
        let str = String(format: "batch_id=%d&content_type_id=5",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_NOTES_DETAILS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.subModuleArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("AssignmentModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [AssignmentModel]
            
            self.assignmentTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subModuleArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
        return 295 + addedWidth
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
//   let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableCell", for: indexPath) as! AssignmentTableCell
//    cell.titleLabel.text = subModuleArray[indexPath.row].title
//    cell.subtitleLabel.text = subModuleArray[indexPath.row].module_name
//    //cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
//    cell.upperImageView.image = UIImage(named: "Assignment1.png")
//    
//    let part1 = NSMutableAttributedString(string: "total Marks")
//    let part2 = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_marks.intValue), attributes: yourAttributes)
//    let part3 = NSMutableAttributedString(string: subModuleArray[indexPath.row].submission_mode, attributes: yourAttributes)
//    let combination1 = NSMutableAttributedString()
//    combination1.append(part1)
//    combination1.append(NSAttributedString(string: " : "))
//    combination1.append(part2)
//    combination1.append(NSAttributedString(string: " | Mode : "))
//    combination1.append(part3)
//    cell.publishedLabel.attributedText = combination1
//    
//    
//    let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date, attributes: yourAttributes)
//    let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date, attributes: yourAttributes)
//    let combination = NSMutableAttributedString()
//    combination.append(NSAttributedString(string: "Published On : "))
//    combination.append(partOne)
//    combination.append(NSAttributedString(string: " | End Date : "))
//    combination.append(partTwo)
//    cell.publishedLabel.attributedText = combination
//    
//    cell.typeLabel.text = "Type"
//    cell.typeLabelValueLabel.text = subModuleArray[indexPath.row].is_graded
//    cell.multipleSubmissionLabel.text = "Multiple Submission"
//    //cell.multipleSubmissionValueLabel.text = subModuleArray[indexPath.row].
//    //ask it          // cell.multipleSubmissionValueLabel.text =
//    cell.marksLabel.text = "Max Marks"
//    
//    cell.marksValueLabel.text =  String(describing: subModuleArray[indexPath.row].total_marks)
//    
//    cell.passingMarksLabel.text =  "Min marks"
//    cell.passingMarksValueLabel.text = subModuleArray[indexPath.row].passing_marks
//    cell.ModelLabel.text  = "Mode"
//    
//    cell.modeValueLabel.text =  subModuleArray[indexPath.row].submission_mode
//    
//    //ask it       //       cell.secondDescriptiveLabel.text =  String(subModuleArray[indexPath.row].desc)
//    
//    cell.completedLabel.text = "Completed"
//    
//    cell.studentNotUploadedValueLabe.text =  String(describing: subModuleArray[indexPath.row].cnt_not_submitted)
//    
//    cell.studentsUploadValueLabel.text = String(describing: subModuleArray[indexPath.row].cnt_submitted)
//    
//    cell.studentUploadLabel.text = "Students Uploaded"
//    
//    cell.studentNotUploadLabel.text = "Stduents Not Uploaded"
//    
//    cell.studentNotImageView.image = UIImage(named:"")
//    
//    cell.studentImageView.image = UIImage(named:"")
//        
//        //draw circle
//    //  cell.circleAttandanceLabel
//    drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage)!)
//    
//    cell.circleLabel.text  =  String(describing: subModuleArray[indexPath.row].avg_completion_percentage)
//    cell.circleLabel.text =   cell.circleLabel.text! + "%"
//   // cell.circleLabel.text =
//
//    return cell
//        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableCell", for: indexPath) as! AssignmentTableCell
        cell.titleLabel.text = subModuleArray[indexPath.row].title
        cell.subtitleLabel.text = subModuleArray[indexPath.row].module_name
        //cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
        cell.upperImageView.image = UIImage(named: "assignmentnew.png")
        
        let part1 = NSMutableAttributedString(string: "Total Marks")
        let part2 = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_marks.intValue), attributes: yourAttributes)
        let part3 = NSMutableAttributedString(string: subModuleArray[indexPath.row].submission_mode, attributes: yourAttributes)
        let combination1 = NSMutableAttributedString()
        combination1.append(part1)
        combination1.append(NSAttributedString(string: " : "))
        combination1.append(part2)
        combination1.append(NSAttributedString(string: " | Mode : "))
        combination1.append(part3)
        cell.publishedLabel.attributedText = combination1
        
        
        let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_formatted, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_formatted, attributes: yourAttributes)
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
        cell.marksLabel.text = "Max Marks"
        cell.marksValueLabel.text =  String(describing: subModuleArray[indexPath.row].total_marks)
        
        cell.passingMarksLabel.text =  "Min marks"
        
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
        
    }
    
    
    func setTheDetailModelObj(_ modelObj : AssignmentModel) -> TEModuleDetailData
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
         
         var id = NSNumber()
         var parent_id = NSNumber()
         var module_id = NSNumber()
         var module_name = String()
         var title = String()
         var desc = String()
         var content_type_id = NSNumber()
         var submission_mode = String()
         var allow_edit = NSNumber()
         var is_graded = String()
         var total_marks = NSNumber()
         var total_marks_label = String()
         var passing_marks = String()
         var passing_marks_label = String()
         var is_draft = NSNumber()
         var allow_view = NSNumber()
         var submission_count = NSNumber()
         var submission_label = String()
         var start_date_label = String()
         var start_date_value = String()
         var action = String()
         var ref_type = String()
         var content_path = String()
         var content_duration_formated = String()
         var end_date_label = String()
         var end_date_value = String()
         var published_by_label = String()
         var published_by_value = String()
         var completion_percentage = NSNumber()
         var notes_count = NSNumber()
         var start_date = String()
         var total_questions = NSNumber()
         var total_duration = String()
         var is_locked = NSNumber()
         var total_assessment = NSNumber()
         var total_assignment = NSNumber()
         var total_interactive_video = NSNumber()
         var total_notes = NSNumber()
         var total_video = NSNumber()
         var view_count = NSNumber()
         var likes_count = NSNumber()
         var avg_completion_percentage = NSNumber()
         var cnt_completed = NSNumber()
         var cnt_not_completed = NSNumber()
         
         var total_invitees_attended_in_live_class = NSNumber()
         var total_invitees_attended_in_recorded_class = NSNumber()
         
         var participation_percentage_in_live_class = NSNumber()
         var participation_percentage_in_recorded_class = NSNumber()
         // var attendance_in_recorded_session = NSNumber()
         //for assessment
         var cnt_attempted = NSNumber()
         var cnt_not_attempted = NSNumber()
         
         //for assignment
         var cnt_submitted = NSNumber()
         var cnt_not_submitted = NSNumber()
         // open var description = NSString()
         
         var test_type = NSNumber()
         
         */
        
        /*
         
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
         
         let part1 = NSMutableAttributedString(string: assignmentObj.total_marks_label) //hardcoded
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
         //cell.multipleSubmissionValueLabel.text = subModuleArray[indexPath.row].
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
         

         
         
        */
        
        
        
        
        
        
        
        
        returnModel.title = modelObj.title
        returnModel.start_date_label = modelObj.start_date
         returnModel.start_date_value = modelObj.start_date_formatted
     returnModel.end_date_label = modelObj.end_date
        returnModel.end_date_value = modelObj.end_date_formatted
        returnModel.desc = modelObj.desc
       // returnModel.allowed_multiple =  //consider it late
        returnModel.avg_completion_percentage = modelObj.avg_completion_percentage
        returnModel.cnt_not_submitted = modelObj.cnt_not_submitted
        returnModel.cnt_submitted = modelObj.cnt_submitted
        returnModel.desc = modelObj.desc
        returnModel.id = modelObj.id
        returnModel.is_graded = modelObj.is_graded
        //returnModel.is_graded_done =   //consider it late
        returnModel.passing_marks = modelObj.passing_marks
        returnModel.submission_mode = modelObj.submission_mode
        returnModel.total_marks = modelObj.total_marks
        returnModel.total_marks_label = "Max Marks:"
        returnModel.passing_marks_label = "PassingMarks:"
        
        
        returnModel.module_name = modelObj.module_name
        
        return returnModel
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomContollerForDetailAssignment") as! CustomContollerForDetailAssignment
        detailVC.selectedCourseObj = self.selectedCourseObj
        detailVC.assignmentObj = setTheDetailModelObj(self.subModuleArray[indexPath.row])
            //self.subModuleArray[indexPath.row]
        detailVC.content_type_id = 5
        detailVC.content_id = self.subModuleArray[indexPath.row].id
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
