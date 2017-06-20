//
//  CustomControllerForLiveClassDetails.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 12/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CustomControllerForLiveClassDetails: UIViewController {

    
    
    
    var live_classDetailObj : LiveClassDetailsModel?
    
    var isCameFromDrawer : Bool!
    
    var content_type_id: NSNumber?
    var content_id :NSNumber?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.showsVerticalScrollIndicator = false
//        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let str = String(format: "batch_id=%d&content_type_id=%d&content_id=%d",self.selectedCourseObj.id.intValue,(self.content_type_id?.intValue)!,(self.content_id?.intValue)!)
        ServerCommunication.singleton.requestWithPost(API_NOTES_DETAILS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.live_classDetailObj = (JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("LiveClassDetailsModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! LiveClassDetailsModel?)!
            self.setUpUIUpperView()
//            self.tableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    func setUpUIUpperView()
    {
        
//        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
//        
//        self.tiitleLabel.text = assignmentObj.title
//        self.subTitleLabel.text = assignmentObj.module_name
//        //cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
//        self.upperImageView.image = UIImage(named: "Assignment1.png")
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
//        self.maxMarksLabel.text =  self.maxMarksLabel.text! + String(describing: assignmentObj.total_marks)
//        
//        self.passingMarksLabel.text = assignmentObj.passing_marks_label
//        
//        self.passingMarksLabel.text =  self.passingMarksLabel.text! + assignmentObj.passing_marks
//        self.modeLabel.text  = "Mode"
//        
//        self.modeLabel.text =   self.modeLabel.text! + assignmentObj.submission_mode
//        
//        //ask it       //       cell.secondDescriptiveLabel.text =  String(subModuleArray[indexPath.row].desc)
//        
//        self.completedLabel.text = "Completed"
//        
//        self.StudentNotUploadedValueLabel.text =  String(describing: assignmentObj.cnt_not_submitted)
//        
//        self.studentUploadedValueLabel.text = String(describing: assignmentObj.cnt_submitted)
//        
//        self.studentUploadLabel.text = "Students Uploaded"
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
        
    }
    
    func drawFullCircle(end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, completionPercentage : Double)
    {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(20), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(M_PI/2 + M_PI*2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        //shapeLayer.lineDashPattern = [5 ,5]
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = circlePath.cgPath
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.lineWidth = 1.0
        // shapeLayer1.addSublayer(shapeLayer)
        
        let angle = completionPercentage * 3.6
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(20), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(((90 + angle)/180)*M_PI), clockwise: true)
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = circlePath1.cgPath
        // shapeLayer2.lineDashPattern = [5 ,5]
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.strokeColor = UIColor.white.cgColor
        shapeLayer2.lineWidth = 1.0
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = circlePath1.cgPath
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.strokeColor = UIColor.green.cgColor
        shapeLayer3.lineWidth = 1.0
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
        shapeLayer.lineWidth = 10.0
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: view.frame.size.width, y: 0))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.lineWidth = 10.0
        //        shapeLayer1.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
       // return (live_classDetailObj?.student_attempt_info.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCellForAssignmentDetails", for: indexPath) as! CustomTableCellForAssignmentDetails
        
//        cell.submittedOnLabel.text = "Submitted on:" + (assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).name
//        cell.nameLabel.text =  (assessmentDetailObj?.student_submission_info[indexPath.row] as! student_attempt_info).name
//        cell.nameLabel.text = cell.nameLabel.text! + (assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).name
//        cell.markAsRecievedLabel.text = "Mark as received"
//        //complete it // cell.assignmentNameLabel.text =
//        //complete it //    cell.upperImageView.image = UIImage(named:"")
//        drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double((assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).assignment_marks)!)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
