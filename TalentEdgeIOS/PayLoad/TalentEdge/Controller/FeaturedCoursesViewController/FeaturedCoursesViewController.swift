//
//  FeaturedCoursesViewController.swift
//  TalentEdge
//
//

import UIKit

class FeaturedCoursesViewController: UIViewController {
    
    @IBOutlet weak var featuredCourseTableView: UITableView!
    var featuredCourseArray = [TEFeaturedCourseData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromServer()
        // Do any additional setup after loading the view.
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
        ServerCommunication.singleton.requestWithPost(API_FEATURED_COURSE_LIST ,headerDict: headers, postString: " ", success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.featuredCourseArray = JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEFeaturedCourseData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEFeaturedCourseData]
            self.featuredCourseTableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuredCourseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCoursesTableCell", for: indexPath) as! FeaturedCoursesTableCell
//        cell.courseImageView.setFAIconWithName(FAType.FAClipboard, textColor: UIColor.blackColor())
        cell.courseImageView.sd_setImage(with: URL(string: featuredCourseArray[indexPath.row].course_image))
        cell.courseTitleLabel.text = featuredCourseArray[indexPath.row].post_title
        cell.courseSubDetailLabel.text = featuredCourseArray[indexPath.row].course_name
        cell.courseDateLabel.text = featuredCourseArray[indexPath.row].course_start_date_fomated
        cell.courseMonthLabel.text = featuredCourseArray[indexPath.row].duration
        cell.courseTextview.text = featuredCourseArray[indexPath.row].key_points_0 + "\n" + featuredCourseArray[indexPath.row].key_points_1
        cell.detailButtonOutlet.tag = indexPath.row
        cell.detailButtonOutlet.addTarget(self, action: #selector(detailButtonAction(_:)), for: .touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func detailButtonAction(_ sender : UIButton) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeaturedCoureDetailVC") as! FeaturedCoureDetailVC
        detailVC.featuredCourseData = featuredCourseArray[sender.tag]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){

    }
    
}

class FeaturedCoursesTableCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var courseSubDetailLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var detailButtonOutlet: UIButton!
    @IBOutlet weak var courseDateLabel: UILabel!
    @IBOutlet weak var courseMonthLabel: UILabel!
    @IBOutlet weak var courseTextview: UITextView!



    
}
