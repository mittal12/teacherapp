//
//  AssessmentViewController.swift
//  TalentEdge
//
//

import UIKit

class AssessmentViewController: UIViewController {
    
    @IBOutlet weak var assessmentTableView: UITableView!
    var assessmentArray = [TEAssessmentData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
//        fetchDataFromServer()
        assessmentTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        assessmentTableView.showsVerticalScrollIndicator = false
        assessmentTableView.tableFooterView = UIView()

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
        ServerCommunication.singleton.requestWithPost(API_GET_ASSESSNMENT_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.assessmentArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEAssessmentData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEAssessmentData]
            self.assessmentTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assessmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentTableCell", for: indexPath) as! AssessmentTableCell
        cell.courseTitleLabel.text = assessmentArray[indexPath.row].Content.title
        cell.courseSubDetailLabel.text = assessmentArray[indexPath.row].Module.name
//        cell.timeLabelOutlet.text = "Published On : " + assessmentArray[indexPath.row].Content.created + " | End Date : " + assessmentArray[indexPath.row].Content.end_date
                cell.noOfQuesLabelOutlet.text = String(format: "Questions: %d | Duration: %@ | Total Marks: %d", assessmentArray[indexPath.row].Test.total_questions.intValue, assessmentArray[indexPath.row].Test.total_duration , assessmentArray[indexPath.row].Test.total_marks.intValue)
        cell.typeLabelOutlet.text = assessmentArray[indexPath.row].Content.desc
        //        cell.des
        cell.reviewButtonOutlet.setTitle(assessmentArray[indexPath.row].is_already_attempt.intValue == 1 ? "Review" : "Attempt", for: UIControlState())
        cell.courseImageView.image = UIImage(named: "assessment1.png")
        
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        let partTwo = NSMutableAttributedString(string: assessmentArray[indexPath.row].Content.created, attributes: yourAttributes)
        let partFour = NSMutableAttributedString(string: assessmentArray[indexPath.row].Content.end_date, attributes: yourAttributes)
        
        let combination = NSMutableAttributedString()
        combination.append(NSAttributedString(string: "Published On : "))
        combination.append(partTwo)
        combination.append(NSAttributedString(string: " | End Date : "))
        combination.append(partFour)
        cell.timeLabelOutlet.attributedText = combination
        cell.modeLabelOutlet.text = assessmentArray[indexPath.row].Test.test_type
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",assessmentArray[indexPath.row].Content.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_ASSESSMENT_DETAIL ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            let assessmentObj : TEAssessmentDetailData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessmentDetailData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssessmentDetailData
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssessmentDetailViewController") as! AssessmentDetailViewController
            detailVC.selectedAssessmentObj = assessmentObj
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(assessmentArray[indexPath.row].Content.desc, width: tableView.frame.size.width - 48)
        return 133.0+addedWidth
    }
    
    
}

class AssessmentTableCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var reviewButtonOutlet: UIButton!
    @IBOutlet weak var courseSubDetailLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var noOfQuesLabelOutlet: UILabel!
    @IBOutlet weak var typeLabelOutlet: UITextView!
    @IBOutlet weak var modeLabelOutlet: UILabel!
    
}
