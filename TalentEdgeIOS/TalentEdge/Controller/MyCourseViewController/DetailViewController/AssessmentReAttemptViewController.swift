//
//  AssessmentReAttemptViewController.swift
//  TalentEdge
//
//

import UIKit

class AssessmentReAttemptViewController: UIViewController {
    
    @IBOutlet weak var assessmentCollectionView: UICollectionView!
    @IBOutlet weak var totalNuOfQuestionLabel: UILabel!
    @IBOutlet weak var totalMarksLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var previousButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var watchImageView: UIImageView!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    
    
    var timer = Timer()
    
    var answers = [[String : AnyObject]]()
    
    var assessmentReviewData : TEAssessementReAttemptData!
    var selectedAssessmentObj: TEAssessmentDetailData!
    
    var questionIndex = 0
    
    var startDate : Date!
    var endDate : Date!
    @IBOutlet weak var assessmentTableView: UITableView!
    
    //MARK :- Outlets For ConfirmationView
    @IBOutlet weak var confirmationMainView: UIView!
    @IBOutlet weak var confirmationMainSuperView: UIView!
    @IBOutlet weak var avoidImageView: UIImageView!
    @IBOutlet weak var watchImageView1: UIImageView!
    @IBOutlet weak var watchImageView2: UIImageView!
    @IBOutlet weak var watchImageView3: UIImageView!
    @IBOutlet weak var totalQuestionLabel: UILabel!
    @IBOutlet weak var attemptedQuestionLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    //    @IBOutlet weak var flagButtonOutlet: UIButton!
    
    var releaseDate: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<assessmentReviewData.TestQuestion.count {
            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[i] as! TSAssessmentTestQuestion
            var dict = [String : AnyObject]()
            dict["question_id"] = obj.Question.id
            dict["selected_option_id"] = Int() as AnyObject?
            
            answers.append(dict)
        }
        totalQuestionLabel.text = String(format: "%d",assessmentReviewData.Test.total_questions.intValue)
        startDate = Date()
        
        releaseDate = Date().addingTimeInterval(assessmentReviewData.Test.total_durations.doubleValue)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        loadUI()
    }
    
    func update() {
        let currentDate = Date()
        let diffDateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: currentDate, to: releaseDate!, options: .matchFirst)
        
        if diffDateComponents.minute == 0 && diffDateComponents.second == 0 {
            
            var count = 0
            for item in answers {
                
                if let counter = item["selected_option_id"] as? Int {
                    count += 1
                }
                
//                if item["selected_option_id"]?.intValue != nil {
//                    
//                }
            }
            timer.invalidate()
            
            if count == 0 {
                DataUtils.addErrorToast("You haven't attempted any question", controller: self)
                Timer.scheduledTimer(timeInterval: 1.5, target: DataUtils.self, selector: #selector(DataUtils.removeErrorToast), userInfo: nil, repeats: false)
             _ =   self.navigationController?.popViewController(animated: true)
                return
            }
            
            cancelButtonAction(UIButton())
        }else{
            let countdown = "\(diffDateComponents.minute):\(diffDateComponents.second)"
            countDownLabel.text = countdown
        }
        
        
        // Something cool
    }
    
    fileprivate func loadUI() {
        subNavTitleLabel.text = assessmentReviewData.Module.name
        totalNuOfQuestionLabel.text = String(format: "Total Question:%d | Total Marks:%d",assessmentReviewData.Test.total_questions.intValue,assessmentReviewData.Test.total_questions.intValue)
        
        //        var totalMarks = 0
        //        for item in assessmentReviewData.TestQuestion {
        //            let itemObj : TEAssessmentTest = item as! TEAssessmentTest
        //            totalMarks = totalMarks + itemObj.mar
        //        }
        previousButtonOutlet.isHidden = questionIndex == 0
        nextButtonOutlet.isHidden = questionIndex == assessmentReviewData.Test.total_questions.intValue - 1
        nextButtonOutlet.isHidden = questionIndex == assessmentReviewData.Test.total_questions.intValue-1
        
        
        
        //        totalMarksLabel.text = String(format: "Total Marks:%d",assessmentReviewData.Test.total_questions.integerValue)
    }
    
    @IBAction func backButtonAction (_ sender : UIButton) {
        timer.invalidate()
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assessmentReviewData.TestQuestion.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row <= questionIndex {
            let cell : AssessmentReviewCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssessmentReviewCollectionCell",for:indexPath) as! AssessmentReviewCollectionCell
            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[indexPath.row] as! TSAssessmentTestQuestion
            if obj.isFlag == true {
                cell.countLabel.setFAIcon(FAType.faFlag, iconSize: 25.0)
            }else {
                cell.countLabel.text = String(format: "%d",indexPath.row + 1)
            }
            return cell
        } else {
            let cell : AssessmentReviewCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssessmentReviewCollectionCell1",for:indexPath) as! AssessmentReviewCollectionCell
            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[indexPath.row] as! TSAssessmentTestQuestion
            if obj.isFlag == true {
                cell.countLabel.setFAIcon(FAType.faFlag, iconSize: 25.0)
            }else {
                cell.countLabel.text = String(format: "%d",indexPath.row + 1)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        questionIndex = indexPath.row
        questionTableView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let edgeInsets = (collectionView.frame.width - (CGFloat(assessmentReviewData.TestQuestion.count) * 20) - (CGFloat(assessmentReviewData.TestQuestion.count) * 10)) / 2
        return UIEdgeInsetsMake(0, edgeInsets, 0, 0);
    }
    
    //     MARK: - UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[questionIndex] as! TSAssessmentTestQuestion
        return obj.QuestionOption.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentReviewQuestionCell" , for: indexPath) as! AssessmentReviewQuestionCell
            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[questionIndex] as! TSAssessmentTestQuestion
            cell.questionLabel.text = obj.Question.statement
            questionTypeLabel.text = obj.Question.question_type
            questionNumberLabel.text = String(format: "Q%d.",questionIndex + 1)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentReviewOptionCell" , for: indexPath) as! AssessmentReviewOptionCell
            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[questionIndex] as! TSAssessmentTestQuestion
            let obj1 : TSAssementQuestionOption = obj.QuestionOption[indexPath.row-1] as! TSAssementQuestionOption
            cell.optionTitleLabel.text = obj1.option_statement == "" ? "N/A" : obj1.option_statement
            cell.selectButtonOutlet.isUserInteractionEnabled = false
            if (answers[questionIndex]["selected_option_id"])?.intValue == obj1.id.intValue {
                cell.selectButtonOutlet.setFAIcon(FAType.faCheckSquare, forState: UIControlState())
            }else{
                //                cell.selectButtonOutlet.setFAIcon(FAType.FASquare, forState: .Normal)
                cell.selectButtonOutlet.setTitle("", for: UIControlState())
            }
            //            cell.correctionLabel.hidden = (obj.Question.selected_option_id[0] as! String == (String(format: "%d", obj1.id.integerValue)) && obj.Question.is_student_correct == "N") ? false : !obj1.is_correct_option.boolValue
            cell.correctionLabel.text = ""
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        if indexPath.row != 0 {
            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[questionIndex] as! TSAssessmentTestQuestion
            
            let obj1 : TSAssementQuestionOption = obj.QuestionOption[indexPath.row-1] as! TSAssementQuestionOption
//            let alertController = UIAlertController(title:String(format: "%d",obj.QuestionOption.count) , message:"" , preferredStyle: .Alert)
//            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.answers[self.questionIndex]["selected_option_id"] = obj1.id.intValue as AnyObject?
                            DispatchQueue.main.async {
                                self.reloadTable()
//                                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                            }
//            }
//            alertController.addAction(OKAction)
//            self.presentViewController(alertController, animated: true) { }
        
        }
    }
    
    //
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    //        if indexPath.row != 0 {
    ////            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[questionIndex] as! TSAssessmentTestQuestion
    ////            let obj1 : TSAssementQuestionOption = obj.QuestionOption[indexPath.row-1] as! TSAssementQuestionOption
    //            //        answers[String(format : "%d", indexPath.row - 1)] = obj1.id
    //            //        if answers.count != 0 {
    //            //        for i in 0..<answers.count {
    //            //            if answers[questionIndex]["question_id"]?.integerValue == obj.Question.id.integerValue {
    ////            answers[questionIndex]["selected_option_id"] = obj1.id.integerValue
    //            //            }else {
    //            //                var dict = [String : AnyObject]()
    //            //                dict["question_id"] = obj.Question.id
    //            //                dict["selected_option_id"] = obj1.id
    //            //                answers.append(dict)
    //            //            }
    //            //        }
    //            //        }else {
    //            //            var dict = [String : AnyObject]()
    //            //            dict["question_id"] = obj.Question.id
    //            //            dict["selected_option_id"] = obj1.id
    //            //            answers.append(dict)
    //            //        }
    //            //
    //            //
    //            //        for i in 0..<assessmentReviewData.TestQuestion.count {
    //            //            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[i] as! TSAssessmentTestQuestion
    //            //            var dict = [String : AnyObject]()
    //            //            dict["question_id"] = obj.Question.id
    //            //            answers.append(dict)
    //            //        }
    ////            return
    ////            print(answers)
    ////            dispatch_async(dispatch_get_main_queue()) {
    //////                self.reloadTable()
    ////                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    ////            }
    ////        }
    //    }
    
    func reloadTable () {
        self.questionTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[questionIndex] as! TSAssessmentTestQuestion
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(obj.Question.statement, width: tableView.frame.size.width - 48)
            return 30.0+addedWidth
        }else {
            let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[questionIndex] as! TSAssessmentTestQuestion
            let obj1 : TSAssementQuestionOption = obj.QuestionOption[indexPath.row-1] as! TSAssementQuestionOption
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(obj1.option_statement, width: tableView.frame.size.width - 48)
            return 35.0+addedWidth
        }
    }
    
    @IBAction func flagButtonAction(_ sender: AnyObject) {
        let obj : TSAssessmentTestQuestion = assessmentReviewData.TestQuestion[questionIndex] as! TSAssessmentTestQuestion
        obj.isFlag = !obj.isFlag
        loadUI()
        assessmentCollectionView.reloadData()
        questionTableView.reloadData()
    }
    
    fileprivate func saveAssessment () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str1 = String(format: "content_id=%d&",selectedAssessmentObj.Content.id.intValue)
        let str2 = String(format: "time_taken=%.2f&",self.endDate.timeIntervalSince(self.startDate))
        var array = NSMutableArray()
        for item in self.answers {
            if item["selected_option_id"]?.intValue != 0 {
                array.add(item)
            }
        }
        
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
        }catch let error as NSError{
            print(error.description)
        }
        let str3 = String(format: "question=%@",tempJson)

        ServerCommunication.singleton.requestWithPost(API_ASSESSMENT_SAVE ,headerDict: headers, postString: str1 + str2 + str3, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            //            let assessmentReviewObj : TEAssessementReAttemptData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessementReAttemptData"), jsonData: successResponseDict.valueForKey("resultData") as! NSDictionary) as! TEAssessementReAttemptData
            //            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AssessmentReAttemptViewController") as! AssessmentReAttemptViewController
            //            detailVC.assessmentReviewData = assessmentReviewObj
            //            self.navigationController?.pushViewController(detailVC, animated: true)
            
            //            self.navigationController?.popViewControllerAnimated(true)
            
            self.completeAssessment()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }

//        let alertController = UIAlertController(title:"1", message:"" , preferredStyle: .Alert)
//        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//            let str2 = String(format: "time_taken=%.2f&",self.endDate.timeIntervalSinceDate(self.startDate))
//            
//            let alertController = UIAlertController(title:"2", message:"" , preferredStyle: .Alert)
//            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                
//                var array = NSMutableArray()
//                for item in self.answers {
//                    if item["selected_option_id"]?.integerValue != 0 {
//                        array.addObject(item)
//                    }
//                }
//                
//                var tempJson : NSString = ""
//                do {
//                    let arrJson = try NSJSONSerialization.dataWithJSONObject(array, options: NSJSONWritingOptions.PrettyPrinted)
//                    let string = NSString(data: arrJson, encoding: NSUTF8StringEncoding)
//                    tempJson = string! as NSString
//                }catch let error as NSError{
//                    print(error.description)
//                }
//                let str3 = String(format: "question=%@",tempJson)
//                
//                let alertController = UIAlertController(title:"3", message:"" , preferredStyle: .Alert)
//                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                    
//                    
//                    ServerCommunication.singleton.requestWithPost(API_ASSESSMENT_SAVE ,headerDict: headers, postString: str1 + str2 + str3, success: { (successResponseDict) -> Void in
//                        print(successResponseDict)
//                        //            let assessmentReviewObj : TEAssessementReAttemptData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessementReAttemptData"), jsonData: successResponseDict.valueForKey("resultData") as! NSDictionary) as! TEAssessementReAttemptData
//                        //            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AssessmentReAttemptViewController") as! AssessmentReAttemptViewController
//                        //            detailVC.assessmentReviewData = assessmentReviewObj
//                        //            self.navigationController?.pushViewController(detailVC, animated: true)
//                        
//                        //            self.navigationController?.popViewControllerAnimated(true)
//                        
//                        self.completeAssessment()
//                        
//                    }) { (errorResponseDict) -> Void in
//                        DataUtils.showAlertMessage(errorResponseDict.valueForKey("errDesc") as! String, withTitle: "", delegate: self)
//                    }
//                }
//                alertController.addAction(OKAction)
//                self.presentViewController(alertController, animated: true) { }
//                }
//            alertController.addAction(OKAction)
//            self.presentViewController(alertController, animated: true) { }
//            }
//        alertController.addAction(OKAction)
//        self.presentViewController(alertController, animated: true) { }
        
    }
    
    fileprivate func completeAssessment () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",selectedAssessmentObj.Content.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_ASSESSMENT_COMPLETE ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            let assessmentCompleteObj : TEAssessmentCompleteData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAssessmentCompleteData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAssessmentCompleteData
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssessmentSubmitDetailViewController") as! AssessmentSubmitDetailViewController
            detailVC.assessmentCompleteObj = assessmentCompleteObj
            detailVC.selectedAssessmentObject = self.selectedAssessmentObj
            //                        detailVC.selectedAssessmentObj = self.selectedAssessmentObj
            self.navigationController?.pushViewController(detailVC, animated: true)
            //            self.navigationController?.popViewControllerAnimated(true)
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    @IBAction func previousButtonAction(_ sender: AnyObject) {
        questionIndex = questionIndex - 1
        loadUI()
        assessmentCollectionView.reloadData()
        questionTableView.reloadData()
    }
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        endDate = Date()
        let timeTaken : Double = endDate.timeIntervalSince(startDate)
        timeTakenLabel.text = String(format : "%.2f Seconds",timeTaken)
        
        var count = 0
        for item in answers {
            if item["selected_option_id"]?.intValue != 0 {
                count += 1
            }
        }
        
        if count == 0 {
            DataUtils.addErrorToast("You haven't attempted any question", controller: self)
            Timer.scheduledTimer(timeInterval: 1.5, target: DataUtils.self, selector: #selector(DataUtils.removeErrorToast), userInfo: nil, repeats: false)
            return
        }
        attemptedQuestionLabel.text = String(format : "%d",count)
        
        
        confirmationMainSuperView.isHidden = false
        //        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func nextButtonAction(_ sender: AnyObject) {
        questionIndex = questionIndex + 1
        loadUI()
        assessmentCollectionView.reloadData()
        questionTableView.reloadData()
    }
    
    //MARK :- Action for Confirmation View
    
    @IBAction func cancelConfirmButtonAction(_ sender: AnyObject) {
        confirmationMainSuperView.isHidden = true
        //        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func yesConfirmButtonAction(_ sender: AnyObject) {
        saveAssessment()
    }
}

