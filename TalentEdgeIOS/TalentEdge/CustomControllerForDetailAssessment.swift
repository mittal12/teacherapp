//
//  CustomControllerForDetailAssessment.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 12/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CustomControllerForDetailAssessment: UIViewController , UITableViewDataSource,UITableViewDelegate {

    var assessmentDetailObj : AssessmentDetailModel?
    
    var isCameFromDrawer : Bool!
    
    var content_type_id: NSNumber?
    var content_id :NSNumber?
    var isExpanded:Bool = false
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var innerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    
    @IBOutlet weak var upperViewHeight: NSLayoutConstraint!

    
    
    var assignmentObj: TEModuleDetailData!
    override func viewDidLoad() {
        super.viewDidLoad()
self.subNavTitleLabel.text = assignmentObj.module_name
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
            self.assessmentDetailObj = (JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("AssessmentDetailModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! AssessmentDetailModel?)!
//            self.setUpUIUpperView()
//            self.tableView.reloadData()
//            self.tableView.constant = self.tableView.contentSize.height
//            self.tableView.is = false
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    func setUpUIUpperView()
    {
//        cell.tittleLabel.text = subModuleArray[indexPath.row].title
//        cell.descriptionLabel.text = subModuleArray[indexPath.row].desc
//        
//        
//        cell.subtitleLabel.text = subModuleArray[indexPath.row].module_name
//        //cell.bottomBlueButton.setTitle("  Attempted  ", for: UIControlState())
//        cell.upperImageView.image = UIImage(named: "assessment1.png")
//        
//        let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date_value, attributes: yourAttributes)
//        let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date_value, attributes: yourAttributes)
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
//        drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage))
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
       // return (assessmentDetailObj?.student_attempt_info.count)!
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCellForAssessmentDetails", for: indexPath) as! CustomTableCellForAssessmentDetails
        
        
        
        
        
        
       return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        _ =   self.navigationController?.popViewController(animated: true)
    }
    @IBAction func readButtonTapped(_ sender: Any) {
        
        if(isExpanded == true)
        {
            
            self.upperViewHeight.constant = upperViewHeight.constant - self.innerViewHeight.constant
            self.innerViewHeight.constant = 0
            isExpanded = false
            self.readButton.setTitle("READ MORE", for: .normal)
        }
        else
        {
            //self.innerViewHeight.constant =
           // self.upperViewHeight.constant = upperViewHeight.constant + self.innerViewHeight.constant
           // isExpanded = true
            //self.readButton.setTitle("READ LESS", for: .normal)
            
        }

        
    }

}