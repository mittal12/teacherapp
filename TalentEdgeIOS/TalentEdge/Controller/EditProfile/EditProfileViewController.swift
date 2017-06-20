//
//  EditProfileViewController.swift
//  TalentEdge
//
//

import UIKit
import Alamofire
class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var phoneTextFieldOutlet: UITextField!
    @IBOutlet weak var userImageViewOutlet: UIImageView!
    @IBOutlet weak var nameBottomViewOutlet: UIView!
    @IBOutlet weak var emailBottomViewOutlet: UIView!
    @IBOutlet weak var phoneBottomViewOutlet: UIView!
    
    let imagePicker = UIImagePickerController()
    
    var profilePic : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFieldOutlet.text = ModelManager.singleton.loginData.resultData.user.fName + " " + ModelManager.singleton.loginData.resultData.user.lName
        phoneTextFieldOutlet.text = ModelManager.singleton.loginData.resultData.user.mobile_no
        emailTextFieldOutlet.text = ModelManager.singleton.loginData.resultData.user.email
        emailTextFieldOutlet.isUserInteractionEnabled = false
        userImageViewOutlet.sd_setImage(with: URL(string: ModelManager.singleton.loginData.resultData.user.avtar_url))
        //        DataUtils.addBackArrow(self.navigationItem, withTitle: "Edit Profile", target: self)
        userImageViewOutlet.setFAIconWithName(FAType.faChild, textColor: UIColor.black)
        // Do any additional setup after loading the view.
        loadUI()
    }
    
    fileprivate func loadUI() {
        userImageViewOutlet.sd_setImage(with: URL(string: ModelManager.singleton.loginData.resultData.user.avtar_url))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imageChangeButtonAction(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.accessibilityHint = String(format: "%d", sender.tag)
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePicked1 : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS",
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            ]
        
//        let queryParamHash = NSMutableDictionary()
//        queryParamHash.setValue(imagePicked1, forKey: "image")
        
        
        
        Alamofire.upload(multipartFormData: { (data) in
            
            if let imageData = UIImageJPEGRepresentation(imagePicked1, 1) {
                
                data.append(imageData, withName: "image", fileName: "profilePic.png", mimeType: "image/png")
                
//                data.appendBodyPart(data: imageData, name: "image", fileName: "profilePic.png", mimeType: "image/png")
            }
            
            // import parameters
            //            for (key, value) in parameters {
            //                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            //            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: API_URL + API_UPDATE_PROFILE, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let JSON  = response.result.value as? NSDictionary {
                        print("JSON: \(JSON)")
                        let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                         _ =   self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true) {                }
                        if JSON["message"] as! String == "Success" {
                            ModelManager.singleton.loginData.resultData.user.avtar_url = JSON["image"] as! String
                            self.loadUI()
                        }
                    }
                }
            case .failure(_):
                print("")
            }
        })
        
        
        
        
        
        
        
        
//        Alamofire.upload(.POST, API_URL + API_UPDATE_PROFILE, headers: headers, multipartFormData: { (data) in
//            
//            if let imageData = UIImageJPEGRepresentation(imagePicked1, 1) {
//                data.appendBodyPart(data: imageData, name: "image", fileName: "profilePic.png", mimeType: "image/png")
//            }
//            
//            // import parameters
//            //            for (key, value) in parameters {
//            //                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//            //            }
//            }, // you can customise Threshold if you wish. This is the alamofire's default value
//            encodingMemoryThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON { response in
//                        if let JSON  = response.result.value {
//                            print("JSON: \(JSON)")
//                            let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .Alert)
//                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                                self.navigationController?.popViewControllerAnimated(true)
//                            }
//                            alertController.addAction(OKAction)
//                            self.presentViewController(alertController, animated: true) {                }
//                            if JSON["message"] as! String == "Success" {
//                                ModelManager.singleton.loginData.resultData.user.avtar_url = JSON["image"] as! String
//                                self.loadUI()
//                            }
//                        }
//                    }
//                case .Failure(_):
//                    print("")
//                }
//        })
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func updateButtonAction(_ sender: AnyObject) {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS",
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
        ]
        let queryParamHash1 = NSMutableDictionary()
        queryParamHash1.setValue(nameTextFieldOutlet.text, forKey: "fname")
        queryParamHash1.setValue(" ", forKey: "lname")
        queryParamHash1.setValue(phoneTextFieldOutlet.text, forKey: "mobile")
        
        let queryParamHash = NSMutableDictionary()
        queryParamHash.setValue(DataUtils.jsonStringWithJSONObject(queryParamHash1)!, forKey: "profileData")
        
        
        ServerCommunication.singleton.requestWithPostToSendImages(API_UPDATE_PROFILE, headerDict: headers, param: queryParamHash, success: { (successResponseDict) in
            print(successResponseDict)
            let alertController = UIAlertController(title:"" , message:successResponseDict.value(forKey: "message") as? String , preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                //                if self.isCameFromOrder == true {
                //                    self.navigationController?.popToRootViewControllerAnimated(true)
                //                }else{
                self.navigationController?.popViewController(animated: true)
                //                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {                }
            } , failure: { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        })
        
    }
    
    //    Api/updateProfile
    
    //MARK:- UITextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        nameTextFieldOutlet.backgroundColor = textField.tag == 101 ? kBarButtonBottomSelectedColor : UIColor.darkGrayColor()
        //        phoneTextFieldOutlet.backgroundColor = textField.tag == 103 ? kBarButtonBottomSelectedColor : UIColor.darkGrayColor()
        animateViewMoving(true, moveValue: 80)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        nameTextFieldOutlet.backgroundColor = UIColor.darkGrayColor()
        //        phoneTextFieldOutlet.backgroundColor = UIColor.darkGrayColor()
        animateViewMoving(false, moveValue: 80)
    }
    
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
}
