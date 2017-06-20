//
//  DashboardViewController.swift
//  TalentEdge
//
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var buttonView1: UIView!
    @IBOutlet weak var buttonView2: UIView!
    @IBOutlet weak var buttonView3: UIView!
    @IBOutlet weak var sideDrawerButton: UIButton!
    @IBOutlet weak var notificationTitleCountLabel: UILabel!
    
    @IBOutlet weak var mainSubView: UIView!
    var myCourseList = TECourseList()

    var isTeacher = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DataUtils.addTitleToNavigation(self.navigationItem, withTitle: "Dashboard")
        loadUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func rightBarButtonAction (_ _sender : UIButton) {
        let notificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        fetctDataFromServer()
    }
    
    fileprivate func loadUI() {
        sideDrawerButton.setFAIcon(FAType.faBars, forState: UIControlState())
        sideDrawerButton.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: .touchUpInside)
        button1.setTitleColor(kBarButtonBottomSelectedColor, for: UIControlState())
        buttonView1.backgroundColor = kBarButtonBottomSelectedColor
        
           }
    
    fileprivate func fetctDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType" : "IOS"
        ]
        ServerCommunication.singleton.requestWithPost(API_GET_COURSES_LIST ,headerDict: headers, postString: " ", success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.myCourseList =  JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TECourseList"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TECourseList
            ModelManager.singleton.selectedCourseObj = self.myCourseList.ongoingCourse.count == 0 ? self.myCourseList.completedCourse.count == 0 ? nil : self.myCourseList.completedCourse.object(at: 0) as! TECourseData : self.myCourseList.ongoingCourse.object(at: 0) as! TECourseData
            
            var array = [TEBatchData]()
            
            for i in 0..<self.myCourseList.ongoingCourse.count {
                let courseObj = self.myCourseList.ongoingCourse[i] as! TECourseData
                let batchData = TEBatchData()
                batchData.id = courseObj.id
                batchData.name = courseObj.name
                array.append(batchData)
            }
            
            for i in 0..<self.myCourseList.completedCourse.count {
                let courseObj = self.myCourseList.completedCourse[i] as! TECourseData
                let batchData = TEBatchData()
                batchData.id = courseObj.id
                batchData.name = courseObj.name
                array.append(batchData)
            }
            
        
            
            for i in 0..<self.myCourseList.facultyOngoingCourse.count
            {
                let FacultyCourseObj =  self.myCourseList.facultyOngoingCourse[i] as! TECourseData
                let batchData = TEBatchData()
                batchData.id = FacultyCourseObj.id
                batchData.name = FacultyCourseObj.name
                array.append(batchData)
                self.isTeacher = true
                
            }
            
            for i in 0..<self.myCourseList.facultyCompletedCourse.count
            {
                let FacultyCourseObj =  self.myCourseList.facultyCompletedCourse[i] as! TECourseData
                let batchData = TEBatchData()
                batchData.id = FacultyCourseObj.id
                batchData.name = FacultyCourseObj.name
                array.append(batchData)
                self.isTeacher = true
            }
            

            
            
            
            ModelManager.singleton.batchList = array
            self.notificationTitleCountLabel.text = String(format : "%d",self.myCourseList.unread_notification.intValue)
//            let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCourseViewController") as! MyCourseViewController
//            featuredVC.myCourseList = self.myCourseList
//
//            //        featuredVC.view.layer.addAnimation(DataUtils.getPushAnimation(), forKey: nil)
//            featuredVC.view.frame = self.mainSubView.bounds
//            featuredVC.view.tag = 9998
//            self.addChildViewController(featuredVC)
//            self.mainSubView.addSubview(featuredVC.view)
            
            
            if(self.isTeacher == false){
                let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCourseViewController") as! MyCourseViewController
                featuredVC.myCourseList = self.myCourseList
                
                //        featuredVC.view.layer.addAnimation(DataUtils.getPushAnimation(), forKey: nil)
                featuredVC.view.frame = self.mainSubView.bounds
                featuredVC.view.tag = 9998
                self.addChildViewController(featuredVC)
                self.mainSubView.addSubview(featuredVC.view)
            }
                
            else
                
            {
                let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TDashBoardViewController") as! TDashBoardViewController
                featuredVC.myCourseList = self.myCourseList
                //        featuredVC.view.layer.addAnimation(DataUtils.getPushAnimation(), forKey: nil)
                
                featuredVC.view.frame = self.mainSubView.bounds
                featuredVC.view.tag = 9999
                self.addChildViewController(featuredVC)
                self.mainSubView.addSubview(featuredVC.view)
            }
            


        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func barButtonAction(_ sender: AnyObject) {
        buttonView1.backgroundColor = kBarButtonBottomDefaultColor
        buttonView2.backgroundColor = kBarButtonBottomDefaultColor
        buttonView3.backgroundColor = kBarButtonBottomDefaultColor
        
        button1.setTitleColor(kBarButtonDefaultTextColor, for: UIControlState())
        button2.setTitleColor(kBarButtonDefaultTextColor, for: UIControlState())
        button3.setTitleColor(kBarButtonDefaultTextColor, for: UIControlState())
        
        self.mainSubView.removeAllSubviews()
        
        switch sender.tag {
        case 101:
            
            buttonView1.backgroundColor = kBarButtonBottomSelectedColor
            button1.setTitleColor(kBarButtonBottomSelectedColor, for: UIControlState())
            let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCourseViewController") as! MyCourseViewController
            featuredVC.view.layer.add(DataUtils.getPushAnimation(), forKey: nil)
            featuredVC.myCourseList = self.myCourseList
            featuredVC.view.frame = mainSubView.bounds
            featuredVC.view.tag = 9998
            self.addChildViewController(featuredVC)
            self.mainSubView.addSubview(featuredVC.view)
            
        case 102:
            buttonView2.backgroundColor = kBarButtonBottomSelectedColor
            button2.setTitleColor(kBarButtonBottomSelectedColor, for: UIControlState())
            let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeaturedCoursesViewController") as! FeaturedCoursesViewController
            featuredVC.view.layer.add(DataUtils.getPushAnimation(), forKey: nil)
            featuredVC.view.frame = mainSubView.bounds
            featuredVC.view.tag = 9998
            self.addChildViewController(featuredVC)
            self.mainSubView.addSubview(featuredVC.view)
            
        case 103:
            buttonView3.backgroundColor = kBarButtonBottomSelectedColor
            button3.setTitleColor(kBarButtonBottomSelectedColor, for: UIControlState())
            let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferViewController") as! ReferViewController
            featuredVC.view.layer.add(DataUtils.getPushAnimation(), forKey: nil)
            featuredVC.view.frame = mainSubView.bounds
            featuredVC.view.tag = 9998
            self.addChildViewController(featuredVC)
            self.mainSubView.addSubview(featuredVC.view)
            
        default:
            buttonView1.backgroundColor = kBarButtonBottomSelectedColor
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
