//
//  TDashBoardViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 22/05/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


class TDashBoardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoSubView: UIView!
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var subDetailLabel: UILabel!
    
    var myCourseList = TECourseList()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 480.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.tableFooterView = UIView()
        loadUI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUI()
    {
        nameLabel.text = ModelManager.singleton.loginData == nil ? "Hello Guest" : "Hi " + ModelManager.singleton.loginData.resultData.user.fName + " " + ModelManager.singleton.loginData.resultData.user.lName
        self.subDetailLabel.text = String(format:"Checkout your %d latest courses and their progress",self.myCourseList.ongoingCourse.count)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
         return (myCourseList.facultyOngoingCourse.count == 0 && myCourseList.facultyCompletedCourse.count == 0) ? 0 : myCourseList.facultyCompletedCourse.count == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRect(x:tableView.frame.size.width,y:0,width:tableView.frame.size.width,height:0))
            
        }else {
            let view = UIView(frame: CGRect(x:0,y:0,width:220,height:60))
            let label = UILabel(frame: CGRect(x:(UIScreen.main.bounds.size.width/2) - 110,y:0,width:200,height:50))
            
            label.text = "COURSE COMPLETED"
            
            label.textAlignment = .center
            label.textColor = DataUtils.colorWithHexString("707070")
            let checkedImageView = UIImageView(frame: CGRect(x:label.frame.origin.x - 25 ,y:8,width:30,height:30))
            checkedImageView.image = UIImage(named: "tick.png")
            
            view.addSubview(checkedImageView)
            view.addSubview(label)
            return view
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false
    }

    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 0 {
//        return UIView(frame: CGRect(x:tableView.frame.size.width,y:0,width:tableView.frame.size.width,height:0))
//
//    }else {
//        let view = UIView(frame: CGRect(x:0,y:0,width:220,height:30))
//        let label = UILabel(frame: CGRect(x:(UIScreen.main.bounds.size.width/2) - 110,y:0,width:200,height:50))
//
//        label.text = "COURSE COMPLETED"
//
//        label.textAlignment = .center
//        label.textColor = DataUtils.colorWithHexString("707070")
//        let checkedImageView = UIImageView(frame: CGRect(x:label.frame.origin.x - 25 ,y:8,width:30,height:30))
//        checkedImageView.image = UIImage(named: "tick.png")
//
//        view.addSubview(checkedImageView)
//        view.addSubview(label)
//        return view
//    }
//        
//    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 0 {
//                        return UIView(frame: CGRect(x:tableView.frame.size.width,y:0,width:tableView.frame.size.width,height:0))
//            
//                    }else {
//                        let view = UIView(frame: CGRect(x:0,y:0,width:220,height:30))
//                        let label = UILabel(frame: CGRect(x:(UIScreen.main.bounds.size.width/2) - 110,y:0,width:200,height:50))
//            
//                        label.text = "COURSE COMPLETED"
//            
//                        label.textAlignment = .center
//                        label.textColor = DataUtils.colorWithHexString("707070")
//                        let checkedImageView = UIImageView(frame: CGRect(x:label.frame.origin.x - 25 ,y:8,width:30,height:30))
//                        checkedImageView.image = UIImage(named: "tick.png")
//                        
//                        view.addSubview(checkedImageView)
//                        view.addSubview(label)
//                        return view
//                    }
//
//    }
//    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return section == 0 ? myCourseList.facultyOngoingCourse.count : myCourseList.facultyCompletedCourse.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let courseObj = indexPath.section == 0 ? myCourseList.facultyOngoingCourse[indexPath.row] as! TECourseData : myCourseList.facultyCompletedCourse[indexPath.row] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
//        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
//            ModelManager.singleton.courseImage = image
//            
//            
//        }) { (image) in
//            
//            ModelManager.singleton.courseImage = image
//            //self.navigationController?.pushViewController(detailVC, animated: true)
//        }
        
        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath.section != 0

        self.navigationController?.pushViewController(detailVC, animated: true)
        
        }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 1){
        return 60
        }
        else{
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == 0 ? "TMycourseCell" : "TMycourseCell" , for: indexPath) as! TMycourseCell
         tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        cell.layer.cornerRadius = 3
        cell.layer.cornerRadius = 3
        
        
        var courseObj : TECourseData = TECourseData()
        if(indexPath.section == 0)
        {
            
            cell.upperView.backgroundColor =  UIColor.init(hexString: "496AB4")
           // cell.upperView.layer.cornerRadius = 3
           // cell.upperLabel.textColor = UIColor.black
            
           // cell.messageUpperLabel.textColor = UIColor.black
            //cell.lowerLabel.textColor = UIColor.black

            courseObj = self.myCourseList.facultyOngoingCourse[indexPath.row] as! TECourseData
            cell.upperViewImage.layer.cornerRadius = cell.upperViewImage.frame.size.height/2
            cell.upperViewImage.clipsToBounds = true;

            
            
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: (cell.upperView.bounds), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: CGFloat(3.0), height: CGFloat(3.0))).cgPath
            cell.upperView.layer.mask = maskLayer

            
            
            cell.upperLabel.text = courseObj.course_name + "-" + courseObj.name
            cell.upperLabel.sizeToFit()
            //cell.teacherNameLabelOutlet.text = String(format: "By : %@ (%@)", (courseObj.faculty[0] as! NSDictionary).valueForKey("fname") as! String , courseObj.institute_name)
            cell.lowerLabel.text = courseObj.course_duration
            cell.lowerLabel.sizeToFit()
            //  cell.courseObject = courseObj
            // cell.upperViewImage.sd_setImageWithURL(NSURL(string: courseObj.logo), placeholderImage: UIImage())
            
            
            cell.upperViewImage.sd_setImage(with: NSURL(string: courseObj.logo) as URL!, placeholderImage: UIImage())
            
            
            cell.moduleLowerLabel.text = String(format: "%d/%d Module Completed", courseObj.completed.intValue, courseObj.total_modules.intValue)
            
            drawSemiCircle(end: CGPoint(x: cell.logoSubView.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.logoSubView, completionPercentage: abs(courseObj.pending_percentage.doubleValue),courseObj: courseObj)
           
            
            let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
            let partTwo = NSMutableAttributedString(string: String(format: "%.2f", abs(courseObj.pending_percentage.doubleValue)), attributes: [NSForegroundColorAttributeName: kOrangeColor])
            let partThree = NSMutableAttributedString(string: "%", attributes: [NSForegroundColorAttributeName: kOrangeColor])
            
            let partFour = NSMutableAttributedString(string: "Pending ", attributes: yourAttributes)
            
            let combination = NSMutableAttributedString()
            combination.append(partFour)
            combination.append(partTwo)
            combination.append(partThree)
            cell.moduleStatusLabel.attributedText = combination
            
            if( courseObj.class_participation_percentage.intValue == 0)
            {
             cell.attebdanceStatusLabel.text = String("0%")
            }
            else
            {
                cell.attebdanceStatusLabel.text = String(format: "%.d", courseObj.class_participation_percentage.intValue) + "%"
            }
            
            //cell.logoSubView.hidden = false
             drawFullCircle(end: CGPoint(x: cell.logoSubView.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.attendanceLogoSubView, completionPercentage: abs(courseObj.class_participation_percentage.doubleValue),courseObj: courseObj)
            
            
            
            cell.assessmentUpperLabel.text = String(describing: courseObj.assessment)
            cell.assignmentUpperLabel.text = String(describing: courseObj.assignment)
            cell.liveUpperLabel.text = "2"                     //ask
            cell.mystudentUpperLabel.text = String(describing: courseObj.learner)
            cell.messageUpperLabel.text  = "2" //courseObj.total_unread_message_and_doubt//ask
            cell.discussionUpperLabel.text = String(describing: courseObj.discussion)
            cell.myStudentFullView.layer.cornerRadius = 3
            cell.discussionFullView.layer.cornerRadius = 3
            cell.myStudentFullViewButton.layer.cornerRadius = 3
            cell.discussionFullViewButton.layer.cornerRadius = 3
            
        }
        else if(indexPath.section == 1)
        {
           // cell.backgroundColor = UIColor.black  // 2D3341
            cell.upperView.backgroundColor = UIColor.init(hexString: "2D3341") // 2D3341
            courseObj = self.myCourseList.facultyCompletedCourse[indexPath.row] as! TECourseData
            //cell.upperView.layer.cornerRadius = 3
            cell.upperLabel.textColor = UIColor.white

        //    cell.messageUpperLabel.textColor = UIColor.white
            cell.lowerLabel.textColor = UIColor.white
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: (cell.upperView.bounds), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: CGFloat(3.0), height: CGFloat(3.0))).cgPath
            cell.upperView.layer.mask = maskLayer
            

            
            
            
            cell.upperLabel.text = courseObj.course_name + "-" + courseObj.name
            cell.upperLabel.sizeToFit()
            //cell.teacherNameLabelOutlet.text = String(format: "By : %@ (%@)", (courseObj.faculty[0] as! NSDictionary).valueForKey("fname") as! String , courseObj.institute_name)
            cell.lowerLabel.text = "Completed On:" + courseObj.completed_on
            cell.lowerLabel.sizeToFit()
            //  cell.courseObject = courseObj
            // cell.upperViewImage.sd_setImageWithURL(NSURL(string: courseObj.logo), placeholderImage: UIImage())
            
            
            cell.upperViewImage.layer.cornerRadius = cell.upperViewImage.frame.size.height/2
             cell.upperViewImage.clipsToBounds = true;
            cell.moduleLowerLabel.text = String(format: "%d/%d Module Completed", courseObj.completed.intValue, courseObj.total_modules.intValue)
            
            drawSemiCircle(end: CGPoint(x: cell.logoSubView.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.logoSubView, completionPercentage: abs(courseObj.pending_percentage.doubleValue),courseObj: courseObj)
            
            let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
            let partTwo = NSMutableAttributedString(string: String(format: "%.2f", abs(courseObj.pending_percentage.doubleValue)), attributes: [NSForegroundColorAttributeName: kOrangeColor])
            let partThree = NSMutableAttributedString(string: "%", attributes: [NSForegroundColorAttributeName: kOrangeColor])
            
            let partFour = NSMutableAttributedString(string: "Pending ", attributes: yourAttributes)
            
            let combination = NSMutableAttributedString()
            combination.append(partFour)
            combination.append(partTwo)
            combination.append(partThree)
            cell.moduleStatusLabel.attributedText = combination
            
            cell.attebdanceStatusLabel.text = String(format: "%.d", courseObj.class_participation_percentage.intValue == 0 ? 0 : courseObj.class_participation_percentage.intValue) + "%"
            
            
            if( courseObj.class_participation_percentage.intValue == 0)
            {
                cell.attebdanceStatusLabel.text = String("0%")
            }
            else
            {
                cell.attebdanceStatusLabel.text = String(format: "%.d", courseObj.class_participation_percentage.intValue) + "%"
            }
            
            
          //  cell.attebdanceStatusLabel.text = String(format: "%.d", courseObj.class_participation_percentage.intValue == 0 ? 0 : courseObj.class_participation_percentage.intValue) + "%"
            
            //cell.logoSubView.hidden = false
            drawFullCircle(end: CGPoint(x: cell.logoSubView.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.attendanceLogoSubView, completionPercentage: abs(courseObj.class_participation_percentage.doubleValue),courseObj: courseObj)
            
            
            
            cell.upperViewImage.sd_setImage(with: NSURL(string: courseObj.logo) as URL!, placeholderImage: UIImage())
            
            cell.assessmentUpperLabel.text = String(describing: courseObj.assessment.intValue)
            cell.assignmentUpperLabel.text = String(describing: courseObj.assignment.intValue)
            cell.liveUpperLabel.text = String(describing:courseObj.live_class.intValue)//ask
            cell.mystudentUpperLabel.text = String(courseObj.learner.intValue)
            //cell.messageUpperLabel.text  = String(describing: courseObj.total_unread_message_and_doubt)
            cell.messageUpperLabel.text = String(courseObj.total_unread_message_and_doubt.intValue)
            //courseObj.total_unread_message_and_doubt//ask
            cell.discussionUpperLabel.text = String(describing: courseObj.discussion)
           
        }

        
//        cell.upperLabel.text = courseObj.course_name + "-" + courseObj.name
//        cell.upperLabel.sizeToFit()
//        //cell.teacherNameLabelOutlet.text = String(format: "By : %@ (%@)", (courseObj.faculty[0] as! NSDictionary).valueForKey("fname") as! String , courseObj.institute_name)
//        cell.lowerLabel.text = courseObj.course_duration
//        cell.lowerLabel.sizeToFit()
//      //  cell.courseObject = courseObj
//       // cell.upperViewImage.sd_setImageWithURL(NSURL(string: courseObj.logo), placeholderImage: UIImage())
//        
//
//        cell.upperViewImage.sd_setImage(with: NSURL(string: courseObj.logo) as URL!, placeholderImage: UIImage())
//        cell.assessmentUpperLabel.text = String(describing: courseObj.assessment)
//        cell.assignmentUpperLabel.text = String(describing: courseObj.assignment)
//        cell.liveUpperLabel.text = "No live class" //ask
//        cell.mystudentUpperLabel.text = String(describing: courseObj.learner)
//        cell.messageUpperLabel.text  = "2" //courseObj.total_unread_message_and_doubt//ask
//        cell.discussionUpperLabel.text = String(describing: courseObj.discussion)
        
        
        if indexPath.row == 0 {
            ServerCommunication.singleton.imageFromServerURL(courseObj.logo, success: { (image) in
                ModelManager.singleton.courseImage = image
            }) { (image) in
                ModelManager.singleton.courseImage = image
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
     return cell
    }

    
    
    func drawFullCircle(end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, completionPercentage : Double, courseObj : TECourseData)
    {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(30), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(M_PI/2 + M_PI*2), clockwise: true)
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
        shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor
        
        shapeLayer1.lineWidth = 10
       // shapeLayer1.addSublayer(shapeLayer)
        
        let angle = completionPercentage * 3.6
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(30), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(((90 + angle)/180)*M_PI), clockwise: true)
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
        shapeLayer3.strokeColor = UIColor.init(hexString: "2F9DD4").cgColor
        shapeLayer3.lineWidth = 10
       // shapeLayer3.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer3)
//        
//        let angle1 = abs(courseObj.completion_percentage.doubleValue) * 1.8
//        let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height), radius: CGFloat(60), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(((90 + angle1)/180)*M_PI), clockwise: true)
//        let shapeLayer4 = CAShapeLayer()
//        shapeLayer4.path = circlePath2.cgPath
//        shapeLayer4.lineDashPattern = [5 ,5]
//        shapeLayer4.fillColor = UIColor.clear.cgColor
//        shapeLayer4.strokeColor = UIColor.white.cgColor
//        shapeLayer4.lineWidth = 1.0
//        let shapeLayer5 = CAShapeLayer()
//        shapeLayer5.path = circlePath2.cgPath
//        shapeLayer5.fillColor = UIColor.clear.cgColor
//        shapeLayer5.strokeColor = DataUtils.colorWithHexString("3bab14").cgColor
//        shapeLayer5.lineWidth = 10
//        shapeLayer5.addSublayer(shapeLayer4)
//        view.layer.addSublayer(shapeLayer5)
        
        
    }
    
    func drawSemiCircle(end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, completionPercentage : Double, courseObj : TECourseData) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height), radius: CGFloat(40), startAngle: CGFloat(M_PI), endAngle:CGFloat(0), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineDashPattern = [5 ,5]
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = circlePath.cgPath
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
         shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor
        shapeLayer1.lineWidth = 25
        shapeLayer1.addSublayer(shapeLayer)
        
        let angle = completionPercentage * 1.8
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height), radius: CGFloat(40), startAngle: CGFloat(M_PI), endAngle:CGFloat(((180 + angle)/180)*M_PI), clockwise: true)
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = circlePath1.cgPath
        shapeLayer2.lineDashPattern = [5 ,5]
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.strokeColor = UIColor.white.cgColor
        shapeLayer2.lineWidth = 1.0
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = circlePath1.cgPath
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.strokeColor = kOrangeColor.cgColor
        shapeLayer3.lineWidth = 25
        shapeLayer3.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer3)
        
        let angle1 = abs(courseObj.completion_percentage.doubleValue) * 1.8
        let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height), radius: CGFloat(40), startAngle: CGFloat(M_PI), endAngle:CGFloat(((180 + angle1)/180)*M_PI), clockwise: true)
        let shapeLayer4 = CAShapeLayer()
        shapeLayer4.path = circlePath2.cgPath
        shapeLayer4.lineDashPattern = [5 ,5]
        shapeLayer4.fillColor = UIColor.clear.cgColor
        shapeLayer4.strokeColor = UIColor.white.cgColor
        shapeLayer4.lineWidth = 1.0
        let shapeLayer5 = CAShapeLayer()
        shapeLayer5.path = circlePath2.cgPath
        shapeLayer5.fillColor = UIColor.clear.cgColor
        shapeLayer5.strokeColor = DataUtils.colorWithHexString("3bab14").cgColor
        shapeLayer5.lineWidth = 25
        shapeLayer5.addSublayer(shapeLayer4)
        view.layer.addSublayer(shapeLayer5)
    
    }

    @IBAction func attendanceButtonTapped(_ sender: Any) {
        
        
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        
        let courseObj = indexPath?.section == 0 ? myCourseList.facultyOngoingCourse[(indexPath?.row)!] as! TECourseData : myCourseList.facultyCompletedCourse[(indexPath?.row)!] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
        //        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
        //            ModelManager.singleton.courseImage = image
        //
        //
        //        }) { (image) in
        //
        //            ModelManager.singleton.courseImage = image
        //            //self.navigationController?.pushViewController(detailVC, animated: true)
        //        }
        
        detailVC.selectedTabIndex = 3
        
        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath?.section != 0
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        

        
        
        
    }
    
    
    @IBAction func LiveClassTapped(_ sender: Any) {
        
        // var indexPath =  getRowNumber(sender)!
        
        
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        
        let courseObj = indexPath?.section == 0 ? myCourseList.facultyOngoingCourse[(indexPath?.row)!] as! TECourseData : myCourseList.facultyCompletedCourse[(indexPath?.row)!] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
        //        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
        //            ModelManager.singleton.courseImage = image
        //
        //
        //        }) { (image) in
        //
        //            ModelManager.singleton.courseImage = image
        //            //self.navigationController?.pushViewController(detailVC, animated: true)
        //        }
        
        detailVC.selectedTabIndex = 2

        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath?.section != 0
        
        self.navigationController?.pushViewController(detailVC, animated: true)

        
    }
    @IBAction func AssignmentButtonTapped(_ sender: Any) {
        
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        
        let courseObj = indexPath?.section == 0 ? myCourseList.facultyOngoingCourse[(indexPath?.row)!] as! TECourseData : myCourseList.facultyCompletedCourse[(indexPath?.row)!] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
        //        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
        //            ModelManager.singleton.courseImage = image
        //
        //
        //        }) { (image) in
        //
        //            ModelManager.singleton.courseImage = image
        //            //self.navigationController?.pushViewController(detailVC, animated: true)
        //        }
        
        detailVC.selectedTabIndex = 4
        
        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath?.section != 0
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
    @IBAction func AssessmentButtonTapped(_ sender: Any) {
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        
        let courseObj = indexPath?.section == 0 ? myCourseList.facultyOngoingCourse[(indexPath?.row)!] as! TECourseData : myCourseList.facultyCompletedCourse[(indexPath?.row)!] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
        //        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
        //            ModelManager.singleton.courseImage = image
        //
        //
        //        }) { (image) in
        //
        //            ModelManager.singleton.courseImage = image
        //            //self.navigationController?.pushViewController(detailVC, animated: true)
        //        }
        
        detailVC.selectedTabIndex = 5
        
        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath?.section != 0
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
    @IBAction func myStudentsTapped(_ sender: Any) {
        
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        
        let courseObj = indexPath?.section == 0 ? myCourseList.facultyOngoingCourse[(indexPath?.row)!] as! TECourseData : myCourseList.facultyCompletedCourse[(indexPath?.row)!] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
        //        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
        //            ModelManager.singleton.courseImage = image
        //
        //
        //        }) { (image) in
        //
        //            ModelManager.singleton.courseImage = image
        //            //self.navigationController?.pushViewController(detailVC, animated: true)
        //        }
        
     //   detailVC.selectedTabIndex = 2
        
        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath?.section != 0
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        

    }
    
    @IBAction func DoubtsButtonTapped(_ sender: Any) {
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        
        let courseObj = indexPath?.section == 0 ? myCourseList.facultyOngoingCourse[(indexPath?.row)!] as! TECourseData : myCourseList.facultyCompletedCourse[(indexPath?.row)!] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
        //        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
        //            ModelManager.singleton.courseImage = image
        //
        //
        //        }) { (image) in
        //
        //            ModelManager.singleton.courseImage = image
        //            //self.navigationController?.pushViewController(detailVC, animated: true)
        //        }
        
       // detailVC.selectedTabIndex = 2
        
        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath?.section != 0
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        


    }
    
    
    @IBAction func discussionButtonTapped(_ sender: Any) {
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        
        let courseObj = indexPath?.section == 0 ? myCourseList.facultyOngoingCourse[(indexPath?.row)!] as! TECourseData : myCourseList.facultyCompletedCourse[(indexPath?.row)!] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
        //        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
        //            ModelManager.singleton.courseImage = image
        //
        //
        //        }) { (image) in
        //
        //            ModelManager.singleton.courseImage = image
        //            //self.navigationController?.pushViewController(detailVC, animated: true)
        //        }
        
        detailVC.selectedTabIndex = 6
        
        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath?.section != 0
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        


    }
    
    @IBAction func moduleCompletedButtonTapped(_ sender: Any) {
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        
        let courseObj = indexPath?.section == 0 ? myCourseList.facultyOngoingCourse[(indexPath?.row)!] as! TECourseData : myCourseList.facultyCompletedCourse[(indexPath?.row)!] as! TECourseData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMyCourseDetailViewController") as! TMyCourseDetailViewController
        
        
        //        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
        //            ModelManager.singleton.courseImage = image
        //
        //
        //        }) { (image) in
        //
        //            ModelManager.singleton.courseImage = image
        //            //self.navigationController?.pushViewController(detailVC, animated: true)
        //        }
        
        detailVC.selectedTabIndex = 1
        
        detailVC.selectedCourseObj = courseObj
        detailVC.isCourseCompleted = indexPath?.section != 0
        
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
        shapeLayer.lineWidth = 1.0
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = circlePath.cgPath
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
         shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor
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
        shapeLayer3.strokeColor = UIColor.init(hexString :"2F9DD4").cgColor
        //419E13
       // shapeLayer3.strokeColor =
        //419E13
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
        shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor
        shapeLayer1.lineWidth = 10.0
        //        shapeLayer1.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer)
    }
    func cornerLayouts()
    {
    }

    
    
}

