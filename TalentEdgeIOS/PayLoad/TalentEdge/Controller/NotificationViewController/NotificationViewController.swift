//
//  NotificationViewController.swift
//  TalentEdge
//
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var notificationArray = [TENotificationData]()
    
    var fetchIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
         fetchDataFromServer()
//        DataUtils.addBackArrow(self.navigationItem, withTitle: "Notifications", target: self)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        if self.navigationController?.viewControllers.count == 1 {
            self.sideMenuViewController?._presentLeftMenuViewController()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func fetchDataFromServer () {
        
        if ModelManager.singleton.selectedCourseObj == nil {
            DataUtils.sendToLoginScreenWithAlert(self)
            return
        }
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "start=%d&limit=%d",fetchIndex,30)
        ServerCommunication.singleton.requestWithPost(API_GET_NOTIFICATION_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.notificationArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TENotificationData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TENotificationData]
            self.notificationTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationListTableCell", for: indexPath) as! NotificationListTableCell
        cell.descTextViewOutlet.text = notificationArray[indexPath.row].web_message
        cell.commentTimeLabel.text = notificationArray[indexPath.row].date_created
        cell.descTextViewOutlet.textColor = notificationArray[indexPath.row].is_read.boolValue ? UIColor.lightGray : UIColor.darkGray
        cell.descTextViewOutlet.font = notificationArray[indexPath.row].is_read.boolValue ? UIFont.systemFont(ofSize: 12) : UIFont.boldSystemFont(ofSize: 12)
        if indexPath.row == notificationArray.count - 1 && notificationArray.count > 10 {
            fetchIndex = fetchIndex + 1
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "start=%d&limit=%d",fetchIndex,30)
            ServerCommunication.singleton.requestWithPost(API_GET_NOTIFICATION_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                let notificationArray : [TENotificationData] = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TENotificationData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TENotificationData]
                self.notificationArray.append(contentsOf: notificationArray)
                self.notificationTableView.reloadData()
                
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
            tableView.reloadData()
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "notificationId=%d",notificationArray[indexPath.row].id.intValue)
        ServerCommunication.singleton.requestWithPost(API_VIEW_NOTIFICATION ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationDetailViewController") as! NotificationDetailViewController
            detailVC.notificationObj = self.notificationArray[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(notificationArray[indexPath.row].web_message, width: tableView.frame.size.width - 48)
        return 80.0+addedWidth
    }
    
    
}


class NotificationListTableCell: UITableViewCell {
    
    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var descTextViewOutlet: UITextView!
    
}

//
//[02/03/17, 6:20:44 PM] Sourav Mishra : CGPoint lastContentOffset;
//[02/03/17, 6:20:55 PM] Sourav Mishra : BOOL flag;
//BOOL isPageRefreshing;
//int page;
//[02/03/17, 6:21:04 PM] Sourav Mishra : lastContentOffset = CGPointMake(0.0, 0.0);
//[02/03/17, 6:21:14 PM] Sourav Mishra : page=1;
//[02/03/17, 6:21:30 PM] Sourav Mishra : -(void) scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint currentOffset = scrollView.contentOffset;
//    if (currentOffset.y > lastContentOffset.y)
//    {
//        flag=true;
//        // Downward
//    }
//    else
//    {
//        flag=false;
//        // Upward
//    }
//    lastContentOffset = currentOffset;
//    
//    if((self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))&& isNextPage)
//    {
//        if(isPageRefreshing==NO){
//            isPageRefreshing=YES;
//            [self makeRequest:page++];
//            NSLog(@"called %d",page);
//        }
//    }
//    
//}
//
//
//
//-(void)makeRequest:(int)currentPage{
//    
//    [ConnectionManager shareInstance].delegate=self;
//    [Constant showLoader];
//    
//    NSDictionary *data=[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"job_type",@"10",@"per_page",[NSString stringWithFormat:@"%d",currentPage],@"page",[[OnlineBO shareInstance].user_type isEqual:@"2"]?@"2":@"4",@"status",[OnlineBO shareInstance].login_id,@"user_id", nil];
//    
//    [[ConnectionManager shareInstance] sendRequestWithURL:[[OnlineBO shareInstance].user_type isEqual:@"2"]? OWNER_JOB_REQUEST:DRIVER_JOB_REQUEST andPostBody:(NSString *)data withTag:TASK_HISTORY_JOB_LIST];
//    
//}
