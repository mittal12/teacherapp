//
//  NotesDetailsViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 11/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class NotesDetailsViewController: UIViewController  , UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var upperMainTitle: UILabel!
    
    @IBOutlet weak var subNavSubtitle: UILabel!
    
    
    
    @IBOutlet weak var upperViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titileLabel: UILabel!
    
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var upperViewFirstLabel: UILabel!
    
    @IBOutlet weak var upperViewSecondLabel: UILabel!
    
    @IBOutlet weak var upperViewThirdLabel: UILabel!
    
    @IBOutlet weak var leftUpperLabel: UILabel!
    
    @IBOutlet weak var leftBottomLabel: UILabel!
    
    
    @IBOutlet weak var rightUpperLabel: UILabel!
    
    @IBOutlet weak var rightMiddleView: UIView!
    
    
    @IBOutlet weak var rightBottomLabel: UILabel!
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var readButton: UIButton!
    var isExpanded = true
    var NotesDetailObj : NotesDetailsMainModel?
    
    var isCameFromDrawer : Bool!

    var content_type_id: NSNumber?
    var content_id :NSNumber?
    var type:Int?
    var notesObj: TEModuleDetailData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotesDetailObj = NotesDetailsMainModel()
      //  tableView.addScalableCover(with: ModelManager.singleton.courseImage)
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        self.subNavSubtitle.text = notesObj.module_name        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    //subTitleLabel.text = moduleData == nil ? self.selectedCourseObj.name : self.moduleData.module_name
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
        let str = String(format: "batch_id=%d&content_type_id=%d&content_id=%d",self.selectedCourseObj.id.intValue,(self.content_type_id?.intValue)!,(self.content_id?.intValue)!)
        ServerCommunication.singleton.requestWithPost(API_NOTES_DETAILS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.NotesDetailObj = (JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("NotesDetailsMainModel"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! NotesDetailsMainModel?)!
            self.setUpUIUpperView()
            self.tableView.reloadData()
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
func setUpUIUpperView()
{
    let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
     subTitleLabel.text = notesObj.module_name
    self.titileLabel.text = notesObj.title
    // cell.descriptionTextVIew.text = subModuleArray[indexPath.row].desc
    self.subTitleLabel.text = (notesObj.module_name)
    // cell.bottomBlueButton.setTitle("  Read  ", for: UIControlState())
   // self.upperImage.image = UIImage(named: "live_class1.PNG")
    
    let part1 = NSMutableAttributedString(string: (notesObj.start_date_label))
    
    let part2 = NSMutableAttributedString(string: (notesObj.start_date_value), attributes: yourAttributes)
    
    let part3 = NSMutableAttributedString(string: (notesObj.end_date_label))
    
    let part4 = NSMutableAttributedString(string: (notesObj.end_date_value), attributes: yourAttributes)
    
    let combination3 = NSMutableAttributedString()
    
    combination3.append(part1)
    
    combination3.append(NSAttributedString(string: " : "))
    
    combination3.append(part2)
    
    combination3.append(NSAttributedString(string: " | "))
    
    combination3.append(part3)
    
    combination3.append(NSAttributedString(string: " : "))
    
    combination3.append(part4)
    
    self.upperViewSecondLabel.attributedText = combination3
    
    let partOne = NSMutableAttributedString(string: String(format : "%d",(notesObj.notes_count.intValue)), attributes: yourAttributes)
    
    let partTwo = NSMutableAttributedString(string: (notesObj.content_duration_formated), attributes: yourAttributes)
    
    if notesObj.content_type_id.intValue == 2 || notesObj.content_type_id.intValue == 3  {
        let combination1 = NSMutableAttributedString()
        
        combination1.append(NSAttributedString(string: "Duration : "))
        
        combination1.append(partTwo)
        
        self.upperViewFirstLabel.attributedText = combination1
    }else{
        let combination1 = NSMutableAttributedString()
        
        combination1.append(NSAttributedString(string: "Pages : "))
        
        combination1.append(partOne)
        
        combination1.append(NSAttributedString(string: " | Duration : "))
        
        combination1.append(partTwo)
        
        self.upperViewFirstLabel.attributedText = combination1
    }
        self.leftBottomLabel.text = "completed"
    
    
    if(type == 2 || type == 3){
        self.rightUpperLabel.text  =  "\(notesObj.cnt_completed) Out of \(notesObj.cnt_completed) + \(notesObj.cnt_not_completed)"
        if(type == 2)
        {
            self.upperMainTitle.text = "Videos"
        }
        else
        {
            self.upperMainTitle.text = "Reference Videos"
        }
    }
    else if( type == 1)
    {
     self.rightUpperLabel.text  =  "\(notesObj.cnt_completed) Out of \(notesObj.notes_count)"
    }
    
        self.rightBottomLabel.text = "Completed"
        self.leftUpperLabel.text = String(describing: notesObj.avg_completion_percentage)
        
        self.leftUpperLabel.text = self.leftUpperLabel.text! + "%"
        //draw circle   cell.circleAttandanceLabel
        drawFullCircle(end: CGPoint(x: self.leftUpperLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: self.leftUpperLabel, completionPercentage: Double((notesObj.avg_completion_percentage)))
        
        drawLineFromPoint(CGPoint(x: Double(self.rightMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.rightMiddleView), String(describing: notesObj.avg_completion_percentage))
    
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (NotesDetailObj?.student_view_info.count)!
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesDetailsTableCell", for: indexPath) as! NotesDetailsTableCell
        
        cell.lastVisitedLabel.text = (NotesDetailObj?.student_view_info[indexPath.row] as! Student_view_info).last_visited
        
        cell.nameLabel.text =  (NotesDetailObj?.student_view_info[indexPath.row] as! Student_view_info).fname
        
        cell.nameLabel.text =  cell.nameLabel.text! + (NotesDetailObj?.student_view_info[indexPath.row] as! Student_view_info).lname
        
        drawLineFromPoint(CGPoint(x: Double(cell.percentageView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (cell.percentageView), String(describing: (NotesDetailObj?.student_view_info[indexPath.row] as! Student_view_info).completion_percentage))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func readButtonTapped(_ sender: Any) {
  
        if(isExpanded == true)
        {
           
            self.upperViewHeightConstraint.constant = upperViewHeightConstraint.constant - self.viewHeightConstraint.constant
             self.viewHeightConstraint.constant = 0
            isExpanded = false
            self.readButton.setTitle("READ MORE", for: .normal)
        }
        else
        {
             self.viewHeightConstraint.constant = 128
            self.upperViewHeightConstraint.constant = upperViewHeightConstraint.constant + self.viewHeightConstraint.constant
            isExpanded = true
              self.readButton.setTitle("READ LESS", for: .normal)
            
        }
        
    }
    
    
    func drawFullCircle(end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, completionPercentage : Double)
    {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(20), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(M_PI/2 + M_PI*2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        //shapeLayer.lineDashPattern = [5 ,5]
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = circlePath.cgPath
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.lineWidth = 1.0
        // shapeLayer1.addSublayer(shapeLayer)
        
        let angle = completionPercentage * 3.6
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2), radius: CGFloat(20), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(((90 + angle)/180)*M_PI), clockwise: true)
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = circlePath1.cgPath
        // shapeLayer2.lineDashPattern = [5 ,5]
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.strokeColor = UIColor.white.cgColor
        shapeLayer2.lineWidth = 1.0
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = circlePath1.cgPath
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.strokeColor = UIColor.green.cgColor
        shapeLayer3.lineWidth = 1.0
        // shapeLayer3.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer3)
    }
    
    func drawLineFromPoint(_ end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, _ attendance_percentage: String) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: Double(view.frame.size.width ) * Double(attendance_percentage)!/100, y: 0))
        //
        //        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 10.0
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: view.frame.size.width, y: 0))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.lineWidth = 10.0
        //        shapeLayer1.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer)
    }
    
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        _ =   self.navigationController?.popViewController(animated: true)
    }
    

}
