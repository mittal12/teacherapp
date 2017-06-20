//
//  ReferenceNoteViewController.swift
//  TalentEdge
//
//

import UIKit
import CoreData

class ReferenceNoteViewController: UIViewController {
    
    fileprivate struct ImageWithURL {
        let id: NSNumber
        let url: URL
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var lastViewedLabel: UILabel!
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var readButtonOutlet: UIButton!
    @IBOutlet weak var downloadButtonOutlet: UIButton!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var bezierView: UIView!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    var assignmentData : Assignment!

    
    var noteObj : TENotes!
    var moduleData : TEModuleDetailData!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        DataUtils.addBackArrow(self.navigationItem, withTitle: "Refernce Note", target: self)
        loadUI()
        fetchDataFromMemory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromServer()
    }
    
    fileprivate func loadUI () {
        subNavTitleLabel.text = moduleData == nil ? self.selectedCourseObj.name : self.moduleData.module_name
        titleLabel.text = "Title: " + noteObj.title
        publisherLabel.text = "Published By: " + noteObj.created_by
        lastViewedLabel.text = noteObj.user_content_view.value(forKey: "last_view") as? String
        //        fileImageView.setFAIconWithName(FAType.FAFile, textColor: UIColor.blueColor())
        likeImageView.image = UIImage(named: "like_icon.PNG")
        likeLabel.text = noteObj.like_text
        dateLabel.text = noteObj.end_date
        downloadButtonOutlet.isHidden = !noteObj.allow_download.boolValue
        downloadButtonOutlet.setTitle(assignmentData == nil ? "Download" : "View", for: UIControlState())
        likeLabel.isHidden = !noteObj.like.boolValue
//        likeButtonOutlet.userInteractionEnabled = (noteObj.like_text == "")
        descLabel.text = noteObj.desc
        //        DataUtils.addLoadIndicator()
        completeLabel.text = String (format : "Complete %d",noteObj.completion_percentage.intValue)
        drawCircle(CGFloat(noteObj.completion_percentage.doubleValue), viewLayer: bezierView, acrColor: UIColor.blue)
        //        for i in 0..<noteObj.note.count {
        //            let obj : TENoteContent = noteObj.note[i] as! TENoteContent
        ////                    DataUtils.addLoadIndicator()
        //            imageFromUrl(obj.content_path)
        //
        //        }
        //        downloadButtonOutlet.hidden = true
    }
    
    fileprivate func fetchDataFromMemory () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Assignment")
        fetchRequest.predicate = NSPredicate(format: "name == %@", String(format : "%d",self.noteObj.id.intValue))
        do {
            let dataArray = try managedContext.fetch(fetchRequest)
            if dataArray.count != 0 {
                downloadButtonOutlet.setTitle("View", for: UIControlState())
                for i in 0..<dataArray.count {
                    print((dataArray[i] as! Assignment).name ?? "")
                    assignmentData = dataArray[i] as! Assignment
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    func fetchDataFromServer () {
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",self.moduleData.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_VIEW_NOTES ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            let noteObj : TENotes = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TENotes"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as! TENotes
            //            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ReferenceNoteViewController") as! ReferenceNoteViewController
            //            detailVC.selectedCourseObj = self.selectedCourseObj
            //            detailVC.moduleData = self.subModuleArray[indexPath.row]
            self.noteObj = noteObj
            DispatchQueue.main.async(execute: { () -> Void in
                self.loadUI()
            })
            //            self.navigationController?.pushViewController(detailVC, animated: true)
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            //            self.fetchDataFromServer()
        }
    }
    
    @objc
    fileprivate func dismissController(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Creating arc around average label
    
    fileprivate func convertToAngle(_ value:CGFloat) ->CGFloat{
        
        return CGFloat(Float(value)*0.640/10)
        
    }
    
    fileprivate func drawCircle(_ point : CGFloat, viewLayer : UIView, acrColor : UIColor ){
        
        
        
        var endPoint:Int = 1
        let endAngle = self.convertToAngle(point == 0 ? 100 : point)
        
        
        let circle1 = CAShapeLayer()
        circle1.removeFromSuperlayer()
        
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x:viewLayer.frame.size.width / 2.0, y:viewLayer.frame.size.height / 2.0), radius: (viewLayer.frame.size.width - 10)/2, startAngle:CGFloat(2*M_PI*1 - M_PI_2), endAngle: (CGFloat(2*M_PI*1 - M_PI_2) + 100 ), clockwise: true)
        circle1.path = circlePath1.cgPath
        circle1.fillColor = UIColor.clear.cgColor
        circle1.strokeColor = UIColor.lightGray.cgColor
        circle1.lineWidth = 3;
        viewLayer.layer .addSublayer(circle1)

        
        
        let circle = CAShapeLayer()
        circle.removeFromSuperlayer()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:viewLayer.frame.size.width / 2.0, y:viewLayer.frame.size.height / 2.0), radius: (viewLayer.frame.size.width - 10)/2, startAngle:CGFloat(2*M_PI*1 - M_PI_2), endAngle: (CGFloat(2*M_PI*1 - M_PI_2) + endAngle ), clockwise: true)
        circle.path = circlePath.cgPath
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = point == 0 ? UIColor.lightGray.cgColor : acrColor.cgColor
        circle.lineWidth = 3;
        viewLayer.layer .addSublayer(circle)
        endPoint += 1;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
     _ =   self.navigationController?.popViewController(animated: true)
    }
    
    
    
    fileprivate var images = [ImageWithURL]()
    
    
    @IBAction func readButtonAction(_ sender : UIButton) {
        //        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AssignmentViewViewController") as! AssignmentViewViewController
        //        detailVC.noteObj = noteObj
        //        detailVC.imageArray = self.imageArray
        //        detailVC.moduleData = moduleData
        //        detailVC.selectedCourseObj = self.selectedCourseObj
        //        self.navigationController?.pushViewController(detailVC, animated: true)
        if noteObj.note.count == 0 {
            DataUtils.addErrorToast("Currently no notes available.", controller: self)
            Timer.scheduledTimer(timeInterval: 1.5, target: DataUtils.self, selector: #selector(DataUtils.removeErrorToast), userInfo: nil, repeats: false)
            return
        }
        images = [ImageWithURL]()
        for i in 0..<noteObj.note.count {
            let content = noteObj.note[i] as! TENoteContent
            images.append(ImageWithURL(id: content.id, url: URL(string: IMAGE_URL + content.content_path)!))
//            images.append(ImageWithURL(url: NSURL(string: IMAGE_URL + content.content_path)!))
        }
        
        let URLs = images.map { $0.url }
        let agrume = Agrume(imageURLs: URLs,imageIDS: images.map { $0.id }, startIndex: 0, backgroundBlurStyle: UIBlurEffectStyle.extraLight,noteObject: noteObj,moduleObject: moduleData)
        //        agrume.didScroll = { [unowned self] index in
        //      self.collectionView?.scrollToItem(at: IndexPath(row: index, section: 0), at: [], animated: false)
        //        }
        agrume.showFrom(self)
    }
    
    var imageArray = [UIImage]()
    
    func imageFromUrl(_ urlString: String) {
        let imageeView = UIImageView()
        imageeView.sd_setImage(with: URL(string: IMAGE_URL + urlString)) { (image, error, type, url) in
            self.imageArray.append(image!)
            if self.imageArray.count == self.noteObj.note.count {
                DispatchQueue.main.async(execute: { () -> Void in
                    DataUtils.removeLoadIndicator()
                })
            }
        }
    }
    
    
    @IBAction func downloadButtonAction(_ sender : UIButton) {
//        
//        DataUtils.addLoadIndicator()
//        
//        for i in 0..<noteObj.note.count {
//            let imageView = UIImageView()
//            let note = noteObj.note[i] as! TENoteContent
//            imageView.sd_setImageWithURL(NSURL(string: IMAGE_URL + note.content_path)) { (image, error, nil, url) in
//                let imageRepresentation = UIImagePNGRepresentation(imageView.image!)
//                let imageData = UIImage(data: imageRepresentation!)
//                UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
//                
//                if (i + 1) == self.noteObj.note.count {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        DataUtils.removeLoadIndicator()
//                    })
//                    
//                    let alert = UIAlertController(title: "Completed", message: "Image has been saved!", preferredStyle: .Alert)
//                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
//                    alert.addAction(action)
//                    self.presentViewController(alert, animated: true, completion: nil)
//                    
//                }
//            }
//        }
//        DataUtils.removeLoadIndicator()
        
        
        if assignmentData == nil {
            let request = NSMutableURLRequest(url: URL(string: noteObj.content_path)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
            request.httpMethod = "GET"
            DataUtils.addLoadIndicator()
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                DispatchQueue.main.async(execute: {
                    DataUtils.removeLoadIndicator()
                    if error == nil {
                        DataUtils.saveAssignment(data!, name : String(format : "%d",self.noteObj.id.intValue) , entityName : "Assignment")
                        self.fetchDataFromMemory()
                    }
                });
            }).resume()
        }else{
            guard let documentURL = Bundle.main.resourceURL?.appendingPathComponent("Document.pdf") else { return }
            let webViewController = WebViewController()
            let mimeType = noteObj.content_path.contains("pptx") == true ? "application/vnd.openxmlformats-officedocument.presentationml.presentation" : noteObj.content_path.contains("pdf") == true ? "application/pdf" : "application/msword"
            webViewController.webView.load(assignmentData.file! as Data, mimeType: mimeType, textEncodingName: "", baseURL: documentURL.deletingLastPathComponent())
            let navigationController = UINavigationController(rootViewController: webViewController)
            // Add a close button that dismisses the web view controller.
            webViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissController(_:)))
            // Present the document.
            present(navigationController, animated: true, completion: nil)
        }

        
    }
    
    @IBAction func likeButtonAction (_ sender : UIButton) {
        //        let obj : TENoteContent = notesObject.note[0] as! TENoteContent
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",noteObj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_LIKE_CONTENT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            if successResponseDict.value(forKey: "message") as! String == "Success" {
                self.likeLabel.isHidden = false
                self.noteObj.like = NSNumber(value: self.noteObj.like.boolValue ? 0 : 1 as Int)
            }
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    
}
