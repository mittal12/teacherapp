//
//  DataUtils.swift
//
//
//
//

import UIKit
import Foundation
import SystemConfiguration
import CoreData

let indicatorViewTag = 10001;
let errorToastViewTag = 10002;

class DataUtils: NSObject {
    
    class func convertStringForAltaObjectParser(_ string : String) -> String{
        return JSONPARSERKEY+string
    }
    
    //MARK :- Method to add back button
    
    class func addBackArrow (_ navigationItem : UINavigationItem, withTitle title:String , target controller:AnyObject)
    {
        navigationItem.hidesBackButton = true
        let backButton = UIButton()
        //        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30,height: 20)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton.addTarget(controller, action: Selector(("backButtonAction:")), for: UIControlEvents.touchUpInside)
//         backButton.setTitle("<", forState: .Normal)
        backButton.setFAIcon(FAType.faArrowLeft, forState: UIControlState())
//        backButton.setImage(UIImage(named: "back.png"), forState: .Normal)
        //        backButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        backButton.imageEdgeInsets.right = 11.0
        backButton.imageEdgeInsets.bottom = 2.0
        //        backButton.imageEdgeInsets.left = -3.0
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
        backButton.contentVerticalAlignment = .center
        backButton.titleLabel?.textAlignment = .left
        self.addTitleToNavigation(navigationItem, withTitle: title)
        
    }
    
    class func addBackArrowWithRightButton (_ navigationItem : UINavigationItem, withTitle title:String , target controller:AnyObject)
    {
        navigationItem.hidesBackButton = true
        let backButton = UIButton()
        //        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30,height: 20)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton.addTarget(controller, action: Selector(("backButtonAction:")), for: UIControlEvents.touchUpInside)
        // backButton.setTitle("< Back", forState: .Normal)
        backButton.setFAIcon(FAType.faArrowLeft, forState: UIControlState())
        //        backButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        backButton.imageEdgeInsets.right = 11.0
        backButton.imageEdgeInsets.bottom = 2.0
        //        backButton.imageEdgeInsets.left = -3.0
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
        backButton.contentVerticalAlignment = .center
        backButton.titleLabel?.textAlignment = .left
        let backButton1 = UIButton()
        //        let backButton = UIButton(type: UIButtonType.Custom)
        backButton1.frame = CGRect(x: 0, y: 0, width: 30,height: 20)
        backButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton1.addTarget(controller, action: Selector(("homeButtonAction:")), for: UIControlEvents.touchUpInside)
        // backButton.setTitle("< Back", forState: .Normal)
        backButton1.setImage(UIImage(named: "home.png"), for: UIControlState())
        //        backButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        backButton1.imageEdgeInsets.right = 11.0
        backButton1.imageEdgeInsets.bottom = 2.0
        //        backButton.imageEdgeInsets.left = -3.0
        let barButton1 = UIBarButtonItem(customView: backButton1)
        navigationItem.rightBarButtonItem = barButton1
        backButton1.contentVerticalAlignment = .center
        backButton1.titleLabel?.textAlignment = .left
        
        self.addTitleToNavigation(navigationItem, withTitle: title)
        
    }
    
    class func addBackArrowWithOneCustomButton (_ navigationItem : UINavigationItem, withTitle title:String , target controller:AnyObject)
    {
        navigationItem.hidesBackButton = true
        let backButton = UIButton()
        //        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30,height: 20)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton.addTarget(controller, action: Selector(("backButtonAction:")), for: UIControlEvents.touchUpInside)
        // backButton.setTitle("< Back", forState: .Normal)
        backButton.setFAIcon(FAType.faArrowLeft, forState: UIControlState())
        //        backButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        backButton.imageEdgeInsets.right = 11.0
        backButton.imageEdgeInsets.bottom = 2.0
        //        backButton.imageEdgeInsets.left = -3.0
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
        backButton.contentVerticalAlignment = .center
        backButton.titleLabel?.textAlignment = .left
        let backButton1 = UIButton()
        //        let backButton = UIButton(type: UIButtonType.Custom)
        backButton1.frame = CGRect(x: 0, y: 0, width: 100,height: 35)
        backButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton1.addTarget(controller, action: Selector(("homeButtonAction:")), for: UIControlEvents.touchUpInside)
        backButton.setTitle("Upload Doc", for: UIControlState())
        backButton1.setImage(UIImage(named: "upload_doc.png"), for: UIControlState())
        //        backButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        backButton1.imageEdgeInsets.right = 11.0
        backButton1.imageEdgeInsets.bottom = 2.0
        //        backButton.imageEdgeInsets.left = -3.0
        let barButton1 = UIBarButtonItem(customView: backButton1)
        navigationItem.rightBarButtonItem = barButton1
        backButton1.contentVerticalAlignment = .center
        backButton1.titleLabel?.textAlignment = .left
        
        self.addTitleToNavigation(navigationItem, withTitle: title)
        
    }
    
    class func addBackArrowWithTwoCustomButton (_ navigationItem : UINavigationItem, withTitle title:String , target controller:AnyObject)
    {
        navigationItem.hidesBackButton = true
        let backButton = UIButton()
        //        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30,height: 20)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton.addTarget(controller, action: Selector("backButtonAction:"), for: UIControlEvents.touchUpInside)
        // backButton.setTitle("< Back", forState: .Normal)
        backButton.setFAIcon(FAType.faArrowLeft, forState: UIControlState())
        //        backButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        backButton.imageEdgeInsets.right = 11.0
        backButton.imageEdgeInsets.bottom = 2.0
        //        backButton.imageEdgeInsets.left = -3.0
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
        backButton.contentVerticalAlignment = .center
        backButton.titleLabel?.textAlignment = .left
        let backButton1 = UIButton()
        //        let backButton = UIButton(type: UIButtonType.Custom)
        backButton1.frame = CGRect(x: 0, y: 0, width: 100,height: 35)
        backButton.setFAIcon(FAType.faArrowLeft, forState: UIControlState())

        backButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton1.addTarget(controller, action: Selector("homeButtonAction:"), for: UIControlEvents.touchUpInside)
        //        backButton.setBackgroundImage(UIImage(named: "back.png"), forState: .Normal)
        backButton1.imageEdgeInsets.right = 11.0
        backButton1.imageEdgeInsets.bottom = 2.0
        //        backButton.imageEdgeInsets.left = -3.0
        let barButton1 = UIBarButtonItem(customView: backButton1)
        navigationItem.rightBarButtonItem = barButton1
        backButton1.contentVerticalAlignment = .center
        backButton1.titleLabel?.textAlignment = .left
        
//        self.addTitleToNavigation(navigationItem, withTitle: title)
        
    }

    
    
    
    //MARK :- Method to add title on navigation button
    
    class func addTitleToNavigation (_ navigationItem :UINavigationItem, withTitle title : String) {
        let titleLabelView =  UIView(frame: CGRect(x: 0,y: 5,width: UIScreen.main.bounds.size.width - 160 ,height: 50))
        titleLabelView.backgroundColor = UIColor.clear
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 8,width: titleLabelView.frame.size.width,height: 30))
        titleLabel.textColor = UIColor.white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont(name: "Raleway-Semibold", size: 18)
        titleLabel.text = title
        titleLabelView.addSubview(titleLabel)
        navigationItem.titleView = titleLabelView
    }
    
    //MARK:- Methot to add gradient in background
    
    class func getGradientForText(_ text: String , rgbColorArray : [CGFloat]) -> UIImage {
        
        let font:UIFont = UIFont.systemFont(ofSize: 64.0)
        let name:String = NSFontAttributeName
        let textSize: CGSize = text.size(attributes: [name:font])
        let width:CGFloat = textSize.width         // max 1024 due to Core Graphics limitations
        let height:CGFloat = textSize.height       // max 1024 due to Core Graphics limitations
        
        //create a new bitmap image context
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // get context
        let context = UIGraphicsGetCurrentContext()
        
        // push context to make it current (need to do this manually because we are not drawing in a UIView)
        UIGraphicsPushContext(context!)
        
        //draw gradient
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components : [CGFloat] = rgbColorArray
        //        let components:[CGFloat] = [(255 / 255.0), (0 / 255.0), (24 / 255.0), 1.0,  // Start color
        //            (0 / 255.0), (55 / 255.0), (255 / 255.0), 1.0] // End color
        rgbColorspace = CGColorSpaceCreateDeviceRGB();
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations);
        let topCenter = CGPoint(x: 0, y: 0);
        let bottomCenter = CGPoint(x: 0, y: textSize.height);
        context!.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation);
        
        // pop context
        UIGraphicsPopContext();
        
        // get a UIImage from the image context
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // clean up drawing environment
        UIGraphicsEndImageContext();
        
        return  gradientImage!;
    }
    
    class func gradientHorizontal (_ frame : CGRect) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor(red: (1/255.0), green: (49/255.0), blue: (89/255.0), alpha: 1.0),UIColor(red: (1/255.0), green: (49/255.0), blue: (89/255.0), alpha: 1.0)].map{$0.cgColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //MARK :- Method to add progress indicator on window
    
    class func addLoadIndicator(){
        let loadView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,  height: UIScreen.main.bounds.size.height))
        loadView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        let button = UIButton(frame: CGRect(x: 30, y: UIScreen.main.bounds.size.height - (60), width: UIScreen.main.bounds.size.width - 60,  height: 40.0))
        button.setTitle("Please wait", for: UIControlState())
        button.isHidden = true
        button.backgroundColor = kOrangeColor
        button.layer.cornerRadius = 18
        button.tag = indicatorViewTag+1
        let image = UIImageView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 20, y: (UIScreen.main.bounds.size.height/2) - 20, width: 40, height: 40))
        image.setFAIconWithName(FAType.faSpinner, textColor: .white)
        image.tag = indicatorViewTag+2
        loadView.tag = indicatorViewTag
        //        image.rotate360Degrees(image)
        rotateView(image)
        image.startAnimating()
        loadView.addSubview(button)
        loadView.addSubview(image)
        APPDELEGATE.window?.addSubview(loadView)
    }
    
    class func rotateView(_ targetView: UIImageView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
        }) { finished in
            self.rotateView(targetView, duration: duration)
        }
    }
    
    //MARK :- Method to remove progress indicator from window
    
    class func removeLoadIndicator(){
        APPDELEGATE.window?.viewWithTag(indicatorViewTag)?.viewWithTag(indicatorViewTag+2)?.removeFromSuperview()
        APPDELEGATE.window?.viewWithTag(indicatorViewTag)?.viewWithTag(indicatorViewTag+1)?.removeFromSuperview()
        APPDELEGATE.window?.viewWithTag(indicatorViewTag)?.removeFromSuperview()
    }
    
    //MARK :- Method to add error toast on window
    
    class func addErrorToast(_ errorMessage : String , controller : UIViewController){
        let errorView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,  height: errorMessage.characters.count > 120 ? 84 : 64))
        errorView.backgroundColor = UIColor.black
        errorView.alpha = 0.8
        errorView.tag = errorToastViewTag
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width,  height: errorMessage.characters.count > 120 ? 64 : 44))
        errorLabel.tag = errorToastViewTag+1
        errorLabel.font = UIFont.boldSystemFont(ofSize: 11.0)
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.textAlignment = NSTextAlignment.center
        errorLabel.numberOfLines = 4
        errorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        errorLabel.textColor = UIColor.white
        errorLabel.text = errorMessage
        errorView.addSubview(errorLabel)
        APPDELEGATE.window!.addSubview(errorView)
    }
    
    //MARK :- Method to remove error toast from window
    
    class func removeErrorToast(){
        APPDELEGATE.window!.viewWithTag(errorToastViewTag)?.viewWithTag(errorToastViewTag+1)?.removeFromSuperview()
        APPDELEGATE.window!.viewWithTag(errorToastViewTag)?.removeFromSuperview()
    }
    
    //MARK :- Method to show alertView Controller
    
    class func showAlertMessage(_ message:String, withTitle :String, delegate:UIViewController){
        let alertController = UIAlertController(title:withTitle , message:message , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alertController.addAction(OKAction)
        delegate.present(alertController, animated: true) { }
    }
    
    class func sendToLoginScreenWithAlert(_ delegate:UIViewController){
        let alertController = UIAlertController(title:"Invalid Access" , message:"Please Login to access your account" , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navC = UINavigationController(rootViewController: sideMenuController)
            ModelManager.singleton.loginData = nil
            TechUserDefault.singleton.removeUserCredential()
            APPDELEGATE.window?.rootViewController = navC
            APPDELEGATE.window?.makeKeyAndVisible()
        }
        alertController.addAction(OKAction)
        delegate.present(alertController, animated: true) { }
    }
    
    //MARK :- Method to check internet connection
    
    class func isConnectedToNetwork() -> Bool {
        
        //        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        //        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        //        zeroAddress.sin_family = sa_family_t(AF_INET)
        //
        //        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
        //            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        //        }
        //
        //        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        //        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        //            return false
        //        }
        //
        //        let isReachable = flags == .Reachable
        //        let needsConnection = flags == .ConnectionRequired
        ////
        //        return isReachable && !needsConnection
        
        do {
            let reachability = Reachability()
            let networkStatus: Int = reachability!.currentReachabilityStatus.hashValue
            
            return (networkStatus != 0)
        }
        catch {
            // Handle error however you please
            return false
        }
    }
    
    
    //MARK :- Method to create color from hex string
    
    class func colorWithHexString (_ hex:String) -> UIColor {
//        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    class func toUint(_ signed: Int) -> UInt {
        
        let unsigned = signed >= 0 ?
            UInt(signed) :
            UInt(signed  - Int.min) + UInt(Int.max) + 1
        
        return unsigned
    }
    
    class func drawerComponentFromJson() ->NSMutableArray
    {
        let json = readJsonFromFile("manager", extention: "geojson")
        //        let json = readJsonFromFile(ModelManager.singleton.loginData == nil ? "non-user" : "manager", extention: "geojson")

        let menuArray = NSMutableArray()
        
        for leftDrawerForIterate in json
        {
            //            let leftDrawer = LeftDrawerItemsGroup.init(leftDrawerForIterate as! Dictionary<String, AnyObject>)
            let leftDrawer = LeftDrawerItemsGroup(dictionary: leftDrawerForIterate as! Dictionary<String, AnyObject>)
            
            menuArray.add(leftDrawer)
        }
        return menuArray;
        
    }
    
    class func readJsonFromFile (_ fileName : String, extention :String) -> NSArray
    {
        let fileroot = Bundle.main.path(forResource: fileName, ofType: extention)
        let content : String = try! String(contentsOfFile: fileroot! , encoding: String.Encoding.utf8)
        let data = content.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        if JSONSerialization.isValidJSONObject(content) {
            //            print("cdsfdsfg")
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            //                print(json)
            let arr = json as! [AnyObject]
            //                print(arr)
            return arr as NSArray
        } catch {
            print("error serializing JSON: \(error)")
        }
        return [];
    }
    
    class func readJsonFromFileDict (_ fileName : String, extention :String) -> NSMutableDictionary
    {
        let fileroot = Bundle.main.path(forResource: fileName, ofType: extention)
        let content : String = try! String(contentsOfFile: fileroot! , encoding: String.Encoding.utf8)
        let data = content.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return (json as! NSDictionary).mutableCopy() as! NSMutableDictionary
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return NSMutableDictionary();
    }
    
    
    class func jsonStringWithJSONObject(_ jsonObject: AnyObject) -> String? {
        let data: Data? = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        var jsonStr: String?
        if data != nil {
            jsonStr = String(data: data!, encoding: String.Encoding.utf8)
        }
        
        return jsonStr
    }
    
    class func getRandomNumber() -> UInt {
        let timeSec = UInt(Date().timeIntervalSinceReferenceDate)
        return UInt(arc4random_uniform(UInt32(timeSec)))
    }
    
    
    class func convert24HrInto12Hr(_ timeValue : NSNumber ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let date12 = dateFormatter.date(from: String(format: "%d", timeValue == NSNull() ? 0 : timeValue.intValue))!
        
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date12)
    }
        
    class func stringFromDate(_ rawDate: Date, format:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: rawDate)
    }
    
    class func yearsBetweenDates(_ startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        let unit:NSCalendar.Unit = .year
        let components = (calendar as NSCalendar).components(unit, from: startDate, to: endDate, options: [])
        return components.year!
    }
    
    class func returnDateFromString(_ dateString: String, format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)
    }
    
    
    //    class func jsonStringWithJSONObject(jsonObject: AnyObject) -> NSString? {
    //        let data : NSData = try! NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions())
    //        let datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
    //
    //        return datastring
    //    }
    
    class func getDynamicHeight(_ string:String ,width:CGFloat) -> CGFloat{
        
        var attrString = NSMutableAttributedString()
        attrString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12.0)])
        let rect:CGRect = attrString.boundingRect(with: CGSize(width: width,height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
    class func getDynamicHeightLabel(_ string:String ,width:CGFloat, fontSize : CGFloat) -> CGFloat{
        
        var attrString = NSMutableAttributedString()
        attrString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)])
        let rect:CGRect = attrString.boundingRect(with: CGSize(width: width,height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )
        let requredSize:CGRect = rect
        return requredSize.height
    }

    
    class func getDynamicWidth(_ string:String ,height:CGFloat) -> CGFloat{
        
        var attrString = NSMutableAttributedString()
        attrString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)])
        let rect:CGRect = attrString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
    
    
    class func getPushAnimation() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

        return transition
    }
    
    class func saveAssignment(_ data: Data , name : String , entityName : String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(data, forKey: "file")
        person.setValue(name, forKey: "name")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = true
        self.clipsToBounds = true
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}

