//
//  AssessmentDetailViewController.swift
//  TalentEdge
//
//

import UIKit

class AssessmentDetailViewController: UIViewController {
    
    @IBOutlet weak var assessmentTitleLabel: UILabel!
    @IBOutlet weak var assessmentTimeLabel: UILabel!
    @IBOutlet weak var assessmentTypeLabel: UILabel!
    @IBOutlet weak var assessmentTotalQuesLabel: UILabel!
    @IBOutlet weak var assessmentTotalMarksLabel: UILabel!
    @IBOutlet weak var assessmentTotalLimitLabel: UILabel!
    @IBOutlet weak var assessmentDescLabel: UITextView!
    @IBOutlet weak var assessmentReviewButton: UIButton!
    @IBOutlet weak var assessmentReAttemptButton: UIButton!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    var moduleData : TEModuleDetailData!
    var selectedAssessmentObj: TEAssessmentDetailData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataUtils.addBackArrow(self.navigationItem, withTitle: "ASSESSMENT", target: self)
        loadUI()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func loadUI(){
        subNavTitleLabel.text = moduleData == nil ? selectedAssessmentObj.Content.title : self.moduleData.module_name
        assessmentTitleLabel.text = selectedAssessmentObj.Content.title
        assessmentTimeLabel.text = String(format: "Start Date:%@ | End Date:%@",selectedAssessmentObj.Content.start_date,selectedAssessmentObj.Content.end_date)
        assessmentTypeLabel.text = selectedAssessmentObj.Test.test_type
        assessmentTotalQuesLabel.text = String(format: "%d",selectedAssessmentObj.Test.total_questions.intValue)
        assessmentTotalMarksLabel.text = String(format: "%d",selectedAssessmentObj.Test.total_marks.intValue)
        assessmentTotalLimitLabel.text = selectedAssessmentObj.Test.total_duration_formated
        assessmentDescLabel.text = selectedAssessmentObj.Content.desc
        assessmentReviewButton.isHidden = selectedAssessmentObj.is_already_attempt.intValue != 1
        assessmentReAttemptButton.isHidden = selectedAssessmentObj.canAttempt.intValue != 1
        assessmentReAttemptButton.setTitle(selectedAssessmentObj.is_already_attempt.boolValue ? "Re-Attempt" : "Start", for: UIControlState())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func reviewButtonAction(_ sender: AnyObject) {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",selectedAssessmentObj.Content.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_ASSESSMENT_REVIEW ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            let assessmentReviewObj : TEAssessmentReviewData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessmentReviewData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssessmentReviewData
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssessmentReviewViewController") as! AssessmentReviewViewController
            detailVC.assessmentReviewData = assessmentReviewObj
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    @IBAction func reAttemptButtonAction(_ sender: AnyObject) {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",selectedAssessmentObj.Content.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_ASSESSMENT_REATTEMPT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            let assessmentReviewObj : TEAssessementReAttemptData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessementReAttemptData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssessementReAttemptData
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssessmentReAttemptViewController") as! AssessmentReAttemptViewController
            detailVC.assessmentReviewData = assessmentReviewObj
            detailVC.selectedAssessmentObj = self.selectedAssessmentObj
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
}
