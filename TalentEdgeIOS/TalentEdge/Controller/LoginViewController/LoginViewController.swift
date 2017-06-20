//
//  LoginViewController.swift
//  TalentEdge
//

//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButtonOutlet: UIButton!

    //MARK:- viewDidLoad()
    
    var name : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyeButtonOutlet.setFAIcon(FAType.faEye, forState: UIControlState())
        passwordTextField.delegate=self
        
        if TechUserDefault.singleton.isUserCredentialSaved() == true {
            let headers : [String:String] = [
                "devicetype": "IOS",
                "deviceid": TechUserDefault.singleton.deviceToken() == nil ? "ferhjfdgka":TechUserDefault.singleton.deviceToken()!,
                "username": TechUserDefault.singleton.userName()!,
                "password": TechUserDefault.singleton.password()!
            ]
            
            
            ServerCommunication.singleton.requestWithPost(API_LOGIN ,headerDict: headers, postString: " ", success: { (successResponseDict) -> Void in
                print(successResponseDict)
                let loginData: TELoginData? = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TELoginData"), jsonData: successResponseDict) as? TELoginData
                ModelManager.singleton.loginData = loginData
                let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SSASideMenu") as! SSASideMenu
                APPDELEGATE.window?.rootViewController = sideMenuController
                APPDELEGATE.window?.makeKeyAndVisible()
            }) { (errorResponseDict) -> Void in
                TechUserDefault.singleton.removeUserCredential()
                DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden=true
    }
    
    @IBAction func loginButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if emailTextField.text!.characters.count == 0 {
            emailTextField.triggerShakeAnimation()
            return
        }else if passwordTextField.text!.characters.count == 0 {
            passwordTextField.triggerShakeAnimation()
            return
        }
        let headers : [String:String] = [
            "devicetype": "IOS",
            "deviceid": TechUserDefault.singleton.deviceToken() == nil ? "ferhjfdgka":TechUserDefault.singleton.deviceToken()!,
            "username": self.emailTextField.text!,
            "password": self.passwordTextField.text!
        ]
        ServerCommunication.singleton.requestWithPost(API_LOGIN ,headerDict: headers, postString: " ", success: { (successResponseDict) -> Void in
            print(successResponseDict)
                        TechUserDefault.singleton.setUserName(self.emailTextField.text!)
                        TechUserDefault.singleton.setPassword(self.passwordTextField.text!)
                        let loginData: TELoginData? = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TELoginData"), jsonData: successResponseDict) as? TELoginData
                        ModelManager.singleton.loginData = loginData
                        let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SSASideMenu") as! SSASideMenu
                        APPDELEGATE.window?.rootViewController = sideMenuController
                        APPDELEGATE.window?.makeKeyAndVisible()
        }) { (errorResponseDict) -> Void in
                        TechUserDefault.singleton.removeUserCredential()
                        DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(true, moveValue: 50)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(false, moveValue: 50)
    }
    
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
    
    //MARK:- Forget Password Button Action
    
    @IBAction func forgotPasswordButtonAction(_ sender: AnyObject) {
        let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.present(sideMenuController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(sideMenuController, animated: true)

    }
    
    @IBAction func viewPasswordButtonAction(_ sender: AnyObject) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
}
