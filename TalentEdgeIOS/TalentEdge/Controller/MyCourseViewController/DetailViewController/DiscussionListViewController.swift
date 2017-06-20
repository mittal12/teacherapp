//
//  DiscussionListViewController.swift
//  TalentEdge
//
//

import UIKit

class DiscussionListViewController: UIViewController {
    
    @IBOutlet weak var discussionTableView: UITableView!
    @IBOutlet weak var commentTextViewOutlet: UITextView!
    @IBOutlet weak var commentSubView: UIView!
    
    @IBOutlet weak var replyButtonOutlet: UIButton!
    @IBOutlet weak var commentTableViewBottomConstraint: NSLayoutConstraint!
    var discussionDetailData = TEDiscussionCommentData()
    var mainDiscussionObject : TEDiscussionData!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    var moduleData : TEModuleDetailData!

    override func viewDidLoad() {
        super.viewDidLoad()
//        DataUtils.addBackArrow(self.navigationItem, withTitle: "Discussion", target: self)
//        fetchDataFromServer()
        replyButtonOutlet.setFAIcon(FAType.faPaperPlaneO, forState: UIControlState())
        subNavTitleLabel.text = moduleData == nil ? self.mainDiscussionObject.module_name : self.moduleData.module_name

//        commentSubView.hidden = !mainDiscussionObject.allow_reply.boolValue
//        commentTableViewBottomConstraint.constant = commentSubView.hidden ? 0.0 : commentTableViewBottomConstraint.constant
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func fetchDataFromServer() {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",mainDiscussionObject.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_DISCUSSION_COMMENT_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.discussionDetailData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEDiscussionCommentData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEDiscussionCommentData
            self.discussionTableView.reloadData()
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    // MARK: - UITextView Delegate Methads.
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        UIView.transition(with: self.view, duration: 0.3, options: .curveEaseIn, animations: {
            UIView.beginAnimations( "animateView", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            self.commentTableViewBottomConstraint.constant = self.commentTableViewBottomConstraint.constant + 216
            }, completion: { (true) in
                UIView.commitAnimations()
        })
        animateViewMoving(true, moveValue: 200)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        UIView.transition(with: self.view, duration: 0.3, options: .curveEaseIn, animations: {
            UIView.beginAnimations( "animateView", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            self.commentTableViewBottomConstraint.constant = self.commentTableViewBottomConstraint.constant - 216
            }, completion: { (true) in
                UIView.commitAnimations()
        })
        animateViewMoving(false, moveValue: 200)
        return true
    }
    
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussionDetailData.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionListTableCell", for: indexPath) as! DiscussionListTableCell
        let commentObj:TEComment = discussionDetailData.comments[indexPath.row] as! TEComment
        cell.userImageView.sd_setImage(with: URL(string: commentObj.pic), placeholderImage: UIImage())
        cell.descTextViewOutlet.text = commentObj.comment
        cell.commenterNameLabel.text = commentObj.created_by_name
        cell.commentTimeLabel.text = commentObj.created
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        //        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AssignmentDetailViewController") as! AssignmentDetailViewController
        //        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let commentObj:TEComment = discussionDetailData.comments[indexPath.row] as! TEComment
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(commentObj.comment, width: tableView.frame.size.width - 48)
        return 90+addedWidth
    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath)
    {
        
        if editingStyle == .delete
        {
            let commentObj:TEComment = discussionDetailData.comments[indexPath.row] as! TEComment
            let headers : [String:String] = [
                "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
                "token": ModelManager.singleton.loginData.token,
                "deviceType": "IOS"
            ]
            let str = String(format: "comment_id=%d",commentObj.id.intValue)
            ServerCommunication.singleton.requestWithPost(API_DELETE_COMMENT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
                print(successResponseDict)
                self.fetchDataFromServer()
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        }
    }

    
    @IBAction func sendMessageButtonAction(_ sender : AnyObject){
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d&comment=%@",mainDiscussionObject.id.intValue,commentTextViewOutlet.text)
        ServerCommunication.singleton.requestWithPost(API_SAVE_COMMENT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.commentTextViewOutlet.resignFirstResponder()
            self.commentTextViewOutlet.text = ""
            self.fetchDataFromServer()
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    
}


class DiscussionListTableCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var descTextViewOutlet: UITextView!
    
}
