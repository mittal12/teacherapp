//
//  UserProfileViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 24/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
  //  @IBOutlet weak var mostUpperView: UIView!
    
    
   // @IBOutlet weak var userProfileImageView: UIImageView!
    
   // @IBOutlet weak var nameLabel: UILabel!
    
    
 //   @IBOutlet weak var designationLabel: UILabel!
    
    
  //  @IBOutlet weak var companyNameLabel: UILabel!
    
    
   // @IBOutlet weak var sendMessageButton: UIButton!
    
   // @IBOutlet weak var summaryLabel: UILabel!
    
    
   // @IBOutlet weak var summaryView: UIView!
    var experienceView:UIView!
    var educationView:UIView!
    
 //   @IBOutlet weak var experienceView: UIView!
    
  //  @IBOutlet weak var educationView: UIView!
    
  //  @IBOutlet weak var experienceViewHeightConstraint: NSLayoutConstraint!
    
  //  @IBOutlet weak var educationViewHeightConstraint: NSLayoutConstraint!
    
   // @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var userID :Int?
    var profileModel : ProfileModel = ProfileModel()
    var model1: [ProfileuserExperience]!
    var model2: [ProfileUserEducation]!
    var finalContentSize:Int = 0
    var yPoint = 10
    
    //var succ  essResponseDict: NSDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        //self.userProfileImageView.layer.cornerRadius  = self.userProfileImageView.frame.size.height/2
        //self.userProfileImageView.clipsToBounds = true
        //self.sendMessageButton.layer.cornerRadius = self.sendMessageButton.frame.size.height/2
       // self.sendMessageButton.layer.borderColor = UIColor.init(hexString: //"2D9FF4").cgColor
       // self.sendMessageButton.layer.borderWidth  = 3
        self.mainScrollView.isHidden = true
       // self.view.removeConstraint(self.bottomConstraint)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetctDataFromServer()
        
    }
    
    fileprivate func fetctDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "user_id=%d",self.userID!)
        ServerCommunication.singleton.requestWithPost(API_PROFILE_DETAILS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            
            self.mainScrollView.isHidden = false

            self.profileModel = (JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("ProfileModel"), jsonData: successResponseDict.value(forKey: "profileDetails") as! NSDictionary) as! ProfileModel)
            
            
            
    var firstView = Bundle.main.loadNibNamed("SummaryUpperView", owner: self, options: nil)?[0] as? UIView as! SummaryUpperView?
            firstView?.layer.cornerRadius = 3
        
            firstView?.nameLabel.text = self.profileModel.name
            firstView?.userProfileImageView.sd_setImage(with: URL(string: self.profileModel.pic))
            firstView?.companyNameLabel.text = ""
            firstView?.designationLabel.text = ""
            
            
            firstView?.userProfileImageView.layer.cornerRadius  = (firstView?.userProfileImageView.frame.size.height)!/2
            firstView?.userProfileImageView.clipsToBounds = true
            firstView?.sendMessageButton.layer.cornerRadius = (firstView?.sendMessageButton.frame.size.height)!/2
             firstView?.sendMessageButton.layer.borderColor = UIColor.init(hexString: "2D9FF4").cgColor
             firstView?.sendMessageButton.layer.borderWidth  = 3

            firstView?.userProfileImageView.frame = CGRect(x: self.view.center.x, y: 10, width: (firstView?.userProfileImageView.frame.size.width)!, height: (firstView?.userProfileImageView.frame.size.height)!)
              firstView?.userProfileImageView.center.x  = self.view.center.x
        let h1 = DataUtils.getDynamicHeightLabel((firstView?.nameLabel.text)!, width: self.view.frame.size.width-20,fontSize: 17)
            firstView?.nameLabel.frame = CGRect(x: self.view.frame.origin.x, y: (firstView?.userProfileImageView.frame.origin.y)! + (firstView?.userProfileImageView.frame.size.height)! + 10, width: self.view.frame.size.width-20, height: h1)
            
            if(successResponseDict["userExperience"] != nil)
                {
                    self.model1 = (JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("ProfileuserExperience"), jsonData: successResponseDict.value(forKey: "userExperience") as! NSArray) as! [ProfileuserExperience])
                 
                    
                    if(self.model1.count != 0)
                    {
                        firstView?.designationLabel.text  = self.model1[self.model1.count-1].designation
                        
                        var h = DataUtils.getDynamicHeightLabel(self.model1[self.model1.count-1].designation, width: self.view.frame.size.width-20,fontSize: 17)
                        
                        firstView?.designationLabel.frame = CGRect(x: (firstView?.designationLabel.frame.origin.x)!, y:(firstView?.nameLabel.frame.origin.y)! + (firstView?.nameLabel.frame.size.height)! + 10 , width: self.view.frame.size.width-20, height: h)
                        firstView?.designationLabel.center.x = (firstView?.nameLabel.center.x)!
                        
                     
                        firstView?.companyNameLabel.text  = self.model1[self.model1.count-1].company
                        
                        h = DataUtils.getDynamicHeightLabel(self.model1[self.model1.count-1].company, width: self.view.frame.size.width-20,fontSize: 17)
                        firstView?.companyNameLabel.frame = CGRect(x: (firstView?.companyNameLabel.frame.origin.x)!, y:(firstView?.designationLabel.frame.origin.y)! + (firstView?.designationLabel.frame.size.height)! + 10 , width: self.view.frame.size.width-20, height: h)
                        
            firstView?.companyNameLabel.center.x = (firstView?.center.x)!
                        
                        firstView?.sendMessageButton.frame = CGRect(x:                         (firstView?.sendMessageButton.frame.origin.x)!, y: (firstView?.companyNameLabel.frame.origin.y)! + ((firstView?.companyNameLabel.frame.size.height)! + 10)  , width:                         (firstView?.sendMessageButton.frame.size.width)!, height: (firstView?.sendMessageButton.frame.size.height)!)
                            firstView?.sendMessageButton.center.x = (firstView?.nameLabel.center.x)!
                        
                        
                       self.mainScrollView.addSubview(firstView!)
                        firstView?.backgroundColor = .white
                        firstView?.frame = CGRect(x: 10, y: 10, width: self.view.frame.size.width-20, height: (firstView?.sendMessageButton.frame.size.height)! + (firstView?.sendMessageButton.frame.origin.y)! + 20)

                    }
                        
            }
                    else
                    {
                   firstView?.designationLabel.text = ""
                    firstView?.companyNameLabel.text = ""
                    firstView?.sendMessageButton.frame = CGRect(x: (firstView?.sendMessageButton.frame.origin.x)!, y: (firstView?.designationLabel.frame.origin.y)! + (firstView?.designationLabel.frame.size.height)! , width: (firstView?.sendMessageButton.frame.size.width)!, height: (firstView?.sendMessageButton.frame.size.height)!)
              
                    self.mainScrollView.addSubview(firstView!)
                    firstView?.frame = CGRect(x: 10, y: 10, width: self.view.frame.size.width-20, height: (firstView?.sendMessageButton.frame.size.height)! + (firstView?.sendMessageButton.frame.origin.y)! + 20)
                       
                    }
        
            
            var secondView :SummaryMiddleView?
           // firstView.summaryLabel.text = ""
            if((successResponseDict["profileDetails"] as! NSDictionary)["profile_summary"] != nil )
            {
                
                
                 secondView = Bundle.main.loadNibNamed("SummaryMiddleView", owner: self, options: nil)?[0] as? UIView as! SummaryMiddleView?
                secondView?.layer.cornerRadius = 3
                
                if let va = (successResponseDict["profileDetails"] as! [String:Any])["profile_summary"] as? NSNull
                {
                    
                }
                else{
                secondView?.summaryLabel.text =  (successResponseDict["profileDetails"] as! [String:Any])["profile_summary"] as? String
                
              //  secondView?.frame = CGRect()
                
//                se.summaryLabel.text = (successResponseDict["profileDetails"] as! [String:Any])["profile_summary"] as! String?
                let h = DataUtils.getDynamicHeight(((successResponseDict["profileDetails"] as! [String:Any])["profile_summary"] as! String?)!, width: self.view.frame.size.width-20)
                
            secondView?.summaryLabel.frame = CGRect(x: (secondView?.summaryLabel.frame.origin.x)!, y: (secondView?.summaryLabel.frame.origin.y)! , width: self.view.frame.size.width-20, height: h)
                
                secondView?.summaryLabel.sizeToFit()
                
                
             self.mainScrollView.addSubview(secondView!)
            secondView?.frame = CGRect(x: 10, y: (firstView?.frame.size.height)! + (firstView?.frame.origin.y)! + 20, width: self.view.frame.size.width-20, height: (secondView?.summaryLabel.frame.size.height)! + (secondView?.summaryLabel.frame.origin.y)! + 20)
                
            }
            }
//            self.finalContentSize += Int(self.summaryView.frame.size.height)
//            self.summaryView.frame = CGRect(x: self.summaryView.frame.origin.x, y: self.summaryView.frame.origin.y , width: self.summaryView.frame.size.width, height:  DataUtils.getDynamicHeight(self.summaryLabel.text!,width: self.summaryView.frame.size.width-20) + 20)
//            self.mainScrollView.contentSize.width = self.view.frame.size.width
//            self.mainScrollView.contentSize.height = self.summaryView.frame.origin.y + self.summaryView.frame.size.height
//            
            let y:Int = 20
            
            
            //        let v1 = UIView(frame: CGRect(x:self.mainScrollView.frame.origin.x ,y: self.su   ))
            
            if(successResponseDict["userExperience"] != nil)
            {
                self.model1 = (JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("ProfileuserExperience"), jsonData: successResponseDict.value(forKey: "userExperience") as! NSArray) as! [ProfileuserExperience])
                //              JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEAssessmentData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEAssessmentData]
                //
                
                self.experienceView = UIView(frame: CGRect(x: (secondView?.frame.origin.x)!, y: ((secondView?.frame.origin.y)! + (secondView?.frame.size.height)! + 10 ), width: (secondView?.frame.size.width)!, height: CGFloat(40)))
                self.experienceView.layer.cornerRadius = 3
                self.experienceView.backgroundColor = .white
                
            self.experienceView.addSubview(self.addLabel(y,true,"EXPERIENCE"))
                
                for count in 0..<self.model1.count
                {
                    //print(self.yPoint)
                    self.experienceView.addSubview(self.addLabel(y,true,(self.model1[count]).company))
                  //  print(self.yPoint)
                    
                    self.experienceView.addSubview(self.addLabel(y,false, (self.model1[count]).designation))
                    //print(self.yPoint)
                    
                    let combinedString = (self.model1[count]).start_date + " - " + (self.model1[count]).end_date
                    
                    self.experienceView.addSubview( self.addLabel(y, false, combinedString))
                    //print(self.yPoint)
                    
                  //  self.designationLabel.text  = self.model1[count].designation
                    //self.companyNameLabel.text = self.model1[count].company
                    
                }
                //   self.experienceViewHeightConstraint.constant = CGFloat(self.yPoint)
                self.mainScrollView.addSubview(self.experienceView)
                self.experienceView.frame = CGRect(x: self.experienceView.frame.origin.x, y: self.experienceView.frame.origin.y, width: self.experienceView.frame.size.width, height: CGFloat(self.yPoint) + 20)
                
                self.mainScrollView.contentSize.height = self.experienceView.frame.origin.y + self.experienceView.frame.size.height
                
            }
            
            self.yPoint = 10
            
            if(successResponseDict["userEducation"] != nil)
            {
                
                
                self.educationView = UIView(frame: CGRect(x: self.experienceView.frame.origin.x, y: self.experienceView.frame.origin.y + self.experienceView.frame.size.height + 10 , width: self.experienceView.frame.size.width, height: CGFloat(40)))
                self.educationView.layer.cornerRadius = 3
                self.educationView.backgroundColor = .white
                self.educationView.addSubview(self.addLabel(y,true,"EDUCATION"))

                self.model2 = (JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("ProfileUserEducation"), jsonData: successResponseDict.value(forKey: "userEducation") as! NSArray) as! [ProfileUserEducation])
                
                /*
                 "university": "sskm university",
                 "degree": "mca",
                 "start_date": "2017-02-09",
                 "end_date": "2017-02-10"
                 
                 */
                
                
                
               // let y:Int = 20
                
                for count in 0..<self.model2.count
                {
                    var isBlack = true
                    self.educationView.addSubview(self.addLabel(y,isBlack,(self.model2[count] ).university))
                    isBlack = false
                    self.educationView.addSubview(self.addLabel(y,isBlack, (self.model2[count]).degree));
                    
                    let combinedString = (self.model2[count]).start_date + " - " + (self.model2[count]).end_date
                    
                    self.educationView.addSubview( self.addLabel(y, isBlack, combinedString))
                    
                    
                }
                // self.educationViewHeightConstraint.constant = CGFloat(self.yPoint)
                self.mainScrollView.addSubview(self.educationView)
                self.educationView.frame = CGRect(x: self.educationView.frame.origin.x, y: self.educationView.frame.origin.y, width: self.educationView.frame.size.width, height: CGFloat(self.yPoint + 20))
                
                
                self.mainScrollView.contentSize.height = self.educationView.frame.origin.y + self.educationView.frame.size.height
                
            }
            

            
         //   self.finalContentSize +=  Int(self.mostUpperView.frame.size.height)
            

            
            
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    func addLabel(_ y:Int,_ isBlack:Bool,_ textForInput: String) ->UILabel{
//    {
        
        var customFont :UIFont
        if(isBlack == true){
            customFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(12))!
            
        }
    else
        {
            customFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!

        }
        //custom font
        let text: String = textForInput
//        var labelSize = text.size(with: customFont, constrainedToSize: CGSize(width: CGFloat(self.experienceView.frame.size.width-20), height: CGFloat(20)), lineBreakMode:.byTruncatingTail)

        let labelSize = DataUtils.getDynamicHeight(text,width: self.experienceView.frame.size.width-20)
        let fromLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(yPoint), width: CGFloat(self.experienceView.frame.size.width-20), height: CGFloat(labelSize)))
        yPoint += Int(labelSize) + 10
        fromLabel.text = text
        fromLabel.font = customFont
        fromLabel.sizeToFit()
        //fromLabel.baselineAdjustment = .alignBaselines
        // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
        //fromLabel.adjustsFontSizeToFitWidth = true
        //fromLabel.adjustsLetterSpacingToFitWidth = true
       // fromLabel.minimumScaleFactor = 10.0 / 12.0
        fromLabel.clipsToBounds = true
        fromLabel.backgroundColor = UIColor.clear
        if(isBlack){
        fromLabel.textColor = UIColor.black
        }
        else
        {
        fromLabel.textColor = UIColor.init(hexString:"707070")
        }
        fromLabel.textAlignment = .left

        return fromLabel
        
    }
    func adjustTheView()
    {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.adjustTheView()
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        _ =   self.navigationController?.popViewController(animated: true)
    }
}
