//
//  AddTestimonialViewController.swift
//  TalentEdge
//
//

import UIKit
import Alamofire
import MobileCoreServices
class AddTestimonialViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var batchNameLabel: UILabel!
    let imagePicker = UIImagePickerController()
    var videoURL : URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = ""
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonAction (_ sender : UIButton) {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS",
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            ]
        
        var parameters = [String : AnyObject]()
        //        parameters["batch_id"] =
        parameters["description"] = descriptionTextView.text as AnyObject?
        parameters["batch_id"] = String(format: "%d",self.selectedCourseObj.id.intValue) as AnyObject?
        
        //        let queryParamHash = NSMutableDictionary()
        //        queryParamHash.setValue(imagePicked1, forKey: "image")
        
        
        
        Alamofire.upload(multipartFormData: { (data) in
            
            if self.videoURL != nil {
                
                if let imageData = self.videoURL {
                    
                    data.append(imageData, withName: "file")
                    
//                    data.appendBodyPart(fileURL: imageData, name: "file")
                }
            }
            
            // import parameters
            for (key, value) in parameters {
//                data.appendBodyPart(data: value.dataUsingEncoding(String.Encoding.utf8)!, name: key)
                
                data.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: API_URL + API_ADD_TESTIMONIAL, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let JSON  = response.result.value {
                        print("JSON: \(JSON)")
                        //                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .Alert)
                        //                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        //                                    self.navigationController?.popViewControllerAnimated(true)
                        //                                }
                        //                                alertController.addAction(OKAction)
                        //                                self.presentViewController(alertController, animated: true) {                }
                    }
                }
            case .failure(_):
                print("")
            }
        })
        
        
        
        
        
        
        
        
//        Alamofire.upload(.POST, API_URL + API_ADD_TESTIMONIAL, headers: headers, multipartFormData: { (data) in
//            
//            if self.videoURL != nil {
//            
//            if let imageData = self.videoURL {
//                data.appendBodyPart(fileURL: imageData, name: "file")
//            }
//            }
//            
//            // import parameters
//            for (key, value) in parameters {
//                data.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//            }
//            }, // you can customise Threshold if you wish. This is the alamofire's default value
//            encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON { response in
//                        if let JSON  = response.result.value {
//                            print("JSON: \(JSON)")
//                            //                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .Alert)
//                            //                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                            //                                    self.navigationController?.popViewControllerAnimated(true)
//                            //                                }
//                            //                                alertController.addAction(OKAction)
//                            //                                self.presentViewController(alertController, animated: true) {                }
//                        }
//                    }
//                case .Failure(_):
//                    print("")
//                }
//        })
    }
    
    @IBAction func addFileButtonAction (_ sender : UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeAVIMovie as String, kUTTypeVideo as String, kUTTypeMPEG4 as String]
        imagePicker.delegate = self
        imagePicker.accessibilityHint = String(format: "%d", sender.tag)
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let imagePicked1 : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        videoURL = info["UIImagePickerControllerReferenceURL"] as? URL
        
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS",
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            ]
        
        var parameters = [String : AnyObject]()
//        parameters["batch_id"] =
            parameters["description"] = descriptionTextView.text as AnyObject?
            parameters["batch_id"] = String(format: "%d",self.selectedCourseObj.id.intValue) as AnyObject?
            
            //        let queryParamHash = NSMutableDictionary()
            //        queryParamHash.setValue(imagePicked1, forKey: "image")
        
        Alamofire.upload(multipartFormData: { (data) in
            
            if let imageData = self.videoURL  {
                data.append(imageData, withName: "file")
//                data.appendBodyPart(fileURL: imageData, name: "file")
            }
            
            // import parameters
            for (key, value) in parameters {
                data.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                data.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: API_URL + API_ADD_TESTIMONIAL, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let JSON  = response.result.value {
                        print("JSON: \(JSON)")
                        //                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .Alert)
                        //                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        //                                    self.navigationController?.popViewControllerAnimated(true)
                        //                                }
                        //                                alertController.addAction(OKAction)
                        //                                self.presentViewController(alertController, animated: true) {                }
                    }
                }
            case .failure(_):
                print("")
            }
        })
        
        
        
        
        
//            Alamofire.upload(.POST, API_URL + API_ADD_TESTIMONIAL, headers: headers, multipartFormData: { (data) in
//                
//                if let imageData = self.videoURL  {
//                    data.appendBodyPart(fileURL: imageData, name: "file")
//                }
//                
//                // import parameters
//                            for (key, value) in parameters {
//                                data.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//                            }
//                }, // you can customise Threshold if you wish. This is the alamofire's default value
//                encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
//                encodingCompletion: { encodingResult in
//                    switch encodingResult {
//                    case .Success(let upload, _, _):
//                        upload.responseJSON { response in
//                            if let JSON  = response.result.value {
//                                print("JSON: \(JSON)")
////                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .Alert)
////                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
////                                    self.navigationController?.popViewControllerAnimated(true)
////                                }
////                                alertController.addAction(OKAction)
////                                self.presentViewController(alertController, animated: true) {                }
//                            }
//                        }
//                    case .Failure(_):
//                        print("")
//                    }
//            })
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextView Delegate Methads.
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
         return true
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonAction (_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
