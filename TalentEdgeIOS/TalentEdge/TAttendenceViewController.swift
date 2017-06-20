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
        
        if let modelObj = attenanceModelObj
        {
             return modelObj.liveSessionAttendance.count
        }
        return 0
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveClassTableCell", for: indexPath) as! LiveClassTableCell

        cell.titleLabel.text = (subModuleArray as AnyObject).title
        cell.descriptionTextVIew.text = "Live Class"
      
        cell.subTitleLabel.text = (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel ).module_name
        cell.subTitleLabel.text = (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel as TAttendanceModel).module_name
        //cell.bottomBlueButton.setTitle("  " + subModuleArray.action + "  ", for: UIControlState())
        cell.plusImageView.image = UIImage(named: "live_class1.PNG")
        let partOne = NSMutableAttributedString(string: (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).start_date, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).content_duration_formated, attributes: yourAttributes)
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
        
        cell.circleAttandanceLabel.text = String(describing: (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).participation_percentage_in_live_class)
        
        cell.circleAttandanceLabel.text =   cell.circleAttandanceLabel.text! + "%"
        
        
        //draw circle
        //  cell.circleAttandanceLabel
        drawFullCircle(end: CGPoint(x: cell.circleAttandanceLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleAttandanceLabel, completionPercentage: Double((attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).participation_percentage_in_live_class)!)
        
        cell.leftUpperLabel.text  =  String(describing: (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).total_invitees_attended_in_live_class)
        cell.leftUpperLabel.text = cell.leftUpperLabel.text! + " Students"
        
        //  cell.leftMiddleView
        
        cell.leftBottomLabel.text = "Live Session"
        
        // cell.leftImageView.image = UIImage(named:"")
        
        cell.rightUpperLabel.text  = String(describing: (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).total_invitees_attended_in_recorded_class )
        cell.rightUpperLabel.text = cell.rightUpperLabel.text!  + " Stduents"
        
        
        //ask it             cell.descriptionTextVIew.text = subModuleArray.description
        
        cell.rightBottomLabel.text = "Recorded Sesssion"
        
        //cell.rightImageView.image = UIImage(named:"")
        
        drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing: (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).participation_percentage_in_recorded_class))
        drawLineFromPoint(CGPoint(x: Double(cell.leftMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.leftMiddleView), String(describing: (attenanceModelObj.liveSessionAttendance[indexPath.row] as! TAttendanceModel).participation_percentage_in_live_class))
        cell.tag = 100 + indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //          // ********************uncomment it after correction
        //        /*
        ////        let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 48)
        ////
        //
        //        // return 145.0+addedWidth
        // */
        
        return 310
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
