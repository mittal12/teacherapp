//
//  DiscussionViewController.swift
//  TalentEdge
//
//

import UIKit

class DiscussionViewController: UIViewController {
    
    @IBOutlet weak var discussionTableView: UITableView!
    @IBOutlet weak var commentTextViewOutlet: UITextView!
    @IBOutlet weak var replyButtonOutlet: UIButton!

    var discussionArray : [TEDiscussionData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
        discussionArray = [TEDiscussionData]()
        //        discussionArray.append("A")
        //        discussionArray.append("A")
        //        discussionArray.append("A")
        //        discussionArray.append("A")
        //        discussionArray.append("A")
        //        discussionArray.append("A")
//        fetctDataFromServer()
        discussionTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        discussionTableView.showsVerticalScrollIndicator = false
        discussionTableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetctDataFromServer()
    }
    
    fileprivate func fetctDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "batch_id=%d",self.selectedCourseObj.id.intValue)//ModelManager.singleton.loginData.resultData.counsellor.batch_id.integerValue)
        ServerCommunication.singleton.requestWithPost(API_GET_DISCUSSION_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.discussionArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEDiscussionData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEDiscussionData]
            self.discussionTableView.reloadData()
            
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
        return discussionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionTableCell", for: indexPath) as! DiscussionTableCell
        let discsussionObject = discussionArray[indexPath.row]
        cell.courseTitleLabel.text = discsussionObject.title
        cell.descTextViewOutlet.text = discsussionObject.desc
        cell.courseSubDetailLabel.text = discsussionObject.module_name
        cell.timeLabelOutlet.text = discsussionObject.end_date_label == "" ? discsussionObject.start_date_label + " : " + discsussionObject.start_date_value : discsussionObject.start_date_label + " : " + discsussionObject.start_date_value + " | " + discsussionObject.end_date_value
        cell.publisherLabelOutlet.text = discsussionObject.published_by_label + " - " + discsussionObject.published_by_value + " (" + discsussionObject.user_role + ") "
        cell.replyButtonOutlet.isHidden = discsussionObject.end_date_value != ""
        cell.courseImageView.image = UIImage(named: "disscusstion.PNG")
        cell.commentsCountLabel.setTitle(discsussionObject.comments_count, for: UIControlState())
        cell.replyButtonOutlet.isHidden = !discsussionObject.allow_reply.boolValue
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",discussionArray[indexPath.row].id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_DISCUSSION_COMMENT_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            let discussionDetailData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEDiscussionCommentData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEDiscussionCommentData
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DiscussionListViewController") as! DiscussionListViewController
            detailVC.discussionDetailData = discussionDetailData
            detailVC.mainDiscussionObject = self.discussionArray[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let attenceObj:TEDiscussionData = discussionArray[indexPath.row] 
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(attenceObj.desc, width: tableView.frame.size.width - 70)
        return 145.0+addedWidth
    }
    
    
}

class DiscussionTableCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseSubDetailLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var publisherLabelOutlet: UILabel!
    
    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var descTextViewOutlet: UITextView!
    @IBOutlet weak var replyButtonOutlet: UIButton!
    @IBOutlet weak var commentsCountLabel: UIButton!
    
}

class DiscussionReplyTableCell: UITableViewCell {
    
    @IBOutlet weak var commentTextViewOutlet: UITextView!
    @IBOutlet weak var replyButtonOutlet: UIButton!
}



