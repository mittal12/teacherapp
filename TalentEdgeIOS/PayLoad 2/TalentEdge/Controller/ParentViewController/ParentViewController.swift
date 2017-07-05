//
//  ParentViewController.swift
//  TalentEdge
//
//

import UIKit

class ParentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = kBarButtonBottomSelectedColor
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.translucent = true
        let button1 = UIBarButtonItem(title: "Left", style: .plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        button1.setFAIcon(FAType.faBars, iconSize: 20.0)
        navigationItem.leftBarButtonItem = button1
        let button2 = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.rightBarButtonAction))
        button2.setFAIcon(FAType.faBell, iconSize: 20.0)
        navigationItem.rightBarButtonItem = button2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightBarButtonAction () {
        let notificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)

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
