//
//  MyCourseViewController.swift
//  TalentEdge
//
//

import UIKit

class MyCourseViewController: UIViewController {
    
    @IBOutlet weak var myCourseTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subDetailLabel: UILabel!
    
    var myCourseList = TECourseList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }
    
    fileprivate func loadUI() {
        nameLabel.text = ModelManager.singleton.loginData == nil ? "Hello Guest" : "Hi " + ModelManager.singleton.loginData.resultData.user.fName + " " + ModelManager.singleton.loginData.resultData.user.lName
        self.subDetailLabel.text = String(format:"Checkout your %d latest courses and their progress",self.myCourseList.ongoingCourse.count)
        
        //        fetctDataFromServer()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return (myCourseList.ongoingCourse.count == 0 && myCourseList.completedCourse.count == 0) ? 0 : myCourseList.completedCourse.count == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRect(x: tableView.frame.size.width,y: 0,width: tableView.frame.size.width,height: 0))
            
        }else {
            let view = UIView(frame: CGRect(x: 0,y: 0,width: 220,height: 30))
            let label = UILabel(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 110,y: 0,width: 200,height: 50))
            label.text = "COURSE COMPLETED"
            //            label.sizeToFit()
            //            label = UILabel(frame: CGRectMake((tableView.frame.size.width / 2) - label.frame.width/2 ,0,label.frame.width,50))
            label.textAlignment = .center
            label.textColor = DataUtils.colorWithHexString("707070")
            let checkedImageView = UIImageView(frame: CGRect(x: label.frame.origin.x - 25 ,y: 8,width: 30,height: 30))
            checkedImageView.image = UIImage(named: "tick.png")
            
            view.addSubview(checkedImageView)
            view.addSubview(label)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? myCourseList.ongoingCourse.count : myCourseList.completedCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == 0 ? "MyCourseTableCell" : "MyCourseTableCell1" , for: indexPath) as! MyCourseTableCell
        cell.superViewController = self
        let courseObj = indexPath.section == 0 ? myCourseList.ongoingCourse[indexPath.row] as! TECourseData : myCourseList.completedCourse[indexPath.row] as! TECourseData
        courseObj.section = indexPath.section
        cell.courseTitleLabel.text = courseObj.course_name + "-" + courseObj.name
        cell.courseTitleLabel.sizeToFit()
        cell.teacherNameLabelOutlet.text = String(format: "By : %@ (%@)", (courseObj.faculty[0] as! NSDictionary).value(forKey: "fname") as! String , courseObj.institute_name)
        cell.timeLabelOutlet.text = courseObj.course_duration
        cell.courseObject = courseObj
        cell.courseImageView.sd_setImage(with: URL(string: courseObj.logo), placeholderImage: UIImage())
        
        if indexPath.row == 0 {
            ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
                ModelManager.singleton.courseImage = image
            }) { (image) in
                ModelManager.singleton.courseImage = image
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        let courseObj = indexPath.section == 0 ? myCourseList.ongoingCourse[indexPath.row] as! TECourseData : myCourseList.completedCourse[indexPath.row] as! TECourseData
        ServerCommunication.singleton.imageFromServerURL(courseObj.banner_url, success: { (image) in
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCourseDetailViewController") as! MyCourseDetailViewController
            detailVC.selectedCourseObj = courseObj
            detailVC.isCourseCompleted = indexPath.section != 0
            ModelManager.singleton.courseImage = image
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }) { (image) in
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCourseDetailViewController") as! MyCourseDetailViewController
            detailVC.selectedCourseObj = courseObj
            detailVC.isCourseCompleted = indexPath.section != 0
            ModelManager.singleton.courseImage = image
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let courseObj = indexPath.section == 0 ? myCourseList.ongoingCourse[indexPath.row] as! TECourseData : myCourseList.completedCourse[indexPath.row] as! TECourseData
        
        let addedWidth:CGFloat = DataUtils.getDynamicHeightLabel(courseObj.course_name + "-" + courseObj.name, width: tableView.frame.size.width - 60, fontSize: 15)
        return 155+addedWidth
    }
}

class MyCourseTableCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var teacherNameLabelOutlet: UILabel!
    @IBOutlet weak var courseCollectionView: UICollectionView!
    var superViewController: UIViewController!
    var courseObject: TECourseData!
    
    
    //MARK:- UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseObject.section == 0 ? 6 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MyCourseCollecionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCourseCollecionCell",for:indexPath) as! MyCourseCollecionCell
        switch courseObject.section {
        case 0:
//            cell.logoSubView.layer.sublayers = nil
//            cell.logoSubView.hidden = true
//            cell.plusImage.hidden = true
            switch indexPath.row {
            case 0:
                cell.moduleNameLabel.text = String(format: "%d/%d Module Completed", courseObject.completed.intValue, courseObject.total_modules.intValue)
                drawSemiCircle(CGPoint(x: cell.logoSubView.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.logoSubView, completionPercentage: abs(courseObject.pending_percentage.doubleValue),courseObj: courseObject)
                cell.logoSubView.isHidden = false
                
                let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
                let partTwo = NSMutableAttributedString(string: String(format: "%.2f", abs(courseObject.pending_percentage.doubleValue)), attributes: [NSForegroundColorAttributeName: kOrangeColor])
                let partThree = NSMutableAttributedString(string: "%", attributes: [NSForegroundColorAttributeName: kOrangeColor])
                
                let partFour = NSMutableAttributedString(string: "Pending ", attributes: yourAttributes)
                
                let combination = NSMutableAttributedString()
                combination.append(partFour)
                combination.append(partTwo)
                combination.append(partThree)
                cell.statusLabel.attributedText = combination
                
                
            //                cell.statusLabel.text = String(format: "Pending %.2f", abs(courseObject.pending_percentage.doubleValue)) + "%"
            case 1:
                cell.moduleNameLabel.text = "Attendance"
                cell.statusLabel.text = String(format: "%.d", courseObject.attendance_percentage.intValue == 0 ? 0 : courseObject.attendance_percentage.intValue) + "%"
                cell.logoSubView.isHidden = false
                drawLineFromPoint(CGPoint(x: Double(cell.logoSubView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: cell.logoSubView , courseObj : courseObject)
            case 2:
                cell.moduleNameLabel.text = "Live Class"
                cell.plusImage.image = UIImage(named: "live_class1.PNG")
                cell.statusLabel.text = courseObject.live_class_details.count == 0 ? "No Live Class" : (courseObject.live_class_details[0] as AnyObject).value(forKey: "date") as! String + "\n" +  ((courseObject.live_class_details[0] as AnyObject).value(forKey: "time") as! String)
                cell.plusImage.isHidden = false
            case 3:
                cell.moduleNameLabel.text = "Assignments"
                cell.plusImage.image = UIImage(named: "Assignment1.png")
                cell.statusLabel.text = String(format: "%d", courseObject.assignment.intValue)
                cell.plusImage.isHidden = false
            case 4:
                cell.moduleNameLabel.text = "Assessments"
                cell.plusImage.image = UIImage(named: "assessment1.png")
                cell.statusLabel.text = String(format: "%d", courseObject.assessment.intValue)
                cell.plusImage.isHidden = false
            case 5:
                cell.moduleNameLabel.text = "Discussions"
                cell.plusImage.image = UIImage(named: "disscusstion.PNG")
                cell.statusLabel.text = String(format: "%d", courseObject.discussion.intValue)
                cell.plusImage.isHidden = false
            case 5:
                cell.moduleNameLabel.text = "Testimonials"
                cell.plusImage.setFAIconWithName(FAType.faDrupal, textColor: UIColor.black)
                cell.statusLabel.text = String(format: "%d", courseObject.testimonial.intValue)
                cell.plusImage.isHidden = false
            default:
                cell.moduleNameLabel.text = "Discussions"
                cell.statusLabel.text = String(format: "%d", courseObject.assignment.intValue)
            }
        case 1:
            cell.statusLabel.font = cell.statusLabel.font.withSize(36)
            switch indexPath.row {
            case 0:
                cell.moduleNameLabel.text = "Modules"
                cell.statusLabel.text = String(format: "%d", courseObject.total_modules.intValue)
            case 1:
                cell.moduleNameLabel.text = "Live Classes"
                cell.statusLabel.text = String(format: "%d", courseObject.live_class.intValue)
            case 2:
                cell.moduleNameLabel.text = "Batchmates"
                cell.statusLabel.text = String(format: "%d", courseObject.learner.intValue)
            case 3:
                cell.moduleNameLabel.text = "Testimonials"
                cell.statusLabel.text = String(format: "%d", courseObject.testimonial.intValue)
            default:
                cell.moduleNameLabel.text = "Discussions"
                cell.statusLabel.text = String(format: "%d", courseObject.assignment.intValue)
            }
        default:
            cell.moduleNameLabel.text = "Discussions"
            cell.statusLabel.text = String(format: "%d", courseObject.assignment.intValue)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCourseDetailViewController") as! MyCourseDetailViewController
        
        switch courseObject.section {
        case 0:
            switch indexPath.row {
            case 0:
                detailVC.selectedTabIndex = 0
            case 1:
                detailVC.selectedTabIndex = 2
            case 2:
                detailVC.selectedTabIndex = 1
            case 3:
                detailVC.selectedTabIndex = 3
            case 4:
                detailVC.selectedTabIndex = 4
            case 5:
                detailVC.selectedTabIndex = 5
            case 6:
                detailVC.selectedTabIndex = 7
            default:
                detailVC.selectedTabIndex = 0
            }
        case 1:
            switch indexPath.row {
            case 0:
                detailVC.selectedTabIndex = 0
            case 1:
                detailVC.selectedTabIndex = 1
            case 2:
                detailVC.selectedTabIndex = 6
            case 3:
                detailVC.selectedTabIndex = 7
            default:
                detailVC.selectedTabIndex = 0
            }
        default:
            detailVC.selectedTabIndex = 0
        }
        
        ServerCommunication.singleton.imageFromServerURL(courseObject.banner_url, success: { (image) in
            detailVC.selectedCourseObj = self.courseObject
            ModelManager.singleton.courseImage = image
            self.superViewController.navigationController?.pushViewController(detailVC, animated: true)
        }) { (image) in
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCourseDetailViewController") as! MyCourseDetailViewController
            detailVC.selectedCourseObj = self.courseObject
            ModelManager.singleton.courseImage = image
            self.superViewController.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3.2, height: 100)
    }
    
    func drawLineFromPoint(_ end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, courseObj : TECourseData) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 20.0))
        path.addLine(to: CGPoint(x: Double(view.frame.size.width ) * (courseObj.attendance_percentage.doubleValue/100), y: 20.0))
//
//        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 10.0
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 20.0))
        path1.addLine(to: CGPoint(x: view.frame.size.width, y: 20.0))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.lineWidth = 10.0
//        shapeLayer1.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer)
    }
    
    func drawSemiCircle(_ end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, completionPercentage : Double, courseObj : TECourseData) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height), radius: CGFloat(25), startAngle: CGFloat(M_PI), endAngle:CGFloat(0), clockwise: true)
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
        shapeLayer1.lineWidth = 10
        shapeLayer1.addSublayer(shapeLayer)
        
        let angle = completionPercentage * 1.8
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height), radius: CGFloat(25), startAngle: CGFloat(M_PI), endAngle:CGFloat(((180 + angle)/180)*M_PI), clockwise: true)
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
        shapeLayer3.lineWidth = 10
        shapeLayer3.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer3)
        
        let angle1 = abs(courseObject.completion_percentage.doubleValue) * 1.8
        let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height), radius: CGFloat(25), startAngle: CGFloat(M_PI), endAngle:CGFloat(((180 + angle1)/180)*M_PI), clockwise: true)
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
        shapeLayer5.lineWidth = 10
        shapeLayer5.addSublayer(shapeLayer4)
        view.layer.addSublayer(shapeLayer5)
    }
}

class MyCourseCollecionCell : UICollectionViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var logoSubView: UIView!
    
    
}
