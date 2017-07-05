//
//  ForgotPasswordViewController.swift
//  TalentEdge
//
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var closeButtonOutlet: UIButton!

    //MARK:- viewDidLoad()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DataUtils.addBackArrow(self.navigationItem, withTitle: "Forget Password", target: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func backButtonAction(_ sender : AnyObject){
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func forgotPasswordButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if emailTextField.text!.characters.count == 0 {
            emailTextField.triggerShakeAnimation()
            return
        }
        let headers : [String:String] = [
            "devicetype": "IOS",
            "deviceid": TechUserDefault.singleton.deviceToken() == nil ? "ferhjfdgka":TechUserDefault.singleton.deviceToken()!,
            "username": self.emailTextField.text!,
        ]
        let str = String(format: "email=%@",emailTextField.text!)
        ServerCommunication.singleton.requestWithPost(API_FORGOT_PASSWORD ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
////            let loginData: TELoginData? = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TELoginData"), jsonData: successResponseDict) as? TELoginData
////            ModelManager.singleton.loginData = loginData
//            let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SSASideMenu") as! SSASideMenu
//            APPDELEGATE.window?.rootViewController = sideMenuController
//            APPDELEGATE.window?.makeKeyAndVisible()
            self.dismiss(animated: true, completion: nil)
        }) { (errorResponseDict) -> Void in
            TechUserDefault.singleton.removeUserCredential()
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        animateViewMoving(true, moveValue: 80)
//    }
//    func textFieldDidEndEditing(textField: UITextField) {
//        animateViewMoving(false, moveValue: 80)
//    }
//    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
}
