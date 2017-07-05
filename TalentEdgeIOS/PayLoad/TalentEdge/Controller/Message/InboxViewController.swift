//
//  InboxViewController.swift
//  TalentEdge
//
//

import UIKit

class InboxViewController: UIViewController {
    
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var batchSelectButtonSmall: UIButton!
    @IBOutlet weak var batchSelectButtonLarge: UIButton!
    @IBOutlet weak var onlyDoubtButtonOutlet: UIButton!
    @IBOutlet weak var floatingButtonOutlet: UIButton!
    var isDoubt : Bool = false
    var inboxArray = [TEMessaageData]()
    
    var isInbox : Bool!
    
    var fetchIndex = 1
    
    var selectedBatch : TEBatchData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
        inboxArray = [TEMessaageData]()
        //        inboxArray.append("dsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkl")
        //        inboxArray.append("A")
        //        inboxArray.append("dsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkldsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkl")
        //        inboxArray.append("dsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkldsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkldsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkldsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkl")
        //        inboxArray.append("dsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkldsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkldsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkldsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkldsfkhdklsfadjkslfhfghjbgklvngvdfjkhndfvkdfvdfghjdfvhdfgvkadfjvhadfhfadsfvhndf.vdfsjkl")
        //        inboxArray.append("A")
        loadUI()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func loadUI () {
        batchSelectButtonLarge.isHidden = isInbox
        floatingButtonOutlet.isHidden = !isInbox
        floatingButtonOutlet.setFAIcon(FAType.faPencil, forState: UIControlState())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedBatch == nil {
            selectedBatch = TEBatchData()
            selectedBatch.name = "All Batches"
            fetchIndex = 1
        }
        batchSelectButtonLarge.setTitle(selectedBatch.name, for: UIControlState())
        batchSelectButtonSmall.setTitle(selectedBatch.name, for: UIControlState())
        fetchDataFromServer()
    }
    
    fileprivate func fetchDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str1 = selectedBatch.id.intValue != 0 ? String(format: "batch_id=%d&",selectedBatch.id.intValue) : ""
        let str2 = isDoubt == true ? String(format: "is_doubt=%d&",isDoubt == true ? 1 : 0) : ""
//        let str3 = String(format: "limit=%d&",15)
        let str4 = String(format: "page=%d&",fetchIndex)
        let str5 = String(format: "type=%@",isInbox == true ? "inbox" : "sent")
        
        ServerCommunication.singleton.requestWithPost(API_GET_MESSAGE_LIST ,headerDict: headers, postString: str1 + str2 + str4 + str5, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.inboxArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEMessaageData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEMessaageData]
            self.inboxTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 101:
            let vc : BatchSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BatchSelectionViewController") as! BatchSelectionViewController
            vc.selectedBatch = selectedBatch
            self.present(vc, animated: true, completion: nil)
        case 102:
            isDoubt = !isDoubt
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str1 = selectedBatch.id.intValue != 0 ? String(format: "batch_id=%d&",selectedBatch.id.intValue) : ""
            let str2 = isDoubt == true ? String(format: "is_doubt=%d&",isDoubt == true ? 1 : 0) : ""
            //        let str3 = String(format: "limit=%d&",15)
            let str4 = String(format: "page=%d&",fetchIndex)
            let str5 = String(format: "type=%@",isInbox == true ? "inbox" : "sent")
            
            ServerCommunication.singleton.requestWithPost(API_GET_MESSAGE_LIST ,headerDict: headers, postString: str1 + str2 + str4 + str5, success: { (successResponseDict) -> Void in                print(successResponseDict)
                self.inboxArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEMessaageData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEMessaageData]
                self.inboxTableView.reloadData()
                
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        case 103:
            let vc : BatchSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BatchSelectionViewController") as! BatchSelectionViewController
            vc.selectedBatch = selectedBatch
            self.present(vc, animated: true, completion: nil)
        case 104:
            
            let newMessageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewMessageViewController") as! NewMessageViewController
            self.navigationController?.pushViewController(newMessageVC, animated: true)
            
        default:
            print("default")
        }
    }
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxListTableCell", for: indexPath) as! InboxListTableCell
        cell.nameLabel.text = inboxArray[indexPath.row].from_name
        cell.messageLabel.text = inboxArray[indexPath.row].subject + ":" + inboxArray[indexPath.row].message
        cell.timeLabel.text = inboxArray[indexPath.row].created
        cell.userImageView.image = UIImage(named: "default_user.PNG")
        if inboxArray.count - 1 == indexPath.row  && inboxArray.count > 10{
            fetchIndex = fetchIndex + 1
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str1 = selectedBatch.id.intValue != 0 ? String(format: "batch_id=%d&",selectedBatch.id.intValue) : ""
            let str2 = isDoubt == true ? String(format: "is_doubt=%d&",isDoubt == true ? 1 : 0) : ""
            //        let str3 = String(format: "limit=%d&",15)
            let str4 = String(format: "page=%d&",fetchIndex)
            let str5 = String(format: "type=%@",isInbox == true ? "inbox" : "sent")
            
            ServerCommunication.singleton.requestWithPost(API_GET_MESSAGE_LIST ,headerDict: headers, postString: str1 + str2 + str4 + str5, success: { (successResponseDict) -> Void in                print(successResponseDict)
                let inboxArray : [TEMessaageData] = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEMessaageData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEMessaageData]
                self.inboxArray.append(contentsOf: inboxArray)
                self.inboxTableView.reloadData()
                
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        //        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InboxDetailViewController") as! InboxDetailViewController
        //        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        let addedWidth:CGFloat = DataUtils.getDynamicHeight(inboxArray[indexPath.row], width: tableView.frame.size.width - 48)
    //        return 80.0+addedWidth
    //    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath)
    {
        
        if editingStyle == .delete
        {
            
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "message_id=[%d]&type=%@",inboxArray[indexPath.row].id.intValue,isInbox == true ? "inbox" : "sent")
            ServerCommunication.singleton.requestWithPost(API_DELETE_MESSAGE ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                self.fetchDataFromServer()
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        }
    }
    
    
    
}


class InboxListTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
}
