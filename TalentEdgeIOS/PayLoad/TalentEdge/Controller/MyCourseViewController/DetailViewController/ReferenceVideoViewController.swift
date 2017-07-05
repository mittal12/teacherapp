//
//  ReferenceVideoViewController.swift
//  TalentEdge
//
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import Photos
import UserNotifications

class ReferenceVideoViewController: UIViewController {
    @IBOutlet weak var videoSubView: UIView!
    var player : AVPlayer!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var lastViewedLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var downloadButtonOutlet: UIButton!
    @IBOutlet weak var descLabel: UITextView!
    var noteObj : TEModuleVideo!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    var moduleData : TEModuleDetailData!
    var gesture : UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        DataUtils.addBackArrow(self.navigationItem, withTitle: "Refernce Video", target: self)
        loadUI()
        loadVideo()
    }
    
    fileprivate func loadUI () {
        subNavTitleLabel.text = moduleData == nil ? self.selectedCourseObj.name : self.moduleData.module_name
        titleLabel.text = "Title:" + noteObj.title
        publisherLabel.text = "Published By: " + noteObj.created_by
        lastViewedLabel.text = noteObj.user_content_view.value(forKey: "last_view") as? String
        self.gesture = UITapGestureRecognizer(target: self, action:#selector(likeButtonAction(_:)))
        likeImageView.image = UIImage(named: "like_icon.PNG")
        likeImageView.addGestureRecognizer(gesture)
        likeLabel.isHidden = !noteObj.like.boolValue
        likeLabel.text = noteObj.like_text
        dateLabel.text = noteObj.end_date
        descLabel.text = noteObj.desc
        downloadButtonOutlet.isHidden = !noteObj.allow_download.boolValue
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func downloadButtonAction(_ sender : UIButton) {
        DataUtils.addErrorToast("Your video will be downloaded shortly.", controller: self)
        Timer.scheduledTimer(timeInterval: 1.5, target: DataUtils.self, selector: #selector(DataUtils.removeErrorToast), userInfo: nil, repeats: false)

        let str = noteObj.content_path
        let URL = Foundation.URL(string: str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        sender.isUserInteractionEnabled = false
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
 
            let urlData = try? Data(contentsOf: URL!);
            if(urlData != nil)
            {
                print("Video is saved!")
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                print("Video is saved!")
                let filePath="\(documentsPath)/tempFile.mp4";
                DispatchQueue.main.async(execute: {
                    try? urlData?.write(to: Foundation.URL(fileURLWithPath: filePath), options: [.atomic]);
                    print("Video is saved!")
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: Foundation.URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            print("Video is saved!")
                            sender.isUserInteractionEnabled = true
                            let content = UNMutableNotificationContent()
                            content.title = "Video Saved"
                            content.sound = UNNotificationSound.default()
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                            let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                                if let error = error {
                                    print("Uh oh! We had an error: \(error)")
                                }
                            })
                        }
                    }
                })
            }
        })
    }
    
    @IBAction func likeButtonAction (_ sender: AnyObject) {
        
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
                            self.noteObj.like = NSNumber(value: 1 as Int)
                            self.likeImageView.removeGestureRecognizer(self.gesture)
                        }
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    
    fileprivate func loadVideo() {
        
        
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch { }
        
        let str = noteObj.content_path
        player = AVPlayer(url: URL(string: str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
        //        let playerLayer = AVPlayerLayer(player: player)
        //
        //        playerLayer.frame = self.videoSubView.frame
        //        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //        playerLayer.zPosition = -1
        //
        //        videoSubView?.layer.addSublayer(playerLayer)
        //        player.seekToTime(kCMTimeZero)
        //        player?.play()
        
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        playerViewController.view.frame = self.videoSubView.bounds
        self.videoSubView.addSubview(playerViewController.view)
        self.addChildViewController(playerViewController)
        
        //        player.play()
        
        //        self.moviePlayer = MPMoviePlayerController(contentURL: NSURL(string: noteObj.content_path )!)
        //        if let player = self.moviePlayer {
        //            player.view.frame = self.videoSubView.frame
        //            player.view.sizeToFit()
        //            player.scalingMode = MPMovieScalingMode.Fill
        //            player.fullscreen = true
        //            player.controlStyle = MPMovieControlStyle.None
        //            player.movieSourceType = MPMovieSourceType.File
        //            player.repeatMode = MPMovieRepeatMode.One
        //            player.play()
        //            self.view.addSubview(player.view)
        //        }
    }
    
    func playerItemDidReachEnd() {
        player.seek(to: kCMTimeZero)
        player?.play()
    }
    
//    @IBAction func likeButtonAction (sender : UIButton) {
//        //        let obj : TENoteContent = notesObject.note[0] as! TENoteContent
//        
//        let headers : [String:String] = [
//            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.integerValue),
//            "token": ModelManager.singleton.loginData.token,
//            "deviceType": "IOS"
//        ]
//        let str = String(format: "content_id=%d",noteObj.id.integerValue)
//        ServerCommunication.singleton.requestWithPost(API_LIKE_CONTENT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
//            print(successResponseDict)
//            if successResponseDict.valueForKey("message") as! String == "Success" {
//                self.likeLabel.hidden = false
//                self.noteObj.like = NSNumber(integer: 1)
//            }
//        }) { (errorResponseDict) -> Void in
//            DataUtils.showAlertMessage(errorResponseDict.valueForKey("errDesc") as! String, withTitle: "", delegate: self)
//        }
//    }

}
