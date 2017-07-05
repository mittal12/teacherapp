//
//  LiveClassesViewController.swift
//  TalentEdge
//
//

import UIKit

class LiveClassesViewController: UIViewController {
    
    @IBOutlet weak var liveClassTableView: UITableView!
    var liveClassArray : [TELiveData]!
    
    var isCameFromDrawer : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
        liveClassArray = [TELiveData]()
        liveClassTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        liveClassTableView.showsVerticalScrollIndicator = false
        liveClassTableView.tableFooterView = UIView()
        
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
        let str = String(format: "batch_id=%d",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_LIVE_CLASS_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.liveClassArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TELiveData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TELiveData]
            self.liveClassTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    //Just ask him that means there will be no scheduled and join text will be shown on the place of Concluded or View Recorded
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveClassArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveClassesTableCell", for: indexPath) as! LiveClassesTableCell
        cell.courseImageView.image = UIImage(named: "live_class1.PNG")
        cell.courseTitleLabel.text = liveClassArray[indexPath.row].title
        cell.courseSubDetailLabel.text = liveClassArray[indexPath.row].module_name
        
        let partOne = NSMutableAttributedString(string: liveClassArray[indexPath.row].published_by_label)
        let partTwo = NSMutableAttributedString(string: liveClassArray[indexPath.row].published_by_value, attributes: yourAttributes)
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(NSAttributedString(string: " : "))
        combination.append(partTwo)
        cell.teacherNameLabelOutlet.attributedText = combination
        
        let part1 = NSMutableAttributedString(string: liveClassArray[indexPath.row].date_value)
        let part2 = NSMutableAttributedString(string: liveClassArray[indexPath.row].content_duration_formated, attributes: yourAttributes)
        let combination1 = NSMutableAttributedString()
        combination1.append(NSAttributedString(string: "Session Date : "))
        combination1.append(part1)
        combination1.append(NSAttributedString(string: " | Duration : "))
        combination1.append(part2)
        cell.timeLabelOutlet.attributedText = combination1
        
        cell.descriptionTextView.text = liveClassArray[indexPath.row].desc
        cell.concludedButtonOutlet.setTitle(liveClassArray[indexPath.row].action == "Join" ? "Scheduled  " : liveClassArray[indexPath.row].action == "Scheduled" ?  "Scheduled  ": "Concluded  ", for: UIControlState())
        cell.viewRecordedButtonOutlet.setTitle("  " + liveClassArray[indexPath.row].action + "  ", for: UIControlState())
        cell.viewRecordedButtonOutlet.tag = indexPath.row
        //        cell.viewRecordedButtonOutlet.accessibilityIdentifier = cel
        cell.viewRecordedButtonOutlet.isHidden = !liveClassArray[indexPath.row].allow_view.boolValue
        cell.viewRecordedButtonOutlet.addTarget(self, action: #selector(viewRecordedButtonAction(_:)), for: .touchUpInside)
        cell.viewRecordedButtonOutlet.sizeToFit()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        //        if liveClassArray[indexPath.row].allow_view.boolValue {
        //            let headers : [String:String] = [
        //                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.integerValue),
        //                "token": ModelManager.singleton.loginData.token,
        //                "deviceType": "IOS"
        //            ]
        //            let str = String(format: "batch_id=%d&content_id=%d",self.selectedCourseObj.id.integerValue,liveClassArray[indexPath.row].id.integerValue)
        //            ServerCommunication.singleton.requestWithPost(API_JOIN_LIVE_CLASS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
        //                print(successResponseDict)
        //
        //                if let url = NSURL(string: (successResponseDict.valueForKeyPath("resultData.URL") as? String)!) {
        //                    UIApplication.sharedApplication().openURL(url, options: [:], completionHandler: nil)
        //                }
        //            }) { (errorResponseDict) -> Void in
        //                DataUtils.showAlertMessage(errorResponseDict.valueForKey("errDesc") as! String, withTitle: "", delegate: self)
        //            }
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(liveClassArray[indexPath.row].desc, width: tableView.frame.size.width - 48)
        return 145.0+addedWidth
    }
    
    func viewRecordedButtonAction(_ sender : UIButton) {
        print(sender.titleLabel?.text)
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "batch_id=%d&content_id=%d",self.selectedCourseObj.id.intValue,liveClassArray[sender.tag].id.intValue)
        ServerCommunication.singleton.requestWithPost(API_JOIN_LIVE_CLASS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            if ((sender.titleLabel?.text?.contains("Join")) == true) {
                if let url = URL(string: ((successResponseDict.value(forKeyPath: "resultData.URL") as? String)?
                    .replacingOccurrences(of: "http", with: "connectpro"))!) {
                    let isInstalled = UIApplication.shared.canOpenURL(url)
                    if isInstalled {
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        print("Installed")
                        
                    }else{
                        let url1  = URL(string: "https://itunes.apple.com/us/app/adobe-connect/id430437503?mt=8")
                        if UIApplication.shared.canOpenURL(url1!) == true  {
                            UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
                        }
                    }
                }
            }else if (((sender.titleLabel?.text?.contains("View Recorded")) == true) || ((sender.titleLabel?.text?.contains("Concluded")) == true)){
                if let url = URL(string: ((successResponseDict.value(forKeyPath: "resultData.URL") as? String)?
                    .replacingOccurrences(of: "http", with: "puffin"))!) {
                    let isInstalled = UIApplication.shared.canOpenURL(url)
                    if isInstalled {
                        
                        let tempURL = URL(string: "connectpro://www.google.com")
                        let isInstalled1 = UIApplication.shared.canOpenURL(tempURL!)
                        if !isInstalled1 {
                            let url1  = URL(string: "https://itunes.apple.com/us/app/adobe-connect/id430437503?mt=8")
                            if UIApplication.shared.canOpenURL(url1!) == true  {
                                UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
                            }
                        }else{
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            print("Installed")
                        }
                    }else{
                        let url1  = URL(string: "https://itunes.apple.com/us/app/puffin-web-browser-free/id472937654?mt=8")
                        if UIApplication.shared.canOpenURL(url1!) == true  {
                            UIApplication.shared.open(url1!, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
}

class LiveClassesTableCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var concludedButtonOutlet: UIButton!
    @IBOutlet weak var courseSubDetailLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var teacherNameLabelOutlet: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var viewRecordedButtonOutlet: UIButton!
    
    
}
