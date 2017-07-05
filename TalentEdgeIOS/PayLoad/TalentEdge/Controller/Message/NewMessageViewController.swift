//
//  NewMessageViewController.swift
//  TalentEdge
//
//

import UIKit
import Alamofire

class NewMessageViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var newMessageTableView: UITableView!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var attachmentButtonOutlet: UIButton!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    @IBOutlet weak var optionsButtonOutlet: UIButton!
    let imagePicker = UIImagePickerController()
    
    var selectedBatch = TEBatchData()
    var selectedRecipientArray = [TEStudentData]()
    var bachmateData : TEBatchmateData!
    var raiseADoubt = Bool()
    var desc = "Enter message here."
    var subject = "Subject"
    var selectedImage = UIImage()
    var selectedImageArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //        DataUtils.addBackArrowWithTwoCustomButton(self.navigationItem, withTitle: "New Message", target: self)
        selectedBatch.id = NSNumber()
        selectedBatch.name = "All Batches"
//        backButtonOutlet.setFAIcon(FAType.FAArrowLeft, forState: .Normal)
        optionsButtonOutlet.setFAIcon(FAType.faEllipsisH, forState: UIControlState())
        attachmentButtonOutlet.setFAIcon(FAType.faFile, forState: UIControlState())
        sendButtonOutlet.setFAIcon(FAType.faSend, forState: UIControlState())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.navigationController?.navigationBarHidden = true
        if bachmateData != nil {
            for i in 0..<bachmateData.student.count {
                let studentObj : TEStudentData = bachmateData.student[i] as! TEStudentData
                if studentObj.isSelected == true {
                    self.selectedRecipientArray.append(studentObj)
                }
            }
            for i in 0..<bachmateData.faculty.count {
                let studentObj : TEStudentData = bachmateData.faculty[i] as! TEStudentData
                if studentObj.isSelected == true {
                    self.selectedRecipientArray.append(studentObj)
                }
            }
        }
        newMessageTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonAction(_ sender: AnyObject) {
        
        var arr = [String]()
        
        for item in selectedRecipientArray {
            arr.append(String(format: "%d",item.id.intValue))
        }
        
        //        if selectedImageArray.count == 0 {
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS",
            //                "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
        ]
        
        if selectedImageArray.count != 0 {
            var str = ""
            for i in 0..<selectedImageArray.count {
                str = String(format:  "file%d",i + 1) + "," + str
            }
            var parameter = [String : AnyObject]()
            
            parameter["subject"] = subject as AnyObject?
            parameter["message"] = desc as AnyObject?
            parameter["to_id"] = DataUtils.jsonStringWithJSONObject(arr as AnyObject)! as AnyObject?
            parameter["batch_id"] = String(format: "%d",selectedBatch.id.intValue) as AnyObject?
            
            
            let raiseDoubt: Int = raiseADoubt ? 1 : 0 as Int
            parameter["is_doubt"] = String(format: "%d",raiseDoubt) as AnyObject?
            

            parameter["file"] = "[" + str.removeCharsFromEnd(1) + "]" as AnyObject?
            
            
            Alamofire.upload(multipartFormData: { (data) in
                
                for i in 0..<self.selectedImageArray.count {
                    if let imageData = UIImageJPEGRepresentation(self.selectedImageArray[i], 1) {
                        data.append(imageData, withName: String(format:  "file%d",i + 1), fileName: "profilePic.png", mimeType: "image/png")
                        
//                        data.appendBodyPart(data: imageData, name: String(format:  "file%d",i + 1), fileName: "profilePic.png", mimeType: "image/png")
                    }
                    //                    queryParamHash.setValue(selectedImageArray[i], forKey: String(format:  "file%d",i + 1))
                }
                
                
                for (key, value) in parameter {
//                    data.append(value.dataUsingEncoding(String.Encoding.utf8)!, withName: key)
                    
                    data.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                    data.appendBodyPart(data: value.dataUsingEncoding(String.Encoding.utf8)!, name: key)
                }
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: API_URL + API_SEND_MESSAGE, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let JSON  = response.result.value as? NSDictionary{
                            print("JSON: \(JSON)")
                            if (JSON["code"] as? NSNumber)?.intValue == 100 {
                                let alertController = UIAlertController(title:"" , message:JSON["message"] as? String , preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                _ =    self.navigationController?.popViewController(animated: true)
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
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
//            Alamofire.upload(.POST, API_URL + API_SEND_MESSAGE, headers: headers, multipartFormData: { (data) in
//                
//                for i in 0..<self.selectedImageArray.count {
//                    if let imageData = UIImageJPEGRepresentation(self.selectedImageArray[i], 1) {
//                        data.appendBodyPart(data: imageData, name: String(format:  "file%d",i + 1), fileName: "profilePic.png", mimeType: "image/png")
//                    }
//                    //                    queryParamHash.setValue(selectedImageArray[i], forKey: String(format:  "file%d",i + 1))
//                }
//                
//                
//                for (key, value) in parameter {
//                    data.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//                }
//                },
//                             encodingMemoryThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
//                             encodingCompletion: { encodingResult in
//                                switch encodingResult {
//                                case .Success(let upload, _, _):
//                                    upload.responseJSON { response in
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

        }else {
            let str1 = String(format: "subject=%@&",subject)
            let str2 = String(format: "message=%@&",desc)
                    let str3 = String(format: "batch_id=%d&",selectedBatch.id.intValue)
            let str4 = String(format: "to_id=%@&",DataUtils.jsonStringWithJSONObject(arr as AnyObject)!)
            let str5 = String(format: "is_doubt=%d",raiseADoubt ? 1 : 0)
            
            ServerCommunication.singleton.requestWithPost(API_SEND_MESSAGE ,headerDict: headers, postString: str1 + str2 + str4 + str3 + str5, success: { (successResponseDict) -> Void in
                let alertController = UIAlertController(title: "Do you want to Logout?", message:"", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in }
                alertController.addAction(cancelAction)
                let OKAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                  _ =  self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true) { }
            }) { (errorResponseDict) -> Void in
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }
        }
    }
    
    @IBAction func attachmentButtonAction(_ sender: AnyObject) {
        //        imagePicker.allowsEditing = false
        //        imagePicker.delegate = self
        //        imagePicker.sourceType = .PhotoLibrary
        //        imagePicker.accessibilityHint = String(format: "%d", sender.tag)
        //        presentViewController(imagePicker, animated: true, completion: nil)
        let pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        pickerController.allowsLandscape = false
        pickerController.allowMultipleTypes = true
        pickerController.sourceType = .both
        pickerController.singleSelect = false
        
        let assets: [DKAsset]? = nil
        
        pickerController.defaultSelectedAssets = assets
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            for asset in assets {
                asset.fetchImageWithSize(CGSize(width: 400, height: 400), completeBlock: { image, info in
                    self.selectedImageArray.append(image!)
                })
            }
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        self.present(pickerController, animated: true) {}
        
        
    }
    
    @IBAction func optionButtonAction(_ sender: AnyObject) {
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePicked1 : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
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
        selectedImage = imagePicked1
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    fileprivate func fetctRecipientListFromServer () {
        if selectedBatch.name == "All Batches" {
            
            
            return
        }
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "batch_id=%d",self.selectedBatch.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_GET_BATCHMATES_LIST ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.bachmateData = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TEBatchmateData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TEBatchmateData
            //            self.batchmateTableView.reloadData()
            let vc : SelectRecipientViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectRecipientViewController") as! SelectRecipientViewController
            vc.bachmateData = self.bachmateData
            vc.selectedRecipientArray = self.selectedRecipientArray
            self.present(vc, animated: true, completion: nil)
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
        
    }
    
    
    @IBAction func buttonAction(_ sender: AnyObject) {
        
        //        switch sender.tag {
        //        case 101:
        //            buttonView1.backgroundColor = kBarButtonBottomSelectedColor
        //            button1.setTitleColor(kBarButtonBottomSelectedColor, forState: .Normal)
        //            let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyCourseViewController") as! MyCourseViewController
        //            featuredVC.view.frame = mainSubView.bounds
        //            featuredVC.view.tag = 9998
        //            self.addChildViewController(featuredVC)
        //            self.mainSubView.addSubview(featuredVC.view)
        //
        //        case 102:
        //            buttonView2.backgroundColor = kBarButtonBottomSelectedColor
        //            button2.setTitleColor(kBarButtonBottomSelectedColor, forState: .Normal)
        //            let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FeaturedCoursesViewController") as! FeaturedCoursesViewController
        //            featuredVC.view.frame = mainSubView.bounds
        //            featuredVC.view.tag = 9998
        //            //            commonTableView.selectionDelegate = self
        //            self.addChildViewController(featuredVC)
        //            self.mainSubView.addSubview(featuredVC.view)
        //
        //        default:
        //            buttonView1.backgroundColor = kBarButtonBottomSelectedColor
        //        }
    }
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessageTableCell1", for: indexPath) as! NewMessageTableCell1
            cell.titleLabel.text = selectedBatch.name
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessageTableCell2", for: indexPath) as! NewMessageTableCell2
            if selectedRecipientArray.count == 0 {
                cell.titleTextView.text = "To"
            } else {
                
                var str = ""
                for item in selectedRecipientArray {
                    str = item.name + "," + str
                }
                
              _ =  str.removeCharsFromEnd(2)
                
                cell.titleTextView.text = str
                
            }
            cell.titleTextView.isUserInteractionEnabled = !true
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessageTableCell3", for: indexPath) as! NewMessageTableCell3
            cell.subjectTextView.text = cell.subjectTextView.text == "Subject" ? "Subject" : subject
            cell.subjectTextView.delegate = self
            cell.subjectTextView.textColor = cell.subjectTextView.text == "Subject" ? UIColor.lightGray : UIColor.black
            cell.subjectTextView.tag = indexPath.row
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessageTableCell4", for: indexPath) as! NewMessageTableCell4
            cell.checkImageView.setFAIconWithName(raiseADoubt ? FAType.faCheck : FAType.faSquare, textColor: UIColor.darkGray)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessageTableCell5", for: indexPath) as! NewMessageTableCell5
            cell.descTextView.text = cell.descTextView.text == "Enter message here." ? "Enter message here." : desc
            cell.descTextView.delegate = self
            cell.descTextView.tag = indexPath.row
            cell.descTextView.textColor = cell.descTextView.text == "Enter message here." ? UIColor.lightGray : UIColor.black
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InboxListTableCell", for: indexPath) as! InboxListTableCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        //        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InboxDetailViewController") as! InboxDetailViewController
        //        self.navigationController?.pushViewController(detailVC, animated: true)
        
        if indexPath.row == 0 {
            
            let vc : BatchSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BatchSelectionViewController") as! BatchSelectionViewController
            vc.selectedBatch = selectedBatch
            self.present(vc, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            fetctRecipientListFromServer()
            
        }else if indexPath.row == 3 {
            raiseADoubt = !raiseADoubt
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        //            let addedWidth:CGFloat = DataUtils.getDynamicHeight(inboxArray[indexPath.row], width: tableView.frame.size.width - 48)
        //            return 80.0+addedWidth
        
        switch indexPath.row {
        case 0:
            return 44.0
        case 1:
            
            if selectedRecipientArray.count == 0 {
                return 44.0
            } else {
                var str = ""
                for item in selectedRecipientArray {
                    str = item.name + "," + str
                }
              _ =  str.removeCharsFromEnd(2)
                
                let addedWidth:CGFloat = DataUtils.getDynamicHeight(str, width: tableView.frame.size.width - 40)
                return 44+addedWidth
            }
        case 2:
            let addedWidth:CGFloat = DataUtils.getDynamicHeight(subject, width: tableView.frame.size.width - 40)
            return 44+addedWidth
        case 3:
            return 44.0
        case 4:
            return 200.0
        default:
            return 44.0
        }
    }
    
    // MARK: - UITextView Delegate Methads.
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        if textView.text.isEmpty {
            textView.text = textView.tag == 4 ? "Enter message here." : "Subject"
            textView.textColor = UIColor.lightGray
            newMessageTableView.reloadData()
        }
        if textView.tag == 4 {
            desc = textView.text
        }else if textView.tag == 2 {
            subject = textView.text
        }
        newMessageTableView.reloadData()
        return true
    }

}


class NewMessageTableCell1: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomArrowLabel: UILabel!
    
}

class NewMessageTableCell2: UITableViewCell {
    
    @IBOutlet weak var titleTextView: UITextView!
}


class NewMessageTableCell3: UITableViewCell {
    
    @IBOutlet weak var subjectTextView: UITextView!
}

class NewMessageTableCell4: UITableViewCell {
    
    @IBOutlet weak var checkImageView: UIImageView!
}

class NewMessageTableCell5: UITableViewCell {
    
    @IBOutlet weak var descTextView: UITextView!
}

