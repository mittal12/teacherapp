//
//  AssessmentReviewViewController.swift
//  TalentEdge
//
//

import UIKit

class AssessmentReviewViewController: UIViewController {
    
    @IBOutlet weak var assessmentCollectionView: UICollectionView!
    @IBOutlet weak var totalNuOfQuestionLabel: UILabel!
    @IBOutlet weak var totalMarksLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var previousButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var subNavTitleLabel: UILabel!

    var assessmentReviewData : TEAssessmentReviewData!
    
    var questionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func loadUI() {
        subNavTitleLabel.text = assessmentReviewData.Module.name
        totalNuOfQuestionLabel.text = String(format: "Total Question:%d",assessmentReviewData.Test.total_questions.intValue)
        previousButtonOutlet.isHidden = questionIndex == 0
        nextButtonOutlet.isHidden = questionIndex == assessmentReviewData.Test.total_questions.intValue-1

        nextButtonOutlet.isHidden = questionIndex == assessmentReviewData.Test.total_questions.intValue - 1
        //        totalMarksLabel.text = String(format: "Total Marks:%d",assessmentReviewData.Test.total_questions.integerValue)
    }
    
    @IBAction func backButtonAction (_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            cell.countLabel.text = String(format: "%d",indexPath.row + 1)
            return cell
        } else {
            let cell : AssessmentReviewCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssessmentReviewCollectionCell1",for:indexPath) as! AssessmentReviewCollectionCell
            cell.countLabel.text = String(format: "%d",indexPath.row + 1)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        questionIndex = indexPath.row
        loadUI()
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
            cell.optionTitleLabel.text = obj1.option_statement
            cell.selectButtonOutlet.isUserInteractionEnabled = false
            cell.selectButtonOutlet.setFAIcon(obj.Question.selected_option_id.contains(String(format: "%d", obj1.id.intValue)) ? FAType.faCheck : FAType.faSquare, forState: UIControlState())
            cell.selectButtonOutlet.layer.borderColor = DataUtils.colorWithHexString("3bab14").cgColor
            cell.selectButtonOutlet.layer.cornerRadius = 3.0
            cell.selectButtonOutlet.setTitleColor(obj.Question.selected_option_id.contains(String(format: "%d", obj1.id.intValue)) ? UIColor.green : UIColor.clear, for: UIControlState())
            
            
            cell.correctionLabel.text = obj1.is_correct_option.boolValue ? "[Correct Answer]" : obj.Question.selected_option_id.contains(String(format: "%d", obj1.id.intValue)) ? "[Your Answer]" : ""
            cell.correctionLabel.textColor = obj1.is_correct_option.boolValue ? DataUtils.colorWithHexString("3bab14") : UIColor.red
            
            cell.correctionLabel.text = obj.Question.selected_option_id.count == 0 ? "" : cell.correctionLabel.text
            cell.correctionLabel.text = obj.Question.is_student_correct == "Y" ? "[Your Answer]" : cell.correctionLabel.text

            cell.correctionLabel.textColor = obj.Question.is_student_correct == "Y" ? DataUtils.colorWithHexString("3bab14") : cell.correctionLabel.textColor
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        //        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyCourseDetailViewController") as! MyCourseDetailViewController
        //        detailVC.selectedCourseObj = indexPath.section == 0 ? myCourseList.ongoingCourse[indexPath.row] as! TECourseData : myCourseList.completedCourse[indexPath.row] as! TECourseData
        //
        //        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let courseObj = myCourseList.ongoingCourse[indexPath.row] as! TECourseData
    //
    //        return courseObj.course_name
    //    }
    
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
    

    
    @IBAction func previousButtonAction(_ sender: AnyObject) {
        questionIndex = questionIndex - 1
        loadUI()
        assessmentCollectionView.reloadData()
        questionTableView.reloadData()
    }
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: AnyObject) {
        questionIndex = questionIndex + 1
        loadUI()
        assessmentCollectionView.reloadData()
        questionTableView.reloadData()
    }
}

class AssessmentReviewQuestionCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UITextView!
    
}

class AssessmentReviewCollectionCell: UICollectionViewCell {
    @IBOutlet weak var countLabel: UILabel!
    
}

class AssessmentReviewOptionCell: UITableViewCell {
    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var correctionLabel : UILabel!
    @IBOutlet weak var selectButtonOutlet: UIButton!
}


