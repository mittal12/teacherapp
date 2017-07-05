//
//  TourViewController.swift
//  TalentEdge
//
//

import UIKit

class TourViewController: UIViewController {
    
    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var skipButtonOutlet : UIButton?

    var pageControl : UIPageControl! = nil
    var pageNumber = 0
    var timer = Timer()

    let imageArray = ["1.png","2.png","3.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        scrollView?.contentSize = CGSize(width: UIScreen.main.bounds.size.width*CGFloat(imageArray.count), height: UIScreen.main.bounds.size.height - 0)
        pageControl = UIPageControl(frame: CGRect(x: 0 ,y: 0 , width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 0))
        pageControl.backgroundColor = .clear
        
        pageControl.numberOfPages = imageArray.count
        pageControl.addTarget(self, action: #selector(pageChange), for: .valueChanged)
        //
        var x : CGFloat = 0
        
        for i in 0..<imageArray.count {
            let imageView = UIImageView(frame: CGRect(x: x + 0 ,y: 0 , width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 0))
            //            imageView.contentMode = .ScaleAspectFit
            imageView.tag = i
            imageView.image = UIImage(named: imageArray[i])
            scrollView?.addSubview(imageView)
            
            x = x + UIScreen.main.bounds.size.width
        }
        self.view.addSubview(pageControl)
        skipButtonOutlet?.didMoveToSuperview()

        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(TourViewController.pageChange), userInfo: nil, repeats: true)
//        timer = NSTimer(fireDate: NSDate(), interval: 2.0, repeats: true, block: { (timer) in
//            self.pageChange()
//        })
//        timer.fire()
//        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, repeats: true, block: { (timer) in
//            
////            if self.pageNumber == 2 {
////                print ("sxfkjshlvasl")
////            }
//            
//            self.pageChange()
//            
//            
//        })
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
    }
    
    func pageChange(){
//        pageNumber = pageControl.currentPage
        
        if pageNumber == 2 {
            skipButtonAction(UIButton())
            timer.invalidate()
        } else {
        
            pageNumber = pageNumber == 2 ? 0 : pageNumber + 1
            var frame = scrollView?.frame
            frame?.origin.x = (frame?.size.width)! * CGFloat(pageNumber)
            frame?.origin.y = 0
            scrollView?.scrollRectToVisible(frame!, animated: true)
        }
        
        skipButtonOutlet?.didMoveToSuperview()
        
        
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView){
//        let viewWidth = scrollView.frame.size.width
//        let pageNumber = floor((scrollView.contentOffset.x - viewWidth/50)/viewWidth) + 1
//        
//        pageControl.currentPage = Int(pageNumber)
//    }
    
    @IBAction func skipButtonAction(_ sender: AnyObject) {
        timer.invalidate()
        UserDefaults.standard.setValue(true, forKey: "isTourViewSeen")
        self.view.endEditing(true)
        let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //        APPDELEGATE.window?.rootViewController = sideMenuController
        //        APPDELEGATE.window?.makeKeyAndVisible()
        
        self.navigationController?.pushViewController(sideMenuController, animated: false)
    }
}
