//
//  TLiveClassesViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 13/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class TLiveClassesViewController: UIViewController,UITableViewDelegate , UITableViewDataSource{

    var subModuleArray : [TLiveData]!
    
    var isCameFromDrawer : Bool!

    @IBOutlet weak var liveClassTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subModuleArray = [TLiveData]()
        liveClassTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        liveClassTableView.showsVerticalScrollIndicator = false
        liveClassTableView.tableFooterView = UIView()
        liveClassTableView.delegate = self
        liveClassTableView.dataSource = self
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
        let str = String(format: "batch_id=%d&content_type_id=7",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_NOTES_DETAILS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.subModuleArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TLiveData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TLiveData]
            self.liveClassTableView.reloadData()
            
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
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        
//    let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveClassTableCell", for: indexPath) as! LiveClassTableCell
//        cell.titleLabel.text = subModuleArray[indexPath.row].title
//        cell.descriptionTextVIew.text = "Live Class"
//        
//        cell.subTitleLabel.text = subModuleArray[indexPath.row].module_name
//        //cell.bottomBlueButton.setTitle("  " + subModuleArray[indexPath.row].action + "  ", for: UIControlState())
//        cell.plusImageView.image = UIImage(named: "live_class1.PNG")
//        let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date, attributes: yourAttributes)
//        let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].content_duration_formatted, attributes: yourAttributes)
//        let combination = NSMutableAttributedString()
//        combination.append(NSAttributedString(string: "Session Date : "))
//        combination.append(partOne)
//        combination.append(NSAttributedString(string: " | Duration : "))
//        combination.append(partTwo)
//        cell.publishDateLabel.attributedText = combination
//        
//        let combination1 = NSMutableAttributedString()
//        combination1.append(NSAttributedString(string: "Duration : "))
//        combination1.append(partTwo)
//        cell.durationLabel.attributedText = combination1
//        
//        cell.attendanceLabel.text = "Attendance"
//        
//        cell.circleAttandanceLabel.text = String(describing: subModuleArray[indexPath.row].participation_percentage_in_live_class)
//        
//        cell.circleAttandanceLabel.text =   cell.circleAttandanceLabel.text! + "%"
//        
//        
//        //draw circle
//        //  cell.circleAttandanceLabel
//        drawFullCircle(end: CGPoint(x: cell.circleAttandanceLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleAttandanceLabel, completionPercentage: Double(subModuleArray[indexPath.row].participation_percentage_in_live_class)!)
//        
//        cell.leftUpperLabel.text  =  String(describing: subModuleArray[indexPath.row].total_invitees_attended_in_live_class)
//        cell.leftUpperLabel.text = cell.leftUpperLabel.text! + " Students"
//        
//        //  cell.leftMiddleView
//        
//        cell.leftBottomLabel.text = "Live Session"
//        
//        // cell.leftImageView.image = UIImage(named:"")
//        
//        cell.rightUpperLabel.text  = String(describing: subModuleArray[indexPath.row].total_invitees_attended_in_recorded_class )
//        cell.rightUpperLabel.text = cell.rightUpperLabel.text!  + " Stduents"
//        
//        
//        //ask it             cell.descriptionTextVIew.text = subModuleArray[indexPath.row].description
//        
//        cell.rightBottomLabel.text = "Recorded Sesssion"
//        
//        //cell.rightImageView.image = UIImage(named:"")
//        
//        drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing: subModuleArray[indexPath.row].participation_percentage_in_recorded_class))
//        drawLineFromPoint(CGPoint(x: Double(cell.leftMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.leftMiddleView), String(describing: subModuleArray[indexPath.row].participation_percentage_in_live_class))
//        cell.tag = 100 + indexPath.row
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
//    return cell
//    
//    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
//                let cell = tableView.dequeueReusableCell(withIdentifier: "LiveClassTableCell", for: indexPath) as! LiveClassTableCell
//                cell.titleLabel.text = subModuleArray[indexPath.row].title
//                cell.descriptionTextVIew.text = "Live Class"
//        
//                cell.subTitleLabel.text = subModuleArray[indexPath.row].module_name
//                //cell.bottomBlueButton.setTitle("  " + subModuleArray[indexPath.row].action + "  ", for: UIControlState())
//                cell.plusImageView.image = UIImage(named: "live_class.PNG")
//                let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date, attributes: yourAttributes)
//                let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].content_duration_formatted, attributes: yourAttributes)
//                let combination = NSMutableAttributedString()
//                combination.append(NSAttributedString(string: "Session Date : "))
//                combination.append(partOne)
//                combination.append(NSAttributedString(string: " | Duration : "))
//                combination.append(partTwo)
//                cell.publishDateLabel.attributedText = combination
//        
//                let combination1 = NSMutableAttributedString()
//                combination1.append(NSAttributedString(string: "Duration : "))
//                combination1.append(partTwo)
//                cell.durationLabel.attributedText = combination1
//        
//                cell.attendanceLabel.text = "Attendance"
//        
//                cell.circleAttandanceLabel.text = String(describing: subModuleArray[indexPath.row].participation_percentage_in_live_class)
//        
//                cell.circleAttandanceLabel.text =   cell.circleAttandanceLabel.text! + "%"
//        
//        
//                //draw circle
//                //  cell.circleAttandanceLabel
//                drawFullCircle(end: CGPoint(x: cell.circleAttandanceLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleAttandanceLabel, completionPercentage: Double(subModuleArray[indexPath.row].participation_percentage_in_live_class)!)
//        
//                cell.leftUpperLabel.text  =  String(describing: subModuleArray[indexPath.row].total_invitees_attended_in_live_class)
//                cell.leftUpperLabel.text = cell.leftUpperLabel.text! + " Students"
//        
//                //  cell.leftMiddleView
//        
//                cell.leftBottomLabel.text = "Live Session"
//        
//                // cell.leftImageView.image = UIImage(named:"")
//        
//                cell.rightUpperLabel.text  = String(describing: subModuleArray[indexPath.row].total_invitees_attended_in_recorded_class )
//                cell.rightUpperLabel.text = cell.rightUpperLabel.text!  + " Stduents"
//        
//        
//                //ask it             cell.descriptionTextVIew.text = subModuleArray[indexPath.row].description
//        
//                cell.rightBottomLabel.text = "Recorded Sesssion"
//        
//                //cell.rightImageView.image = UIImage(named:"")
//        
//                drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing: subModuleArray[indexPath.row].participation_percentage_in_recorded_class))
//                drawLineFromPoint(CGPoint(x: Double(cell.leftMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.leftMiddleView), String(describing: subModuleArray[indexPath.row].participation_percentage_in_live_class))
//                cell.tag = 100 + indexPath.row
//                cell.selectionStyle = UITableViewCellSelectionStyle.none
//            return cell
//        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveClassTableCell", for: indexPath) as! LiveClassTableCell
        cell.titleLabel.text = subModuleArray[indexPath.row].title
        cell.descriptionTextVIew.text = "Live Class"
        
        cell.subTitleLabel.text = subModuleArray[indexPath.row].module_name
        //cell.bottomBlueButton.setTitle("  " + subModuleArray[indexPath.row].action + "  ", for: UIControlState())
        cell.plusImageView.image = UIImage(named: "live_class")
        let partOne = NSMutableAttributedString(string: subModuleArray[indexPath.row].start_date, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: subModuleArray[indexPath.row].content_duration_formatted, attributes: yourAttributes)
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
        
        cell.circleAttandanceLabel.text = String(describing: subModuleArray[indexPath.row].participation_percentage_in_live_class)
        
        cell.circleAttandanceLabel.text =   cell.circleAttandanceLabel.text! + "%"
        
        //draw circle
        //  cell.circleAttandanceLabel
        drawFullCircle(end: CGPoint(x: cell.circleAttandanceLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.circleAttandanceLabel, completionPercentage: Double(subModuleArray[indexPath.row].participation_percentage_in_live_class))
        
        cell.leftUpperLabel.text  =  String(describing: subModuleArray[indexPath.row].total_invitees_attended_in_live_class)
        cell.leftUpperLabel.text = cell.leftUpperLabel.text! + " Students"
        
        //  cell.leftMiddleView
        
        cell.leftBottomLabel.text = "Live Session"
        
        // cell.leftImageView.image = UIImage(named:"")
        
        cell.rightUpperLabel.text  = String(describing: subModuleArray[indexPath.row].total_invitees_attended_in_recorded_class )
        cell.rightUpperLabel.text = cell.rightUpperLabel.text!  + " Stduents"
        
        
        cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
        
        cell.rightBottomLabel.text = "Recorded Sesssion"
        
        //cell.rightImageView.image = UIImage(named:"")
        
        drawLineFromPoint(CGPoint(x: Double(cell.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.rightMiddleView), String(describing: subModuleArray[indexPath.row].participation_percentage_in_recorded_class))
        drawLineFromPoint(CGPoint(x: Double(cell.leftMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.leftMiddleView), String(describing: subModuleArray[indexPath.row].participation_percentage_in_live_class))
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
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//          // ********************uncomment it after correction
//        /*
////        let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 48)
////
//
//        // return 145.0+addedWidth
// */
//        return 145
//
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(subModuleArray[indexPath.row].desc, width: tableView.frame.size.width - 50)
        return 270+addedWidth
    }
    func setTheDetailModelObj(_ modelObj : TLiveData) -> TEModuleDetailData
    {
        var returnModel = TEModuleDetailData()
         
        
        returnModel.title = modelObj.title
        returnModel.start_date = modelObj.start_date
        returnModel.start_date_value = modelObj.start_date_formatted
        returnModel.end_date_label = modelObj.end_date
        returnModel.end_date_value = modelObj.end_date_formatted
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
       // detailVC.liveClassObj = self.subModuleArray[indexPath.row]
        
       detailVC.liveClassObj =  setTheDetailModelObj(self.subModuleArray[indexPath.row])
        detailVC.content_type_id = 7
        detailVC.content_id = self.subModuleArray[indexPath.row].id
        // detailVC.noteObj = noteObj
        self.navigationController?.pushViewController(detailVC, animated: true)

        
    }
    
    func drawFullCircle(end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, completionPercentage : Double)
    {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(24), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(M_PI/2 + M_PI*2), clockwise: true)
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
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(24), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(((90 + angle)/180)*M_PI), clockwise: true)
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
