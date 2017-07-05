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
    
    @IBOutlet weak var mostUpperView: UIView!
    
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var designationLabel: UILabel!
    
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    @IBOutlet weak var summaryView: UIView!
    
    
    @IBOutlet weak var experienceView: UIView!
    
    @IBOutlet weak var educationView: UIView!
    
    
    
    
    
    var userID :Int?
    var profileModel : ProfileModel = ProfileModel()
    var model1: [ProfileuserExperience]!
    var model2: [ProfileUserEducation]!
    var finalContentSize:Int = 0
    var yPoint = 25
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        self.userProfileImageView.layer.cornerRadius  = self.userProfileImageView.frame.size.height/2
        self.userProfileImageView.clipsToBounds = true
        self.sendMessageButton.layer.cornerRadius = self.sendMessageButton.frame.size.height/2
        self.sendMessageButton.layer.borderColor = UIColor.init(hexString: "2D9FF4").cgColor
        
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
            self.profileModel = (JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("ProfileModel"), jsonData: successResponseDict.value(forKey: "profileDetails") as! NSDictionary) as! ProfileModel)
            
            self.finalContentSize +=  Int(self.mostUpperView.frame.size.height)
            
            
            self.nameLabel.text = self.profileModel.name
             self.userProfileImageView.sd_setImage(with: URL(string: self.profileModel.pic))
            self.companyNameLabel.text = ""
            self.designationLabel.text = ""
            self.summaryLabel.text = ""
            if((successResponseDict["profileDetails"] as! NSDictionary)["profile_summary"] != nil )
            {
                self.summaryLabel.text = (successResponseDict["profileDetails"] as! [String:Any])["profile_summary"] as! String?
                self.summaryLabel.sizeToFit()
            }
            
            self.finalContentSize += Int(self.summaryView.frame.size.height)
            
            
            if(successResponseDict["userExperience"] != nil)
            {
                self.model1 = (JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("ProfileuserExperience"), jsonData: successResponseDict.value(forKey: "userExperience") as! NSArray) as! [ProfileuserExperience])
//              JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("TEAssessmentData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSArray) as! [TEAssessmentData]
                let y:Int = 20
//                
                
                
        for count in 0..<self.model1.count
        {
            var isBlack = true
            self.experienceView.addSubview(self.addLabel(y,true,(self.model1[count]).company))
            isBlack = false
            self.experienceView.addSubview(self.addLabel(y,false, (self.model1[count]).designation))
        
            let combinedString = (self.model1[count]).start_date + " - " + (self.model1[count]).end_date
           
            self.experienceView.addSubview( self.addLabel(y, false, combinedString))
            self.designationLabel.text  = self.model1[count].designation
            self.companyNameLabel.text = self.model1[count].company
            
       }
                
                self.experienceView.frame = CGRect(x: self.experienceView.frame.origin.x, y: self.experienceView.frame.origin.y, width: self.experienceView.frame.size.width, height: CGFloat(self.yPoint))
                
                self.mainScrollView.contentSize.height += self.experienceView.frame.size.height

            }

            self.yPoint = 25
            
            if(successResponseDict["userEducation"] != nil)
            {
                self.model2 = (JSONOBJECTPARSER.parseJsonArray(DataUtils.convertStringForAltaObjectParser("ProfileUserEducation"), jsonData: successResponseDict.value(forKey: "userEducation") as! NSArray) as! [ProfileUserEducation])
                
                /*
                 "university": "sskm university",
                 "degree": "mca",
                 "start_date": "2017-02-09",
                 "end_date": "2017-02-10"

 */
                var y:Int = 20
                for count in 0..<self.model2.count
                {
                    var isBlack = true
                    self.educationView.addSubview(self.addLabel(y,isBlack,(self.model2[count] ).university))
                    isBlack = false
                    self.educationView.addSubview(self.addLabel(y,isBlack, (self.model2[count]).degree));
                    
                    var combinedString = (self.model2[count]).start_date + " - " + (self.model2[count]).end_date
                    
                    self.educationView.addSubview( self.addLabel(y, isBlack, combinedString))
                    
                    
                }
                
                self.educationView.frame = CGRect(x: self.educationView.frame.origin.x, y: self.educationView.frame.origin.y, width: self.educationView.frame.size.width, height: CGFloat(self.yPoint))
                
                self.mainScrollView.contentSize.height += self.educationView.frame.size.height
            }

            
            
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
        var fromLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(yPoint), width: CGFloat(self.experienceView.frame.size.width-20), height: CGFloat(labelSize)))
        yPoint += Int(labelSize) + 15
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
    
  
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        _ =   self.navigationController?.popViewController(animated: true)
    }

    

}
