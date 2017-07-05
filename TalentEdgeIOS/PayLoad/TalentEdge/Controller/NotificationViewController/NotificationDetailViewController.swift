//
//  NotificationDetailViewController.swift
//  TalentEdge
//
//

import UIKit

class NotificationDetailViewController: UIViewController {
    
    @IBOutlet weak var notificationTextView: UITextView!
    var notificationObj : TENotificationData!
    override func viewDidLoad() {
        super.viewDidLoad()
//        DataUtils.addBackArrow(self.navigationItem, withTitle: "Notifications", target: self)
        notificationTextView.text = notificationObj.web_message
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     @IBAction func backButtonAction(_ sender : AnyObject){
        self.navigationController?.popViewController(animated: true)
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
