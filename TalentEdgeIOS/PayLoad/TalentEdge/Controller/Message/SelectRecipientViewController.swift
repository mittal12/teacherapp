//
//  SelectRecipientViewController.swift
//  TalentEdge
//
//

import UIKit

class SelectRecipientViewController: UIViewController {
    
    @IBOutlet weak var recipientTableView: UITableView!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    var bachmateData : TEBatchmateData!
    var selectedRecipientArray : [TEStudentData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonOutlet.setFAIcon(FAType.faArrowLeft, forState: UIControlState())
        doneButtonOutlet.setFAIcon(FAType.faCheck, forState: UIControlState())
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        //            tableView.headerViewForSection(section)?.backgroundColor = KNavigationBarColor
        return section == 0 ? "Student" : section == 1 ? "Faculty" : "SRM"
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? bachmateData.student.count : section == 1 ? bachmateData.faculty.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectRecipientTableCell", for: indexPath) as! SelectRecipientTableCell
        let studentObj : TEStudentData = indexPath.section == 0 ? bachmateData.student[indexPath.row] as! TEStudentData : bachmateData.faculty[indexPath.row] as! TEStudentData
        cell.nameLabel.text = studentObj.name
        cell.selectButton.setFAIcon(studentObj.isSelected ? FAType.faCheck : FAType.faSquare, forState: UIControlState())
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        //        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InboxDetailViewController") as! InboxDetailViewController
        //        self.navigationController?.pushViewController(detailVC, animated: true)
        let studentObj : TEStudentData = indexPath.section == 0 ? bachmateData.student[indexPath.row] as! TEStudentData : bachmateData.faculty[indexPath.row] as! TEStudentData
        studentObj.isSelected = !studentObj.isSelected
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(_ sender: AnyObject) {
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
}


class SelectRecipientTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
}
