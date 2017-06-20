//
//  AssessmentSubmitDetailViewController.swift
//  TalentEdge
//
//

import UIKit

class AssessmentSubmitDetailViewController: UIViewController {
    
    
    @IBOutlet weak var assessmentNameLabel: UILabel!
    @IBOutlet weak var assessmentObjecLabel: UILabel!
    @IBOutlet weak var assessmentTypeLabel: UILabel!
    @IBOutlet weak var totalMarksLabel: UILabel!
    @IBOutlet weak var totalQuestionsLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var questionattemptedLabel: UILabel!
    @IBOutlet weak var marksObtainedLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var instructionImageView: UIImageView!
    @IBOutlet weak var watchImageView1: UIImageView!
    @IBOutlet weak var watchImageView2: UIImageView!
    @IBOutlet weak var watchImageView3: UIImageView!
    @IBOutlet weak var watchImageView4: UIImageView!
    @IBOutlet weak var watchImageView5: UIImageView!
    @IBOutlet weak var reviewButtonOutlet: UIButton!
    @IBOutlet weak var reAttemptButtonOutlet: UIButton!
    @IBOutlet weak var subNavTitleLabel: UILabel!

    var assessmentCompleteObj : TEAssessmentCompleteData!
    var selectedAssessmentObject : TEAssessmentDetailData!
    override func viewDidLoad() {
        super.viewDidLoad()
        DataUtils.addBackArrow(self.navigationItem, withTitle: "Assessment", target: self)
        
        //        instructionImageView.setFAIconWithName(FAType.FAInstagram , textColor : UIColor.blackColor())
        //        fileImageView.setFAIconWithName(FAType.FAFile , textColor : UIColor.blackColor())
        //        watchImageView1.setFAIconWithName(FAType.FAClockO , textColor : UIColor.blackColor())
        //        watchImageView2.setFAIconWithName(FAType.FAClockO , textColor : UIColor.blackColor())
        //        watchImageView3.setFAIconWithName(FAType.FAClockO , textColor : UIColor.blackColor())
        //        watchImageView4.setFAIconWithName(FAType.FAClockO , textColor : UIColor.blackColor())
        //        watchImageView5.setFAIconWithName(FAType.FAClockO , textColor : UIColor.blackColor())
        subNavTitleLabel.text = assessmentCompleteObj.Module.name
        assessmentNameLabel.text = assessmentCompleteObj.Content.title
        assessmentObjecLabel.text = assessmentCompleteObj.Content.desc
        assessmentTypeLabel.text = assessmentCompleteObj.Test.test_type
        totalQuestionsLabel.text = String(format: "%d",assessmentCompleteObj.Test.total_questions.intValue)
        totalMarksLabel.text = String(format: "%d",assessmentCompleteObj.Test.total_marks.intValue)
        timeLimitLabel.text = String(format: "%d Seconds",assessmentCompleteObj.Test.total_duration.intValue)
        timeTakenLabel.text = String(format: "%.2f Seconds",assessmentCompleteObj.studentResult.timeTaken.doubleValue)
        questionattemptedLabel.text = String(format: "%d",assessmentCompleteObj.studentResult.attemptedQuestions.intValue)
        marksObtainedLabel.text = String(format: "%d",assessmentCompleteObj.studentResult.marksObtained.intValue)
        correctLabel.text = String(format: "%d",assessmentCompleteObj.studentResult.correct.intValue)
        wrongLabel.text = String(format: "%d",assessmentCompleteObj.studentResult.wrong.intValue)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func reviewButtonAction(_ sender: AnyObject) {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",assessmentCompleteObj.Content.id.intValue)
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
        let str = String(format: "content_id=%d",assessmentCompleteObj.Content.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_ASSESSMENT_REATTEMPT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            let assessmentReviewObj : TEAssessementReAttemptData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessementReAttemptData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssessementReAttemptData
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssessmentReAttemptViewController") as! AssessmentReAttemptViewController
            detailVC.assessmentReviewData = assessmentReviewObj
            detailVC.selectedAssessmentObj = self.selectedAssessmentObject
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    
}
