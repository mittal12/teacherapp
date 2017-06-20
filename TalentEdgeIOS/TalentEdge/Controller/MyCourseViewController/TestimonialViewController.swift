//
//  TestimonialViewController.swift
//  TalentEdge
//
//

import UIKit

class TestimonialViewController: UIViewController {

    @IBOutlet weak var testimonialTableView: UITableView!

    var testimonialArray : [TETestimonialData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
        testimonialArray = [TETestimonialData]()
        testimonialTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        testimonialTableView.showsVerticalScrollIndicator = false
        testimonialTableView.tableFooterView = UIView()

//        fetchDataFromServer()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func fetchDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "batch_id=%d",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_TESTIMONIAL_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.testimonialArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TETestimonialData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TETestimonialData]
            self.testimonialTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    @IBAction func addTestimonialButtonAction (_ sender : UIButton) {
    
//        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddTestimonialViewController") as! AddTestimonialViewController
//        detailVC.selectedCourseObj = selectedCourseObj
//        self.presentViewController(detailVC, animated: true) {}

    
    }
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testimonialArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestimonialTableCell", for: indexPath) as! TestimonialTableCell
        cell.titleLabelOutlet.text = testimonialArray[indexPath.row].created_by
        cell.descTextViewOutlet.text = testimonialArray[indexPath.row].desc
        cell.publisherLabelOutlet.text = testimonialArray[indexPath.row].created
//        cell.playVideoButtonOutlet.hidden = testimonialArray[indexPath.row].uploads == "<null>"
        cell.courseImageView.sd_setImage(with: URL(string: testimonialArray[indexPath.row].pic), placeholderImage: UIImage())
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestimonialDetailViewController") as! TestimonialDetailViewController
        detailVC.testimonialData = testimonialArray[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(testimonialArray[indexPath.row].desc, width: tableView.frame.size.width - 48)
        return 152+addedWidth
    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath)
    {
        
        if editingStyle == .delete
        {
            
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "batch_id=%d",testimonialArray[indexPath.row].id.intValue)
            ServerCommunication.singleton.requestWithPost(API_DELETE_TESTIMONIAL ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                self.fetchDataFromServer()
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        }
    }
    

    
    
//    @IBAction func addTestimonialButtonAction(sender: AnyObject) {
  //      self.view.endEditing(true)
////        if emailTextField.text!.characters.count == 0 {
////            emailTextField.triggerShakeAnimation()
////            return
////        }
//        let headers : [String:String] = [
//            "devicetype": "IOS",
//            "deviceid": TechUserDefault.singleton.deviceToken() == nil ? "ferhjfdgka":TechUserDefault.singleton.deviceToken()!,
//            "username": self.emailTextField.text!,
//            ]
//        let str = String(format: "email=%@",emailTextField.text!)
//        ServerCommunication.singleton.requestWithPost(API_FORGOT_PASSWORD ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
//            print(successResponseDict)
//            ////            let loginData: TELoginData? = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TELoginData"), jsonData: successResponseDict) as? TELoginData
//            ////            ModelManager.singleton.loginData = loginData
//            //            let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SSASideMenu") as! SSASideMenu
//            //            APPDELEGATE.window?.rootViewController = sideMenuController
//            //            APPDELEGATE.window?.makeKeyAndVisible()
//            self.navigationController?.popViewControllerAnimated(true)
//        }) { (errorResponseDict) -> Void in
//            TechUserDefault.singleton.removeUserCredential()
//            DataUtils.showAlertMessage(errorResponseDict.valueForKey("errDesc") as! String, withTitle: "", delegate: self)
//        }
 //   }

    
}

class TestimonialTableCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var publisherLabelOutlet: UILabel!
    @IBOutlet weak var titleLabelOutlet: UILabel!

    @IBOutlet weak var playVideoButtonOutlet: UIButton!
    @IBOutlet weak var descTextViewOutlet: UITextView!
    
}


