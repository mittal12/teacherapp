//
//  AssignmentViewController.swift
//  TalentEdge
//
//

import UIKit

class AssignmentViewController: UIViewController {
    
    @IBOutlet weak var assignmentTableView: UITableView!
    var assignmentArray : [TEAssignmentData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
        assignmentArray = [TEAssignmentData]()
        assignmentTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        assignmentTableView.showsVerticalScrollIndicator = false
        assignmentTableView.tableFooterView = UIView()
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
        ServerCommunication.singleton.requestWithPost(API_GET_ASSIGNMENT_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.assignmentArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEAssignmentData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEAssignmentData]
            self.assignmentTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentTableCell", for: indexPath) as! AssessmentTableCell
        cell.courseTitleLabel.text = assignmentArray[indexPath.row].title
        cell.courseSubDetailLabel.text = assignmentArray[indexPath.row].module_name
        cell.modeLabelOutlet.text = assignmentArray[indexPath.row].submission_label
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        let partOne = NSMutableAttributedString(string: assignmentArray[indexPath.row].start_date_label)
        let partTwo = NSMutableAttributedString(string: assignmentArray[indexPath.row].start_date_value, attributes: yourAttributes)
        let partThree = NSMutableAttributedString(string: assignmentArray[indexPath.row].end_date_label)
        let partFour = NSMutableAttributedString(string: assignmentArray[indexPath.row].end_date_value, attributes: yourAttributes)
        
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(NSAttributedString(string: " : "))
        combination.append(partTwo)
        combination.append(NSAttributedString(string: " | "))
        combination.append(partThree)
        combination.append(NSAttributedString(string: " : "))
        combination.append(partFour)
        cell.timeLabelOutlet.attributedText = combination
        
        let part1 = NSMutableAttributedString(string: assignmentArray[indexPath.row].total_marks_label)
        let part2 = NSMutableAttributedString(string: String(format: "%d",assignmentArray[indexPath.row].total_marks.intValue), attributes: yourAttributes)
        let part3 = NSMutableAttributedString(string: assignmentArray[indexPath.row].submission_mode, attributes: yourAttributes)
        let combination1 = NSMutableAttributedString()
        combination1.append(part1)
        combination1.append(NSAttributedString(string: " : "))
        combination1.append(part2)
        combination1.append(NSAttributedString(string: " | Mode :"))
        combination1.append(part3)
        
        cell.noOfQuesLabelOutlet.attributedText = combination1
        cell.typeLabelOutlet.text = assignmentArray[indexPath.row].desc
        cell.courseImageView.image = UIImage(named: "Assignment1.png")
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",assignmentArray[indexPath.row].id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_ASSIGNMENT_DETAIL ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            let assignmentDetailObj : TEAssignmentDetail = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssignmentDetail"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssignmentDetail
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssignmentDetailViewController") as! AssignmentDetailViewController
            detailVC.assignmentDetailObj = assignmentDetailObj
            self.navigationController?.pushViewController(detailVC, animated: true)
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(assignmentArray[indexPath.row].desc, width: tableView.frame.size.width - 48)
        return 142.0+addedWidth
    }
}
