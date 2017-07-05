//
//  AssignmentDetailViewController.swift
//  TalentEdge
//
//

import UIKit
import CoreData
import Alamofire
class AssignmentDetailViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var assignmentTitleLabel: UILabel!
    @IBOutlet weak var assignmentTimeLabel: UILabel!
    @IBOutlet weak var assignmentTypeLabel: UILabel!
    @IBOutlet weak var assignmentModeLabel: UILabel!
    @IBOutlet weak var assignmentMultipleSubLabel: UILabel!
    @IBOutlet weak var assignmentSubLastDateLabel: UILabel!
    @IBOutlet weak var assignmentDescLabel: UITextView!
    @IBOutlet weak var assignmentReviewButton: UIButton!
    @IBOutlet weak var assignmentDownloadButton: UIButton!
    
    @IBOutlet weak var assignmentMaxMarksLabel: UILabel!
    @IBOutlet weak var assignmentMinMarksLabel: UILabel!
    @IBOutlet weak var assignmentcopyImage: UIImageView!
    @IBOutlet weak var assignmentbottomArrowImage: UIImageView!
    var assignmentDetailObj : TEAssignmentDetail!
    let imagePicker = UIImagePickerController()
    var moduleData : TEModuleDetailData!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    var documentInteractionController : UIDocumentInteractionController!
    var selectedImageArray = [UIImage]()
    var assignmentData : Assignment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataUtils.addBackArrow(self.navigationItem, withTitle: "ASSIGNMENT", target: self)
        // Do any additional setup after loading the view.
        loadUI()
        fetchDataFromMemory()
    }
    
    fileprivate func fetchDataFromMemory () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Assignment")
        fetchRequest.predicate = NSPredicate(format: "name == %@", String(format : "%d",self.assignmentDetailObj.Content.id.intValue))
        do {
            let dataArray = try managedContext.fetch(fetchRequest)
            if dataArray.count != 0 {
                assignmentDownloadButton.setTitle("View", for: UIControlState())
                for i in 0..<dataArray.count {
                    print((dataArray[i] as! Assignment).name ?? "")
                    assignmentData = dataArray[i] as! Assignment
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    fileprivate func loadUI() {
        subNavTitleLabel.text = moduleData == nil ? assignmentDetailObj.Module.name : moduleData.module_name
        assignmentTitleLabel.text = assignmentDetailObj.Content.title
        //        assignmentTimeLabel.text = assignmentDetailObj.Content.start_date_label + ":" + assignmentDetailObj.Content.start_date
        
        let yourAttributes = [NSForegroundColorAttributeName: kGrayColor]
        let partTwo = NSMutableAttributedString(string: assignmentDetailObj.Content.start_date_label)
        let partFour = NSMutableAttributedString(string: assignmentDetailObj.Content.start_date, attributes: yourAttributes)
        
        let combination = NSMutableAttributedString()
        combination.append(partTwo)
        combination.append(NSAttributedString(string: ": "))
        combination.append(partFour)
        assignmentTimeLabel.attributedText = combination
        
        
        assignmentDescLabel.text = assignmentDetailObj.Content.desc
        assignmentModeLabel.text = assignmentDetailObj.Assignment.submission_mode
        assignmentTypeLabel.text = assignmentDetailObj.Assignment.is_graded
        assignmentMultipleSubLabel.text = String(format: "%@", assignmentDetailObj.Assignment.allowed_multiple.boolValue as CVarArg)
        assignmentMaxMarksLabel.text = String(format: "%d", assignmentDetailObj.Assignment.total_marks.intValue)
        assignmentMinMarksLabel.text = String(format: "%d", assignmentDetailObj.Assignment.passing_marks.intValue)
        assignmentSubLastDateLabel.text = assignmentDetailObj.Content.end_date
        //        assignmentbottomArrowImage.setFAIconWithName(FAType.FAArrowDown, textColor: UIColor.grayColor())
        //        assignmentcopyImage.setFAIconWithName(FAType.FACopy, textColor: UIColor.grayColor())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let imagePicked1 : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //        if picker.accessibilityHint == "0" {
        //            imageDict["passport"] = imagePicked1
        //        }else if picker.accessibilityHint == "1" {
        //            imageDict["flight_ticket"] = imagePicked1
        //        }else if picker.accessibilityHint == "2" {
        //            imageDict["visa"] = imagePicked1
        //        }else if picker.accessibilityHint == "3" {
        //            imageDict["currency_declaration"] = imagePicked1
        //        }
        //
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func downloadAssignmentButtonAction(_ sender: AnyObject) {
        
        if assignmentData == nil {
            let request = NSMutableURLRequest(url: URL(string: assignmentDetailObj.Content.content_path)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
            request.httpMethod = "GET"
            DataUtils.addLoadIndicator()
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                DispatchQueue.main.async(execute: {
                    DataUtils.removeLoadIndicator()
                    if error == nil {
                        DataUtils.saveAssignment(data!, name : String(format : "%d",self.assignmentDetailObj.Content.id.intValue) , entityName : "Assignment")
                        self.fetchDataFromMemory()
                    }
                });
            }).resume()
        }else{
            guard let documentURL = Bundle.main.resourceURL?.appendingPathComponent("Document.pdf") else { return }
            let webViewController = WebViewController()
            let mimeType = assignmentDetailObj.Content.content_path.contains("pptx") == true ? "application/vnd.openxmlformats-officedocument.presentationml.presentation" : assignmentDetailObj.Content.content_path.contains("pdf") == true ? "application/pdf" : "application/msword"

            webViewController.webView.load(assignmentData.file! as Data, mimeType: mimeType, textEncodingName: "", baseURL: documentURL.deletingLastPathComponent())
            let navigationController = UINavigationController(rootViewController: webViewController)
            // Add a close button that dismisses the web view controller.
            webViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissController(_:)))
            // Present the document.
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc
    fileprivate func dismissController(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func uploadAssignmentButtonAction(_ sender: AnyObject) {
        let pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        pickerController.allowsLandscape = false
        pickerController.allowMultipleTypes = true
        pickerController.sourceType = .both
        pickerController.singleSelect = true
        
        let assets: [DKAsset]? = []
        
        pickerController.defaultSelectedAssets = assets
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            for asset in assets {
                asset.fetchImageWithSize(CGSize(width: 400, height: 400), completeBlock: { image, info in
                    self.selectedImageArray.append(image!)
                    self.sendImageToServer()
                })
            }
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        self.present(pickerController, animated: true) {}
        
        
    }
    
    func sendImageToServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS",
                            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
        ]
        print(headers)
        
        DataUtils.addLoadIndicator()
        if selectedImageArray.count != 0 {
            var parameter = [String : AnyObject]()
            
            parameter["content_id"] = String(format: "%d",assignmentDetailObj.Content.id.intValue) as AnyObject?
            
            
            
            Alamofire.upload(multipartFormData: { (data) in
                
                if let imageData = UIImageJPEGRepresentation(self.selectedImageArray[0], 1) {
                    data.append(imageData, withName: "uploaded_path", fileName: "profilePic.png", mimeType: "image/png")
                    
//                    data.appendBodyPart(data: imageData, name: "uploaded_path", fileName: "profilePic.png", mimeType: "image/png")
                }
                
                
                for (key, value) in parameter {
                    data.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: API_URL + API_UPLOAD_ASSIGNMENT, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        DataUtils.removeLoadIndicator()
                        if let JSON  = response.result.value as? NSDictionary{
                            print("JSON: \(JSON)")
                            if (JSON["code"] as? NSNumber)?.intValue == 100 {
                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                 _ =   self.navigationController?.popViewController(animated: true)
                                }
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true) {                }
                            }else {
                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                }
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true) {                }
                            }
                        }
                    }
                case .failure(_):
                    print("")
                }
            })
            
            
            
//            Alamofire.upload(.POST, API_URL + API_UPLOAD_ASSIGNMENT, headers: headers, multipartFormData: { (data) in
//                
//                    if let imageData = UIImageJPEGRepresentation(self.selectedImageArray[0], 1) {
//                        data.appendBodyPart(data: imageData, name: "uploaded_path", fileName: "profilePic.png", mimeType: "image/png")
//                }
//                
//                
//                for (key, value) in parameter {
//                    data.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//                }
//                },
//                             encodingMemoryThreshold: SessionManager.MultipartFormDataEncodingMemoryThreshold,
//                             encodingCompletion: { encodingResult in
//                                switch encodingResult {
//                                case .Success(let upload, _, _):
//                                    upload.responseJSON { response in
//                                        DataUtils.removeLoadIndicator()
//                                        if let JSON  = response.result.value {
//                                            print("JSON: \(JSON)")
//                                            if (JSON["code"] as? NSNumber)?.integerValue == 100 {
//                                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .Alert)
//                                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                                                    self.navigationController?.popViewControllerAnimated(true)
//                                                }
//                                                alertController.addAction(OKAction)
//                                                self.presentViewController(alertController, animated: true) {                }
//                                            }else {
//                                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .Alert)
//                                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                                                }
//                                                alertController.addAction(OKAction)
//                                                self.presentViewController(alertController, animated: true) {                }
//                                            }
//                                        }
//                                    }
//                                case .Failure(_):
//                                    print("")
//                                }
//            })
            

    }
    }
}
