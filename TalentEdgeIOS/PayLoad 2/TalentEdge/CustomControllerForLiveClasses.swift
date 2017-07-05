//
//  CustomControllerForLiveClasses.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 25/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class CustomControllerForLiveClasses: UIViewController  ,UITableViewDataSource , UITableViewDelegate {
 

    @IBOutlet weak var tableView: UITableView!
    var liveClassDetailObj : LiveClassDetailsModel?
    var content_type_id: NSNumber?
    var content_id :NSNumber?
    
    var preIndex:IndexPath?
    var currentIndexPath:IndexPath?
    var isInStateOFOnlyOne:Bool = false
    
    @IBOutlet weak var titileLabel: UILabel!
    
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    @IBOutlet weak var leftUpperLabel: UILabel!
    
    
    @IBOutlet weak var leftMiddleView: UIView!
    
    
    @IBOutlet weak var leftBottomLabel: UILabel!
    
    
    
    @IBOutlet weak var circleLabel: UILabel!
    
    @IBOutlet weak var completedLabel: UILabel!
    
    
    @IBOutlet weak var rightUpperLabel: UILabel!
    
    
    @IBOutlet weak var rightMiddleView: UIView!
    
    
    @IBOutlet weak var rightBottomLabel: UILabel!
  
    var selected:Int = 0
    var liveClassObj: TEModuleDetailData!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        liveClassDetailObj = LiveClassDetailsModel()
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        preIndex = IndexPath(row: 0, section: 0)
        currentIndexPath = IndexPath(row: 0, section: 0)
      
      //  self.mainScrollView.isHidden = true
//        self.mostUpperView.layer.cornerRadius = 3

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
            self.liveClassDetailObj = (JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("LiveClassDetailsModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! LiveClassDetailsModel?)!
            //self.mainScrollView.isHidden = false
            self.setUpUIUpperView()
            //self.innerTableView.reloadData()
           // self.innerTableViewHeightConstraint.constant = self.innerTableView.contentSize.height
            self.tableView.reloadData()
            
           // self.innerTableView.isScrollEnabled = false
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    func setUpUIUpperView()
    {
        
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        
        self.titileLabel.text = liveClassObj.title
        self.subTitleLabel.text = liveClassObj.module_name
//
        self.leftUpperLabel.text = String(liveClassObj.total_invitees_attended_in_live_class.intValue)
        self.leftBottomLabel.text = "Live Session"
        drawLineFromPoint(CGPoint(x: Double(self.leftMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.leftMiddleView ), String(describing: liveClassObj.participation_percentage_in_live_class))

        
        
          drawFullCircle(end: CGPoint(x: self.circleLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: self.circleLabel, completionPercentage: Double(liveClassObj.participation_percentage_in_live_class))
        
        self.completedLabel.text = "Attendance"
        
        
        self.rightUpperLabel.text = String(describing: liveClassObj.total_invitees_attended_in_recorded_class)
        self.rightBottomLabel.text = "Recorded Session"
        
        drawLineFromPoint(CGPoint(x: Double(self.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.rightMiddleView ), String(describing: liveClassObj.participation_percentage_in_recorded_class))
        
        //draw circle
        //  cell.circleAttandanceLabel
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return
        if(tableView ==  self.tableView)
        {
          return (liveClassDetailObj?.student_session_info.count)!
        }
        else{
            return (liveClassDetailObj?.student_session_info[selected] as! student_session_info).time_details.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.tableView)
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! CellForLiveClassesDetail
        cell.innerTableView.reloadData()
        cell.innerTableViewHeightConstraint.constant = cell.innerTableView.contentSize.height
        cell.innerTableView.isScrollEnabled = false
        cell.nameLabel.text = (liveClassDetailObj?.student_session_info[indexPath.row] as! student_submission_info).fname + " "
        cell.nameLabel.text = cell.nameLabel.text! + (liveClassDetailObj?.student_session_info[indexPath.row] as! student_submission_info).lname
       
        cell.sessionLabel.text = "Session: Live"
        cell.sendMessageButton.layer.cornerRadius = cell.sendMessageButton.frame.size.height/2
        cell.sendMessageButton.layer.borderColor = UIColor.init(hexString: "2D9FF4").cgColor
        cell.sendMessageButton.layer.borderWidth = 2
        
          
        cell.profileImageView.sd_setImage(with: URL(string: (liveClassDetailObj?.student_session_info[indexPath.row] as! student_submission_info).pic))
        
            
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height/2
        cell.profileImageView.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
        }
        else  //(tableView == self.innerTableView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timingCell", for: indexPath) as! TimingCell
            
            cell.upperRoundView.layer.cornerRadius = cell.upperRoundView.frame.size.height/2
            cell.upperRoundView.backgroundColor = UIColor.red
            cell.lowerRoundView.layer.cornerRadius = cell.lowerRoundView.frame.size.height/2
            cell.lowerRoundView.backgroundColor = UIColor.black
             let yourAttributes = [NSForegroundColorAttributeName: UIColor.init(hexString: "2D9FF4")]
            
            let partOne =  NSMutableAttributedString(string: String(describing: ((liveClassDetailObj?.student_session_info[indexPath.row] as! student_session_info).time_details[indexPath.row] as! time_details).in_time), attributes: yourAttributes)
            
                    let combination = NSMutableAttributedString()
                    combination.append(NSAttributedString(string: "In Time: "))
                    combination.append(partOne)
                    cell.leftTimingLabel.attributedText = combination
    
            let partOne1 = NSMutableAttributedString(string: String(describing: ((liveClassDetailObj?.student_session_info[indexPath.row] as! student_session_info).time_details[indexPath.row] as! time_details).out_time), attributes: yourAttributes)
           
            let combination1 = NSMutableAttributedString()
            combination1.append(NSAttributedString(string: "Out Time: "))
            combination1.append(partOne1)
           
            cell.rightTimingLabel.attributedText = combination1
            
            return cell
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if( currentIndexPath == indexPath )
        {
        }
        else
        {
            selected = indexPath.row
            preIndex = currentIndexPath
            currentIndexPath = indexPath
            tableView.reloadRows(at: [preIndex!,currentIndexPath!], with: UITableViewRowAnimation.top)
            isInStateOFOnlyOne = false
        }
    }

    
    @IBAction func backButtonAction(_ sender : AnyObject){
        _ =   self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let abc = tableView.cellForRow(at: indexPath) as! CellForLiveClassesDetail
        
        if(tableView == abc.innerTableView )
        {
            return 90
        }
        else
        {
            return 250 + abc.innerTableViewHeightConstraint.constant
        }
        
    }
    

    
    
}
