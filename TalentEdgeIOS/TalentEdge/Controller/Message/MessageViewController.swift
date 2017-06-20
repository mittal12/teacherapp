//
//  MessageViewController.swift
//  TalentEdge
//
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var buttonView1: UIView!
    @IBOutlet weak var buttonView2: UIView!
    
    @IBOutlet weak var mainSubView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DataUtils.addBackArrow(self.navigationItem, withTitle: "Inbox", target: self)
        loadUI()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func loadUI () {
        buttonView1.backgroundColor = kBarButtonBottomSelectedColor
        button1.setTitleColor(kBarButtonBottomSelectedColor, for: UIControlState())
        let inboxVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
        inboxVC.isInbox = true
        inboxVC.view.frame = mainSubView.bounds
        inboxVC.view.tag = 9998
        self.addChildViewController(inboxVC)
        self.mainSubView.addSubview(inboxVC.view)
    }
    
     @IBAction func backButtonAction(_ sender : AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func barButtonAction(_ sender: AnyObject) {
        buttonView1.backgroundColor = kBarButtonBottomDefaultColor
        buttonView2.backgroundColor = kBarButtonBottomDefaultColor
        
        button1.setTitleColor(kBarButtonDefaultTextColor, for: UIControlState())
        button2.setTitleColor(kBarButtonDefaultTextColor, for: UIControlState())
        
        switch sender.tag {
        case 101:
            buttonView1.backgroundColor = kBarButtonBottomSelectedColor
            button1.setTitleColor(kBarButtonBottomSelectedColor, for: UIControlState())
            let inboxVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
            inboxVC.isInbox = true
            inboxVC.view.layer.add(DataUtils.getPushAnimation(), forKey: nil)
            inboxVC.view.frame = mainSubView.bounds
            inboxVC.view.tag = 9998
            self.addChildViewController(inboxVC)
            self.mainSubView.addSubview(inboxVC.view)
            
        case 102:
            buttonView2.backgroundColor = kBarButtonBottomSelectedColor
            button2.setTitleColor(kBarButtonBottomSelectedColor, for: UIControlState())
            let inboxVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
            inboxVC.isInbox = false
            inboxVC.view.layer.add(DataUtils.getPushAnimation(), forKey: nil)
            inboxVC.view.frame = mainSubView.bounds
            inboxVC.view.tag = 9998
            //            commonTableView.selectionDelegate = self
            self.addChildViewController(inboxVC)
            self.mainSubView.addSubview(inboxVC.view)
            
        default:
            buttonView1.backgroundColor = kBarButtonBottomSelectedColor
        }
    }
}
