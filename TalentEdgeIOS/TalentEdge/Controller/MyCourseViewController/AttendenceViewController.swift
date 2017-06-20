//
//  AttendenceViewController.swift
//  TalentEdge
//
//

import UIKit

class AttendenceViewController: UIViewController {
    @IBOutlet weak var attendenceTableView: UITableView!
    @IBOutlet weak var totalClassesLabel: UILabel!
    @IBOutlet weak var attendenceLabel: UILabel!

    var attendenceData = TEAttendenceList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBarHidden = true
        attendenceTableView.addScalableCover(with: ModelManager.singleton.courseImage)
        attendenceTableView.showsVerticalScrollIndicator = false
        attendenceTableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetctDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func fetctDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "batch_id=%d",self.selectedCourseObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_ATTENDENCE_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.attendenceData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEAttendenceList"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEAttendenceList
            self.totalClassesLabel.text = String(format: "%d",self.attendenceData.total_class_count.intValue)
            self.attendenceLabel.text = String(format: "%.0f",self.attendenceData.own_attendacne_percentage.doubleValue) + "%"
            self.attendenceTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendenceData.live_session_attendance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]

        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendenceTableCell", for: indexPath) as! AttendenceTableCell
        let attenceObj:TEAttendenceData = attendenceData.live_session_attendance[indexPath.row] as! TEAttendenceData
        cell.courseImageView.image = UIImage(named: "live_class1.PNG")
        let partOne = NSMutableAttributedString(string: attenceObj.module_name)
        let combination = NSMutableAttributedString()
        combination.append(NSAttributedString(string: "Module : "))
        combination.append(partOne)
        cell.courseSubDetailLabel.attributedText = combination
        
        let part1 = NSMutableAttributedString(string: attenceObj.start_date_formated, attributes: yourAttributes)
        let part2 = NSMutableAttributedString(string: attenceObj.content_duration_fomated, attributes: yourAttributes)
        let combination1 = NSMutableAttributedString()
        combination1.append(NSAttributedString(string: "Session Date : "))
        combination1.append(part1)
        combination1.append(NSAttributedString(string: " | Duration : "))
        combination1.append(part2)
        cell.timeLabelOutlet.attributedText = combination1
        cell.courseTitleLabel.text = attenceObj.title
        cell.attendenceLabelOutlet.text = attenceObj.attendance_in_live_class
        cell.publisherLabelOutlet.text = attenceObj.published_by
        cell.descTextViewOutlet.text = attenceObj.desc
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let attenceObj:TEAttendenceData = attendenceData.live_session_attendance[indexPath.row] as! TEAttendenceData
        let addedWidth:CGFloat = DataUtils.getDynamicHeight(attenceObj.desc, width: tableView.frame.size.width - 48)
        return 135.0+addedWidth
    }
}

class AttendenceTableCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseSubDetailLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var publisherLabelOutlet: UILabel!

    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var attendenceLabelOutlet: UILabel!
    @IBOutlet weak var descTextViewOutlet: UITextView!
    
}

