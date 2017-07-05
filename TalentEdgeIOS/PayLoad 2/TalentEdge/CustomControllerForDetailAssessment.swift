//
//  CustomControllerForDetailAssessment.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 12/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CustomControllerForDetailAssessment: UIViewController , UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var mainUpperView: UIView!
    var assessmentDetailObj : AssessmentDetailModel?
    
    var isCameFromDrawer : Bool!
    
    @IBOutlet weak var upperImageView: UIImageView!
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var tiitleLabel: UILabel!
    
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var publicationLabel: UILabel!
    @IBOutlet weak var upperInnerView: UIView!
    
    @IBOutlet weak var circleLabel: UILabel!
    
    @IBOutlet weak var completedLabel: UILabel!
    
    
    @IBOutlet weak var studentAttemptedValueLabel: UILabel!
    
    @IBOutlet weak var studentAttemptedImageView: UIImageView!
    
    
    @IBOutlet weak var stduentAttemptedLabel: UILabel!
    
    @IBOutlet weak var studentNotAttemptedValueLabel: UILabel!
    
    
    @IBOutlet weak var studentNotAttemptedImageView: UIImageView!
    
    @IBOutlet weak var studentNotAttemptedLabel: UILabel!
    
    @IBOutlet weak var modeLabel: UILabel!
    
    var content_type_id: NSNumber?
    var content_id :NSNumber?
    var isExpanded:Bool = false
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var innerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    
    @IBOutlet weak var upperViewHeight: NSLayoutConstraint!

    
    @IBOutlet weak var tableView: UITableView!
    
    var assignmentObj: TEModuleDetailData!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subNavTitleLabel.text = assignmentObj.module_name
        self.mainScrollView.isHidden = true
        self.tableView.separatorStyle = .none
        assessmentDetailObj = AssessmentDetailModel()
      //  self.mainScrollView.addScalableCover(with: ModelManager.singleton.courseImage)

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
            self.mainScrollView.isHidden =  false
            self.setUpUIUpperView()
            self.tableView.reloadData()
            self.tableViewHeight.constant = self.tableView.contentSize.height
            self.tableView.isScrollEnabled = false
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    func setUpUIUpperView()
    {
         let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        self.tiitleLabel.text = assignmentObj.title
        self.descriptionLabel.text = assignmentObj.desc
        
        self.subTitleLabel.text = assignmentObj.module_name
        //self.bottomBlueButton.setTitle("  Attempted  ", for: UIControlState())
        self.upperImageView.image = UIImage(named: "assessment1.png")
        
        let partOne = NSMutableAttributedString(string: assignmentObj.start_date_value, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: assignmentObj.end_date_value, attributes: yourAttributes)
        let combination = NSMutableAttributedString()
        combination.append(NSAttributedString(string: "Published On : "))
        combination.append(partOne)
        combination.append(NSAttributedString(string: " | End Date : "))
        combination.append(partTwo)
        self.publicationLabel.attributedText = combination

        let partThree = NSMutableAttributedString(string: String(format : "%d",assignmentObj.total_questions.intValue), attributes: yourAttributes)
        let partFour = NSMutableAttributedString(string: assignmentObj.total_duration, attributes: yourAttributes)
        let partFive = NSMutableAttributedString(string: String(format : "%d",assignmentObj.total_marks.intValue), attributes: yourAttributes)
        
        let combination1 = NSMutableAttributedString()
        combination1.append(NSAttributedString(string: "Question : "))
        combination1.append(partThree)
        combination1.append(NSAttributedString(string: " | Duration : "))
        combination1.append(partFour)
        combination1.append(NSAttributedString(string: " | Max Marks : "))
        combination1.append(partFive)
        
        self.questionLabel.attributedText = combination1
        
        self.circleLabel.text = String(describing:assignmentObj.avg_completion_percentage)
        self.circleLabel.text = self.circleLabel.text! + "%"
        
        self.completedLabel.text = "Average Score"
        self.studentAttemptedValueLabel.text = String(describing: assignmentObj.cnt_attempted)
        self.studentNotAttemptedValueLabel.text = String(describing: assignmentObj.cnt_not_attempted)
        self.stduentAttemptedLabel.text = "Students Attempted"
        self.studentNotAttemptedLabel.text  = "Student unAttempted"
        // self.studentAttemptedImageView.image =  UIImage(named:"")
        
        //self.studentnotAttemptedImageView.image = UIImage(named:"")
        drawFullCircle(end: CGPoint(x: self.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: self.circleLabel, completionPercentage: Double(assignmentObj.avg_completion_percentage))
        
        //ask it
        let partofMode = NSMutableAttributedString(string: assignmentObj.test_type_label, attributes: yourAttributes)
        
        
        
        let combination2 = NSMutableAttributedString()
        combination2.append(NSAttributedString(string: "Mode:"))
        combination2.append(partofMode)
        self.modeLabel.attributedText = combination2
        self.mainUpperView.layer.cornerRadius = 3

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
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: Double(view.frame.size.width ) * Double(attendance_percentage)!/100, y: 0))
        //
        //        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.strokeColor = UIColor.init(hexString: "2F9DD4").cgColor

        shapeLayer.lineWidth = 10.0
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: view.frame.size.width, y: 0))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor

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
        return  (assessmentDetailObj?.student_attempt_info.count)!

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCellForAssessmentDetails", for: indexPath) as! CustomTableCellForAssessmentDetails
        
        cell.scoreLabel.text = "Score: " + String(describing: (assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).marks)
        cell.nameLabel.text = (assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).name
      // ask it // cell.circleLabel.text = (assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).name
        cell.completedLabel.text = "Completed"
        
    //   ask it //cell.howmanyAnsweredLabel.text = "\((assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).attempted_questions.intValue)/" + "\((assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).total_questions.intValue)"
        
        
        //complete it // cell.assignmentNameLabel.text =
        //complete it //    cell.upperImageView.image = UIImage(named:"")
        
        
        cell.upperImageView.sd_setImage(with: URL(string: (assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).pic))
        cell.timeTakenLabel.text = "Time Taken:" + "\((assessmentDetailObj?.student_attempt_info[indexPath.row] as! student_attempt_info).time_taken.intValue)" + "seconds"
        
        //drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double((assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).assignment_marks)!)
        
        cell.upperImageView.layer.cornerRadius = cell.upperImageView.frame.size.height/2
        cell.upperImageView.clipsToBounds = true
        cell.upperViewFortableCell.layer.cornerRadius = 3

        cell.selectionStyle = .none
        
        
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
    
    
    
    
    @IBAction func readButtonTapped1(_ sender: Any) {
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
            
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(self.descriptionLabel.text!, width: tableView.frame.size.width - 40)
            self.innerViewHeight.constant = 75 + addedWidth
            
            //  self.innerViewHeight.constant = 226
            self.upperViewHeight.constant = upperViewHeight.constant + self.innerViewHeight.constant
            isExpanded = true
            self.readButton.setTitle("READ LESS", for: .normal)
            
            
            
        }
        

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
            
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(self.descriptionLabel.text!, width: tableView.frame.size.width - 40)
            self.innerViewHeight.constant = 75 + addedWidth
            
            //  self.innerViewHeight.constant = 226
            self.upperViewHeight.constant = upperViewHeight.constant + self.innerViewHeight.constant
            isExpanded = true
            self.readButton.setTitle("READ LESS", for: .normal)
            
        }

        
    }

}
