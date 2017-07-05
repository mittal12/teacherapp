//
//  TestimonialDetailViewController.swift
//  TalentEdge
//
//

import UIKit
import AVKit
import AVFoundation
import CoreMedia

class TestimonialDetailViewController: UIViewController {
    
    
    var testimonialData : TETestimonialData!
    
    @IBOutlet weak var videoSubView: UIView!
    var player : AVPlayer!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DataUtils.addBackArrow(self.navigationItem, withTitle: "Testimonial", target: self)
        loadVideo()
        loadUI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func loadUI () {
        titleLabel.text = testimonialData.created_by
        publisherLabel.text = "Published on:" + testimonialData.created
        profileImageView.sd_setImage(with: URL(string: testimonialData.pic))
        descLabel.text = testimonialData.desc
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func loadVideo() {
        
        
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch { }
        
        
        player = AVPlayer(url: URL(string: testimonialData.uploads )!)

        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        playerViewController.view.frame = self.videoSubView.bounds
        self.videoSubView.addSubview(playerViewController.view)
        self.addChildViewController(playerViewController)
    }
}



