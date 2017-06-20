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
    var assignmentArray : [TEAssignmentData]!

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
        
        //          // ********************uncomment it after correction
        //        /*
        ////        let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 48)
        ////
        //
        //        // return 145.0+addedWidth
        // */
        
        return 550
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
   let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableCell", for: indexPath) as! AssignmentTableCell
    cell.titleLabel.text = subModuleArray[indexPath.row].title
    cell.subtitleLabel.text = subModuleArray[indexPath.row].module_name
    //cell.bottomBlueButton.setTitle("  View  ", for: UIControlState())
    cell.upperImageView.image = UIImage(named: "Assignment1.png")
    
    let part1 = NSMutableAttributedString(string: "total Marks")
    let part2 = NSMutableAttributedString(string: String(format : "%d",subModuleArray[indexPath.row].total_marks.intValue), attributes: yourAttributes)
    let part3 = NSMutableAttributedString(string: subModuleArray[indexPath.row].submission_mode, attributes: yourAttributes)
    let combination1 = NSMutableAttributedString()
    combination1.append(part1)
    combination1.append(NSAttributedString(string: " : "))
    combination1.append(part2)
    combination1.append(NSAttributedString(string: " | Mode : "))
    combination1.append(part3)
    cell.publishedLabel.attributedText = combination1
    
    
    let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date, attributes: yourAttributes)
    let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].end_date, attributes: yourAttributes)
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
        
        //draw circle
    //  cell.circleAttandanceLabel
    drawFullCircle(end: CGPoint(x: cell.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleLabel, completionPercentage: Double(subModuleArray[indexPath.row].avg_completion_percentage)!)
    
    cell.circleLabel.text  =  String(describing: subModuleArray[indexPath.row].avg_completion_percentage)
    cell.circleLabel.text =   cell.circleLabel.text! + "%"
   // cell.circleLabel.text =

    return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    
   
}
