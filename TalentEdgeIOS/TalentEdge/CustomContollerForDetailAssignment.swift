//
//  CustomContollerForDetailAssignment.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 12/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CustomContollerForDetailAssignment: UIViewController ,UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var mostUpperView: UIView!
    
    @IBOutlet weak var subNavLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var checkBoxImageView: UIButton!
    
    @IBOutlet weak var upperImageView: UIImageView!
    
    @IBOutlet weak var mostUpperViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var tiitleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    
    @IBOutlet weak var upperView: UIView!
    
    
    @IBOutlet weak var publishedLabel: UILabel!
    
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var typeValueLabel: UILabel!
    
    
    @IBOutlet weak var marksValueLabel: UILabel!
    @IBOutlet weak var modeValueLabel: UILabel!
    @IBOutlet weak var multipleSubmissionLabel: UILabel!
    
    @IBOutlet weak var multipleSubmissionValueLabel: UILabel!
    
    @IBOutlet weak var passingMarksValueLabel: UILabel!
    @IBOutlet weak var maxMarksLabel: UILabel!
    
    @IBOutlet weak var passingMarksLabel: UILabel!
    
    
    @IBOutlet weak var modeLabel: UILabel!
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    
    
    @IBOutlet weak var circleLabel: UILabel!
    
    
    
    @IBOutlet weak var completedLabel: UILabel!
    
    
    @IBOutlet weak var studentUploadedValueLabel: UILabel!
    
    
    
    @IBOutlet weak var studentUploadLabel: UILabel!
    
    
    @IBOutlet weak var StudentNotUploadedValueLabel: UILabel!
    
    @IBOutlet weak var studentNotUploadedLabel: UILabel!
    
    @IBOutlet weak var studentNotUploadedImageView: UIImageView!

    
    @IBOutlet weak var studentUploadedImageView: UIImageView!
    
    @IBOutlet weak var innerViewHeight: NSLayoutConstraint!
    var assignmentDetailObj : AssignmentDetailModel?
    var isExpanded:Bool = false
    
    var isCameFromDrawer : Bool!
    
    var content_type_id: NSNumber?
    var content_id :NSNumber?
    
    @IBOutlet weak var readButton: UIButton!
    var assignmentObj: TEModuleDetailData!
    
    
    @IBOutlet weak var heightForTableView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignmentDetailObj = AssignmentDetailModel()
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.mainScrollView.isHidden = true
        self.mostUpperView.layer.cornerRadius = 3
        self.subNavLabel.text = assignmentObj.module_name
        //self.subNavLabel.text =
       // self.mainScrollView.addScalableCover(with: ModelManager.singleton.courseImage)

        // Do any additional setup after loading the view.
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
            self.assignmentDetailObj = (JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("AssignmentDetailModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! AssignmentDetailModel?)!
           self.mainScrollView.isHidden = false
            self.setUpUIUpperView()
            self.tableView.reloadData()
        self.heightForTableView.constant = self.tableView.contentSize.height
            self.tableView.isScrollEnabled = false
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    func setUpUIUpperView()
    {
        
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        
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
        //cell.multipleSubmissionValueLabel.text = subModuleArray[indexPath.row].
       //ask it // cell.multipleSubmissionValueLabel.text =
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
        
        self.studentUploadedValueLabel.text = String(describing: assignmentObj.cnt_submitted)
        self.studentUploadLabel.text = "Students Uploaded"
        //self.studentUploadLabel.text = "Students Uploaded"
        
        self.studentNotUploadedLabel.text = "Students Not Uploaded"
        
        //draw circle
        //  cell.circleAttandanceLabel
        drawFullCircle(end: CGPoint(x: self.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: self.circleLabel, completionPercentage: Double(assignmentObj.avg_completion_percentage))
        
        self.circleLabel.text  =  String(describing: assignmentObj.avg_completion_percentage)
        self.circleLabel.text =   self.circleLabel.text! + "%"

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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
         
         private void downloadFlow(ListViewHolder mHolder, StudentListModel cModel) {
         final String uploadPath = cModel.getUploadPath();
         if (!StringUtils.isNullOrEmpty(uploadPath)) {
         final String fileName = uploadPath.substring(uploadPath.lastIndexOf('/') + 1, uploadPath.length());
         mHolder.downloadBtn.setText("" + fileName);
         
         mHolder.downloadBtn.setOnClickListener(new View.OnClickListener() {
         @Override
         public void onClick(View view) {
         fragment.downloadFile(uploadPath, fileName);
         }
         });
         mHolder.downloadBtn.setTextColor(Color.BLACK);
         mHolder.downloadBtn.setCompoundDrawablesWithIntrinsicBounds(R.drawable.download_icon, 0, 0, 0);
         } else {
         mHolder.downloadBtn.setText("Yet to submit");
         mHolder.downloadBtn.setTextColor(Color.RED);
         mHolder.downloadBtn.setOnClickListener(null);
         mHolder.downloadBtn.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
         }
         }

         
            */
       // self.mostUpperViewHeight.constant = self.completedLabel.frame.origin.y + self.completedLabel.frame.size.height + 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return
        
         return (assignmentDetailObj?.student_submission_info.count)!
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCellForAssignmentDetails", for: indexPath) as! CustomTableCellForAssignmentDetails
        
//        "user_id": "34",
//        "fname": "Vishal",
//        "lname": "Sharma",
//        "email": "virendra.bhardwaj@talentedge.in",
//        "pic": "http://localhost/LMS/files/profile/original_1374833708.jpg",
//        "submission_id": "47",
//        "is_received": "1",
//        "upload_path": "",
//        "uploaded_date": "",
//        "uploaded_date_formatted": "",
//        "marks_given_by_faculty": "Y",
//        "assignment_marks": "91",
//        "reviewed_date": "2017-04-11 12:55:11",
//        "reviewed_date_formatted": "Apr 11, 2017 12:55 PM"
//        
        
        
        
        /*
         
         if ("Graded".equalsIgnoreCase(aModel.getIsGraded())) {
         if ("Online".equalsIgnoreCase(aModel.getSubmissionMode()) && StringUtils.isNullOrEmpty(cModel.getSubmissionId())) {
         // online-graded- not submitted
         mHolder.markCheckBox.setVisibility(View.GONE);
         mHolder.addMarks.setVisibility(View.GONE);
         mHolder.rltMarks.setVisibility(View.GONE);
         mHolder.downloadBtn.setVisibility(View.VISIBLE);
         mHolder.downloadBtn.setText("Yet to submit");
         mHolder.downloadBtn.setTextColor(Color.RED);
         mHolder.downloadBtn.setOnClickListener(null);
         mHolder.downloadBtn.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
         } else {
         // online submitted -or- offline any - graded
         mHolder.markCheckBox.setVisibility(View.VISIBLE);
         mHolder.addMarks.setVisibility(View.VISIBLE);
         
         if (!StringUtils.isNullOrEmpty(cModel.getAssignmentMarks())) {
         mHolder.rltMarks.setVisibility(View.VISIBLE);
         mHolder.progressMarks.setProgress(Integer.parseInt(cModel.getAssignmentMarks()));
         mHolder.progressMarks.setMax(Integer.parseInt(aModel.getTotalMarks()));
         mHolder.txvMarksPercent.setText(aModel.getTotalMarks());
         mHolder.addMarks.setText("Edit Marks");
         } else {
         mHolder.rltMarks.setVisibility(View.GONE);
         mHolder.addMarks.setText("Add Marks");
         }
         }
         } else {
         // not graded case
         mHolder.markCheckBox.setVisibility(View.VISIBLE);
         mHolder.addMarks.setVisibility(View.GONE);
         mHolder.rltMarks.setVisibility(View.GONE);
         }
         
         if ("Online".equalsIgnoreCase(aModel.getSubmissionMode())) {
         mHolder.downloadBtn.setVisibility(View.VISIBLE);
         downloadFlow(mHolder, cModel);
         } else {
         mHolder.downloadBtn.setVisibility(View.GONE);
         }
         
         
 */
        
        
        
     
        
        if("Graded".caseInsensitiveCompare(assignmentObj.is_graded) == ComparisonResult.orderedSame){
            
            if("online".caseInsensitiveCompare(assignmentObj.submission_mode) == ComparisonResult.orderedSame && (assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).submission_id == "")
             {
// make it uncommented                
                cell.checkBoxImageView.isHidden = true

                cell.assignmentNameLabel.text  = "Yet to submit"
                cell.assignmentNameLabel.textColor = .red
                
                cell.downloadButton.isHidden = false
                cell.circleLabel.isHidden = true
                cell.buttomButton.isHidden =  true
    // set the text yet to submitted           //cell.
                
                
                
                
             }
            else
            {
              
                
                
                
                
                
 // make it uncommented  
               cell.checkBoxImageView.isHidden = false
               cell.buttomButton.isHidden  = false
                
                
                
       if((assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).assignment_marks != "")
       {
        
        cell.circleLabel.isHidden = false
        cell.circleLabel.text = (assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).assignment_marks
        drawFullCircle(end: CGPoint(x: self.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: self.circleLabel, completionPercentage: Double((assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).assignment_marks)!)
        cell.buttomButton.setTitle("Edit Marks", for: .normal)
        
        }
       else {
//        mHolder.rltMarks.setVisibility(View.GONE);
//        mHolder.addMarks.setText("Add Marks");
        
        
      
        cell.circleLabel.isHidden = true
        cell.buttomButton.setTitle("Add Marks", for: .normal)
            }
        }
        
        
    }
        else {
            // not graded case
         
         // make it uncommented            
             cell.checkBoxImageView.isHidden = false
            cell.circleLabel.isHidden = true
            cell.buttomButton.isHidden  = true
            

        }

    if("Online".caseInsensitiveCompare(assignmentObj.submission_mode) == ComparisonResult.orderedSame)
       {
        cell.downloadButton.isHidden = false
        }
        
        else
       {cell.downloadButton.isHidden  = true
        
        }
        
    
    
            
            
    
        /*
         
         if ("Graded".equalsIgnoreCase(aModel.getIsGraded())) {
         if ("Online".equalsIgnoreCase(aModel.getSubmissionMode()) && StringUtils.isNullOrEmpty(cModel.getSubmissionId())) {
         // online-graded- not submitted
         mHolder.markCheckBox.setVisibility(View.GONE);
         mHolder.addMarks.setVisibility(View.GONE);
         mHolder.rltMarks.setVisibility(View.GONE);
         mHolder.downloadBtn.setVisibility(View.VISIBLE);
         mHolder.downloadBtn.setText("Yet to submit");
         mHolder.downloadBtn.setTextColor(Color.RED);
         mHolder.downloadBtn.setOnClickListener(null);
         mHolder.downloadBtn.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
         } else {
         // online submitted -or- offline - but - graded
         mHolder.markCheckBox.setVisibility(View.VISIBLE);
         mHolder.addMarks.setVisibility(View.VISIBLE);
         
         if (!StringUtils.isNullOrEmpty(cModel.getAssignmentMarks())) {
         mHolder.rltMarks.setVisibility(View.VISIBLE);
         mHolder.progressMarks.setProgress(Integer.parseInt(cModel.getAssignmentMarks()));
         mHolder.progressMarks.setMax(Integer.parseInt(aModel.getTotalMarks()));
         mHolder.txvMarksPercent.setText(aModel.getTotalMarks());
         mHolder.addMarks.setText("Edit Marks");
         } else {
         mHolder.rltMarks.setVisibility(View.GONE);
         mHolder.addMarks.setText("Add Marks");
         }
         }
         } else {
         // not graded case
         mHolder.markCheckBox.setVisibility(View.VISIBLE);
         mHolder.addMarks.setVisibility(View.GONE);
         mHolder.rltMarks.setVisibility(View.GONE);
         }
         
         if ("Online".equalsIgnoreCase(aModel.getSubmissionMode())) {
         mHolder.downloadBtn.setVisibility(View.VISIBLE);
         downloadFlow(mHolder, cModel);
         } else {
         mHolder.downloadBtn.setVisibility(View.GONE);
         }
         
         
         
         
         
         
         
         
         */
        
        
        
  
        cell.submittedOnLabel.text = "Submitted on:" + (assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).reviewed_date_formatted
        cell.nameLabel.text =  (assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).fname + " "
        cell.nameLabel.text! = cell.nameLabel.text! + (assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).lname
        cell.markAsRecievedLabel.text = "Mark as received"
        cell.buttomButton.layer.cornerRadius = cell.buttomButton.frame.size.height/2
        cell.buttomButton.layer.borderColor = UIColor.init(hexString: "2D9FF4").cgColor
        cell.buttomButton.layer.borderWidth = 2
        
    //complete it // cell.assignmentNameLabel.text =
    //complete it //    cell.upperImageView.image = UIImage(named:"")
        
     
        cell.upperImageView.sd_setImage(with: URL(string: (assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).pic))
        
        
        //drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double((assignmentDetailObj?.student_submission_info[indexPath.row] as! student_submission_info).assignment_marks)!)
        
        cell.upperImageView.layer.cornerRadius = cell.upperImageView.frame.size.height/2
        cell.upperImageView.clipsToBounds = true
        cell.upperViewForTableCell.layer.cornerRadius = 3
        cell.selectionStyle = .none
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        _ =   self.navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    @IBAction func readButtonTapped1(_ sender: Any) {
        
        if(isExpanded == true)
        {
            
            self.mostUpperViewHeight.constant = mostUpperViewHeight.constant - self.innerViewHeight.constant
            self.innerViewHeight.constant = 0
            isExpanded = false
            self.readButton.setTitle("READ MORE", for: .normal)
        }
        else
        {
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(self.DescriptionLabel.text!, width: tableView.frame.size.width - 40)
            self.innerViewHeight.constant = 113 + addedWidth

          //  self.innerViewHeight.constant = 226
            self.mostUpperViewHeight.constant = mostUpperViewHeight.constant + self.innerViewHeight.constant
            isExpanded = true
            self.readButton.setTitle("READ LESS", for: .normal)
        }

    }
    @IBAction func readButtonTapped(_ sender: Any) {
        
           }
    
    
    @IBAction func readButtonTapped2(_ sender: Any) {
        if(isExpanded == true)
        {
            
            self.mostUpperViewHeight.constant = mostUpperViewHeight.constant - self.innerViewHeight.constant
            self.innerViewHeight.constant = 0
            isExpanded = false
            self.readButton.setTitle("READ MORE", for: .normal)
        }
        else
        {
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(self.DescriptionLabel.text!, width: tableView.frame.size.width - 40)
            self.innerViewHeight.constant = 113 + addedWidth
            
            //  self.innerViewHeight.constant = 226
            self.mostUpperViewHeight.constant = mostUpperViewHeight.constant + self.innerViewHeight.constant
            isExpanded = true
            self.readButton.setTitle("READ LESS", for: .normal)
        }

    }
    
}
