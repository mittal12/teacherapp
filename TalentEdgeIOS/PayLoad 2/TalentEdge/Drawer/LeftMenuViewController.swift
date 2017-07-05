//
//  LeftMenuViewController.swift
//  SSASideMenuExample


import Foundation
import UIKit

@objc
protocol LeftMenuViewControllerDelegate {
    func selectedMenuDelegate(_ leftDrawerItem: LeftDrawerItem)
}

class LeftMenuViewController: UIViewController {
    var leftDrawerMenuArray = NSMutableArray ()
    var delegate: LeftMenuViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet var profileDetailSubView: UIView!
    @IBOutlet weak var userImageViewOutlet: UIImageView!
    
    @IBOutlet weak var counsellorNameLabel: UILabel!
    @IBOutlet weak var counsellorImageView: UIImageView!
    
    @IBOutlet weak var counsellerConnectImageView: UIImageView!
    struct TableView {
        struct CellIdentifiers {
            static let LeftDrawerCell = "LeftDrawerCell"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userTitleLabel.text = ModelManager.singleton.loginData == nil ? "Hello Guest" : ModelManager.singleton.loginData.resultData.user.fName + " " + ModelManager.singleton.loginData.resultData.user.lName
        userImageViewOutlet.setFAIconWithName(FAType.faApple, textColor: UIColor.white)
        userImageViewOutlet.sd_setImage(with: URL(string: ModelManager.singleton.loginData == nil ? "" :ModelManager.singleton.loginData.resultData.user.avtar_url))
        counsellorNameLabel.text = ModelManager.singleton.loginData == nil ? "Hello Guest" : ModelManager.singleton.loginData.resultData.counsellor.name
        counsellorImageView.sd_setImage(with: URL(string: ModelManager.singleton.loginData == nil ? "" :ModelManager.singleton.loginData.resultData.counsellor.pic))
        leftDrawerMenuArray = DataUtils.drawerComponentFromJson()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateProfilleButtonAction(_ sender: AnyObject) {
        let tempVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        let tempNavC : UINavigationController = sideMenuViewController?.contentViewController as! UINavigationController
        tempNavC.pushViewController(tempVC, animated: true)
        sideMenuViewController?.hideMenuViewController()
    }
    
    @IBAction func counsellerConnectButtonAction(_ sender: AnyObject) {
        let tempVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SeendMessageViewController") as! SeendMessageViewController
        let tempNavC : UINavigationController = sideMenuViewController?.contentViewController as! UINavigationController
        
        let obj : TEStudentData = TEStudentData()
        obj.id = ModelManager.singleton.loginData.resultData.counsellor.id
        obj.name = ModelManager.singleton.loginData.resultData.counsellor.name
        tempVC.selectedRecipientArray = [obj]
        tempNavC.pushViewController(tempVC, animated: true)
        sideMenuViewController?.hideMenuViewController()
    }
    
}


// MARK : TableViewDataSource & Delegate Methods

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? (leftDrawerMenuArray.object(at: section) as! LeftDrawerItemsGroup).leftDrawerItems.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.LeftDrawerCell, for: indexPath) as! LeftDrawerCell
        let leftItemGroup = leftDrawerMenuArray.object(at: indexPath.section) as! LeftDrawerItemsGroup
        let leftMenuItem = leftItemGroup.leftDrawerItems.object(at: indexPath.row) as! LeftDrawerItem
        let frame = CGRect(x: cell.bottomLineView.frame.origin.x, y: cell.bottomLineView.frame.origin.y, width: APPDELEGATE.window!.frame.size.width - ((APPDELEGATE.window?.frame.size.width)! - (sideMenuViewController!.contentViewContainer.frame.origin.x - 10)), height: 1.0)
        cell.bottomLineView.frame = frame
        cell.animalImageView?.image = UIImage(named: leftMenuItem.icon!)
        cell.configureDrawerCell(leftMenuItem)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMenuGroup = leftDrawerMenuArray[indexPath.section] as! LeftDrawerItemsGroup
        let selectedMenu =  selectedMenuGroup.leftDrawerItems.object(at: indexPath.row) as! LeftDrawerItem
        if selectedMenu.title == "LOGOUT" {
            if DataUtils.isConnectedToNetwork() == false {
                DataUtils.addErrorToast("You are not connected to internet. Connect to internet to proceed", controller: self)
                Timer.scheduledTimer(timeInterval: 1.5, target: DataUtils.self, selector: #selector(DataUtils.removeErrorToast), userInfo: nil, repeats: false)
                return
            }
            let alertController = UIAlertController(title: "Do you want to Logout?", message:"", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                
                let headers : [String:String] = [
                    "devicetype": "IOS",
                    "deviceid": TechUserDefault.singleton.deviceToken() == nil ? "ferhjfdgka":TechUserDefault.singleton.deviceToken()!,
                    "token": ModelManager.singleton.loginData.token
                ]
                
                ServerCommunication.singleton.requestWithPost(API_LOGOUT ,headerDict: headers, postString: " ", success: { (successResponseDict) -> Void in
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        let tempNav = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController)
                        tempNav.navigationBar.barTintColor = .white
                        tempNav.navigationBar.tintColor = .white
                        ModelManager.singleton.loginData = nil
                        TechUserDefault.singleton.removeUserCredential()
                        self.sideMenuViewController?.contentViewController = tempNav
                        self.sideMenuViewController?.hideMenuViewController()
                    })
                }) { (errorResponseDict) -> Void in
                    TechUserDefault.singleton.removeUserCredential()
                    let tempNav = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController)
                    tempNav.navigationBar.barTintColor = .white
                    tempNav.navigationBar.tintColor = .white
                    ModelManager.singleton.loginData = nil
                    TechUserDefault.singleton.removeUserCredential()
                    self.sideMenuViewController?.contentViewController = tempNav
                    self.sideMenuViewController?.hideMenuViewController()

//                    DataUtils.showAlertMessage(errorResponseDict.valueForKey("errDesc") as! String, withTitle: "", delegate: self)
                }
                
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
            return
        }
        
        if ModelManager.singleton.selectedCourseObj == nil {
            DataUtils.sendToLoginScreenWithAlert(self)
            return
        }

        
        if selectedMenu.index == "1" {
            
            let tempVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: selectedMenu.className!) as UIViewController
            
            
            tempVC.selectedCourseObj = ModelManager.singleton.selectedCourseObj
            let tempNavC : UINavigationController = sideMenuViewController?.contentViewController as! UINavigationController
            
            tempNavC.pushViewController(tempVC, animated: true)
            sideMenuViewController?.hideMenuViewController()
        }else {
            let tempVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCourseDetailViewController") as! MyCourseDetailViewController
            tempVC.selectedTabIndex = (Int(selectedMenu.index!))! - 5
            tempVC.selectedCourseObj = ModelManager.singleton.selectedCourseObj
            let tempNavC : UINavigationController = sideMenuViewController?.contentViewController as! UINavigationController
            
            tempNavC.pushViewController(tempVC, animated: true)
            sideMenuViewController?.hideMenuViewController()
            
        }
    }
    //    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return section == 0 ? 0.0 : 150.0
    //    }
    //
    //    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let view = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,150))
    //        let checkedImageView = UIImageView(frame: CGRectMake(5,50,50,50))
    //        checkedImageView.sd_setImageWithURL(NSURL(string: ModelManager.singleton.loginData == nil ? "" :ModelManager.singleton.loginData.resultData.counsellor.pic))
    //        let label = UILabel(frame: CGRectMake(60,20,tableView.frame.size.width - 60,40))
    //        label.textColor = UIColor.whiteColor()
    //        label.text = ModelManager.singleton.loginData == nil ? "Hello Guest" : ModelManager.singleton.loginData.resultData.counsellor.name
    //        let label1 = UILabel(frame: CGRectMake(60,70,tableView.frame.size.width - 60,30))
    //        label1.textColor = UIColor.whiteColor()
    //        label1.text = "Your Academic Counsellor"
    //        let imageView = UIImageView(frame: CGRectMake(60,120,20,20))
    //        imageView.setFAIconWithName(FAType.FAFonticons, textColor: UIColor.whiteColor())
    //        let button = UIButton(frame: CGRectMake(90,110,60,35))
    //        button.setTitle("Connect", forState: .Normal)
    //        view.addSubview(checkedImageView)
    //        view.addSubview(label)
    //        view.addSubview(label1)
    //        view.addSubview(imageView)
    //        view.addSubview(button)
    //        return view
    //    }
    
}

class LeftDrawerCell: UITableViewCell {
    
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var bottomLineWidthConstraint: NSLayoutConstraint!
    
    func configureDrawerCell(_ leftMenuItem: LeftDrawerItem) {
        imageNameLabel.text = leftMenuItem.title!
    }
    
}

