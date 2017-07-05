//
//  TAssessmentViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 13/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class TAssessmentViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var assessmentTableView: UITableView!
    var assessmentArray = [TEAssessmentData]()
    
    var subModuleArray : [AssessmentModel]!
        override func viewDidLoad() {
        super.viewDidLoad()
        
        subModuleArray = [AssessmentModel]()
        
        assessmentTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        assessmentTableView.showsVerticalScrollIndicator = false
        assessmentTableView.tableFooterView = UIView()
        assessmentTableView.delegate = self
        assessmentTableView.dataSource = self
        
        
        
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
        let str = String(format: "batch_id=%d&content_type_id=4",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_NOTES_DETAILS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.subModuleArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("AssessmentModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [AssessmentModel]
            
            self.assessmentTableView.reloadData()
            
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
        return 280+addedWidth
          }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentTableCellCustom", for: indexPath) as! AssessmentTableCellCustom
//        cell.tittleLabel.text = subModuleArray[indexPath.row].title
// //ask it       cell.descriptionLabel.text = ""
//        
//        
//        cell.subtitleLabel.text = subModuleArray[indexPath.row].module_name
//        //cell.bottomBlueButton.setTitle("  Attempted  ", for: UIControlState())
//        cell.upperImageView.image = UIImage(named: "assessment1.png")
//        
//        let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_formatted, attributes: yourAttributes)
//        let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date, attributes: yourAttributes)
//        let combination = NSMutableAttributedString()
//        combination.append(NSAttributedString(string: "Published On : "))
//        combination.append(partOne)
//        combination.append(NSAttributedString(string: " | End Date : "))
//        combination.append(partTwo)
//        cell.publicationLabel.attributedText = combination
//        
//        let partThree = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_questions.intValue), attributes: yourAttributes)
//        let partFour = NSMutableAttributedString(string: subModuleArray[indexPath.row].total_duration, attributes: yourAttributes)
//        let partFive = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_marks.intValue), attributes: yourAttributes)
//        
//        
//        
//        
//        let combination1 = NSMutableAttributedString()
//        combination1.append(NSAttributedString(string: "Question : "))
//        combination1.append(partThree)
//        combination1.append(NSAttributedString(string: " | Duration : "))
//        combination1.append(partFour)
//        combination1.append(NSAttributedString(string: " | Max Marks : "))
//        combination1.append(partFive)
//        
//        cell.publicationLabel.attributedText = combination1
//        
//        cell.circleLabel.text = String(describing:subModuleArray[indexPath.row].avg_completion_percentage)
//        cell.circleLabel.text = cell.circleLabel.text! + "%"
//        
//        cell.scoreLabel.text = "Average Score"
//        cell.studentAttemptedValueLabel.text = String(describing: subModuleArray[indexPath.row].cnt_attempted)
//        cell.studentNotAttemptedValueLabel.text = String(describing: subModuleArray[indexPath.row].cnt_not_attempted)
//        cell.studentAttemptedLabel.text = "Students Attempted"
//        cell.studentNotAttemptedLabel.text  = "Student unAttempted"
//        // cell.studentAttemptedImageView.image =  UIImage(named:"")
//        
//        //cell.studentnotAttemptedImageView.image = UIImage(named:"")
//        drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage)!)
//        
//        //cell.tag = 100 + indexPath.row
//        return cell
//        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentTableCellCustom", for: indexPath) as! AssessmentTableCellCustom
        cell.tittleLabel.text = subModuleArray[indexPath.row].title
        cell.descriptionLabel.text = subModuleArray[indexPath.row].desc
        
        
        cell.subtitleLabel.text = subModuleArray[indexPath.row].module_name
        //cell.bottomBlueButton.setTitle("  Attempted  ", for: UIControlState())
        cell.upperImageView.image = UIImage(named: "assessmentnew")
        
        let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_formatted, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date, attributes: yourAttributes)
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
        let partofMode = NSMutableAttributedString(string:subModuleArray[indexPath.row].test_type, attributes: yourAttributes)
        
        
        
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

        
    }
    
    
    func setTheDetailModelObj(_ modelObj : AssessmentModel) -> TEModuleDetailData
    {
        let returnModel = TEModuleDetailData()
    
//        "id": "126",
//        "title": "Assessment 3",
//        "start_date": "2017-03-03 00:00:00",
//        "start_date_formatted": "Mar 03, 2017",
//        "end_date": "2017-10-31 00:00:00",
//        "end_date_formatted": "Oct 31, 2017",
//        "description": "test",
//        "avg_completion_percentage": "33",
//        "total_questions": "1",
//        "total_duration": "20",
//        "total_duration_formatted": "00:20 Hrs",
//        "total_marks": "10",
//        "test_type": "Real",
//        "cnt_attempted": "1",
//        "cnt_not_attempted": "2",
//        "module_name": "Test Batch for Admin Dashboard"
//
        
        returnModel.title = modelObj.title
        returnModel.start_date_label = modelObj.start_date
        returnModel.start_date_value = modelObj.start_date_formatted
        returnModel.end_date_label = modelObj.end_date
        returnModel.end_date_value = modelObj.end_date_formatted
        returnModel.desc = modelObj.desc
        returnModel.avg_completion_percentage = modelObj.avg_completion_percentage
        returnModel.total_questions = modelObj.total_questions
        returnModel.total_duration = modelObj.total_duration_formatted
        //returnModel.total_duration_formatted = modelObj.total_duration_formatted
        returnModel.total_marks = modelObj.total_marks
        //returnModel.test_type_label = modelObj.test_type
        returnModel.cnt_not_attempted = modelObj.cnt_not_attempted
        returnModel.cnt_attempted = modelObj.cnt_attempted
        returnModel.id = modelObj.id
        
//        returnModel.is_graded = modelObj.is_graded
//        //returnModel.is_graded_done =   //consider it late
//        returnModel.passing_marks = modelObj.passing_marks
//        returnModel.submission_mode = modelObj.submission_mode
        //returnModel.total_marks = modelObj.total_marks
     //   returnModel.total_marks_label = "Max Marks:"
       // returnModel.passing_marks_label = "PassingMarks:"
        
        
        returnModel.module_name = modelObj.module_name
        
        return returnModel
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomControllerForDetailAssessment") as! CustomControllerForDetailAssessment
        detailVC.selectedCourseObj = self.selectedCourseObj
        detailVC.assignmentObj =  setTheDetailModelObj(self.subModuleArray[indexPath.row])
        detailVC.content_type_id = 4
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
