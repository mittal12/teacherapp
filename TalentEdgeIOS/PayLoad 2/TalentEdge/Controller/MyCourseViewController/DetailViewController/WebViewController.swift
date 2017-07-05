//
//  WebViewController.swift
//  TalentEdge
//
//

import UIKit

class WebViewController: UIViewController {

    let webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure the web view is shown fullscreen.
        webView.frame = view.frame
        webView.scalesPageToFit = true
        view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
