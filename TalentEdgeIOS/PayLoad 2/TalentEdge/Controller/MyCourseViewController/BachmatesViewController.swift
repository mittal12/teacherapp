//
//  BachmatesViewController.swift
//  TalentEdge
//
//

import UIKit

class BachmatesViewController: UIViewController {

    @IBOutlet weak var batchmateTableView: UITableView!
    
    var bachmateData = [TEBatchmateListObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
        batchmateTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        batchmateTableView.showsVerticalScrollIndicator = false
        batchmateTableView.tableFooterView = UIView()

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
        let str = String(format: "batch_id=%d&",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_STUDENT_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.bachmateData = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEBatchmateListObject"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEBatchmateListObject]
                
//                JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEBatchmateData"), jsonData: successResponseDict.valueForKey("resultData") as! NSDictionary) as! TEBatchmateData
            self.batchmateTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }

    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bachmateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BatchmateTableCell", for: indexPath) as! BatchmateTableCell
        cell.userImageView.sd_setImage(with: URL(string: bachmateData[indexPath.row].image))
        cell.userNameLabel.text = bachmateData[indexPath.row].name
        cell.sendMsgButton.isHidden = bachmateData[indexPath.row].id.intValue == ModelManager.singleton.loginData.resultData.user.userId.intValue
        cell.lastSeenLabel.text = "Last Active : " + bachmateData[indexPath.row].last_active
        cell.userAddressLabel.text = bachmateData[indexPath.row].id.intValue == ModelManager.singleton.loginData.resultData.user.userId.intValue ? "Yourself" : bachmateData[indexPath.row].city
//        cell.userAddressLabel.sizeToFit()
        cell.sendMsgButton.tag = indexPath.row
        cell.sendMsgButton.addTarget(self, action: #selector(messageButtonAction(_:)), for: .touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func messageButtonAction (_ sender : UIButton) {
        
        let newMessageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SeendMessageViewController") as! SeendMessageViewController
        let obj : TEStudentData = TEStudentData()
        obj.id = bachmateData[sender.tag].id
        obj.name = bachmateData[sender.tag].name
        newMessageVC.selectedRecipientArray = [obj]

        self.navigationController?.pushViewController(newMessageVC, animated: true)
    }
    
}

class BatchmateTableCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var sendMsgButton: UIButton!
    
}


