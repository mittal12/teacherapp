//
//  FeaturedCoureDetailVC.swift
//  TalentEdge
//
//

import UIKit

class FeaturedCoureDetailVC: UIViewController {

    @IBOutlet weak var featuredCourseWebView: UIWebView!
    var featuredCourseData : TEFeaturedCourseData!
    @IBOutlet weak var subNavTitleLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        subNavTitleLabel.text = featuredCourseData.post_title
        featuredCourseWebView.loadRequest(URLRequest(url: URL(string: featuredCourseData.view_url)!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UIWebView Delegate
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        DataUtils.addLoadIndicator()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DataUtils.removeLoadIndicator()
    }

}
