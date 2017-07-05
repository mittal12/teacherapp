//
//  AssignmentViewViewController.swift
//  TalentEdge
//
//

import UIKit

class AssignmentViewViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var imageNumLabel: UILabel!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var downloadButtonOutlet: UIButton!
    @IBOutlet weak var subNavTitleLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    var pageImages:[UIImage] = [UIImage]()
    var pageViews:[UIView?] = [UIView]()
    
    var imageArray : [UIImage]!

    var mainScrollView: UIScrollView!
    var pageScrollViews:[UIScrollView?] = [UIScrollView]()
    
    
    var currentPageView: UIView!
    
    
    var pageControl : UIPageControl = UIPageControl() //frame: CGRectMake(50, 300, 200, 50))
    
    
    let viewForZoomTag = 1
    
    var mainScrollViewContentSize: CGSize!

    var moduleData : TEModuleDetailData!

    var noteObj : TENotes!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            subNavTitleLabel.text = moduleData == nil ? self.selectedCourseObj.name : self.moduleData.module_name
        //        DataUtils.addTitleToNavigation(self.navigationItem, withTitle: "Gallery")
        likeLabel.isHidden = !noteObj.like.boolValue
        likeLabel.isHidden = !noteObj.allow_download.boolValue
        likeButtonOutlet.isUserInteractionEnabled = !noteObj.like.boolValue
        imageNumLabel.text = String(format : "1/%d", noteObj.note.count)
            
            mainScrollView = UIScrollView(frame: self.subView.bounds)
            
            mainScrollView.isPagingEnabled = true
            mainScrollView.showsHorizontalScrollIndicator = false
            mainScrollView.showsVerticalScrollIndicator = false
            
            pageScrollViews = [UIScrollView?](repeating: nil, count: noteObj.note.count)
            
            
            let innerScrollFrame = mainScrollView.bounds
            
            mainScrollView.contentSize =
                CGSize(width: innerScrollFrame.origin.x + innerScrollFrame.size.width,
                           height: mainScrollView.bounds.size.height)
            
            
            
            
            mainScrollView.backgroundColor = UIColor.white
            
            mainScrollView.delegate = self
            
            self.subView.addSubview(mainScrollView)
            
            configScrollView()
            addPageControlOnScrollView()
    }
    
    @IBAction func backButtonAction(_ sender : UIButton) {
     _ =   self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
                loadVisiblePages()
    }
    
    
    
    func configScrollView() {
        
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * CGFloat(noteObj.note.count),
                                                     height: self.mainScrollView.frame.height)
        
        mainScrollViewContentSize = mainScrollView.contentSize
        }
    
    
    func addPageControlOnScrollView() {
        
        
        
        self.pageControl.numberOfPages = noteObj.note.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        
        pageControl.addTarget(self, action: #selector(self.changePage(_:)), for: UIControlEvents.valueChanged)
        
        
        self.pageControl.frame = CGRect(x: 0, y: self.view.frame.maxY - 84, width: self.view.frame.width, height: 44)
        
        //self.pageControl.backgroundColor = UIColor.yellowColor()
        
        self.view.addSubview(pageControl)
        
    }
    
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(_ sender: AnyObject) -> () {
        
        let x = CGFloat(pageControl.currentPage) * mainScrollView.frame.size.width
        mainScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        loadVisiblePages()
        currentPageView = pageScrollViews[pageControl.currentPage]
        
    }
    
    func getViewAtPage(_ page: Int) -> UIView! {
        
        //        print("\(__FUNCTION__) \(page)")
        let obj : TENoteContent = noteObj.note[page] as! TENoteContent
        //imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
//        let imageForZooming = UIImageView(frame: CGRectMake(0 ,0 , UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 30))
        
        
        let imageForZooming = UIImageView(image: UIImage(data: try! Data(contentsOf: (URL(string: IMAGE_URL + obj.content_path))! )))
//        let imageForZooming = UIImageView(image: UIImage(named: "2016-12-13-1913202016-11-19-120009Project_management-0.png"))
//        imageForZooming.sd_setImageWithURL((NSURL(string: IMAGE_URL + obj.content_path)), placeholderImage: UIImage(named: "2016-12-13-1913202016-11-19-120009Project_management-0.png"))
                                imageForZooming.contentMode = .scaleAspectFit
//        imageForZooming.sd_setImageWithURL((NSURL(string: IMAGE_URL + obj.content_path)), placeholderImage: UIImage(named: "1.jpg"))

        var innerScrollFrame = mainScrollView.bounds
        
        if page < noteObj.note.count {
            innerScrollFrame.origin.x = innerScrollFrame.size.width * CGFloat(page)
        }
        
        imageForZooming.tag = viewForZoomTag
        
        let pageScrollView = UIScrollView(frame: innerScrollFrame)
        
        //        print("pageScrollView=\(pageScrollView)")
        //        print("innerScrollFrame=\(innerScrollFrame)")
        
        
        pageScrollView.contentSize = imageForZooming.bounds.size
        
        pageScrollView.delegate = self
        
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.showsHorizontalScrollIndicator = false
        
        pageScrollView.addSubview(imageForZooming)
        //        setZoomScale(pageScrollView)
        
        //mainScrollView.addSubview(pageScrollView)
        
        
        
        return pageScrollView
        
    }
    
    
    
    func setZoomScale(_ scrollView: UIScrollView) {
        
        
        let imageView = scrollView.viewWithTag(self.viewForZoomTag)
        
        let imageViewSize = imageView!.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    
    func loadVisiblePages() {
        let currentPage = pageControl.currentPage
        let previousPage =  currentPage > 0 ? currentPage - 1 : 0
        let nextPage = currentPage + 1 > pageControl.numberOfPages ? currentPage : currentPage + 1
        
        //        print("\(previousPage)-\(currentPage)-\(nextPage)")
        
        
        for page in 0..<previousPage {
            purgePage(page)
        }
        
//        for var page = nextPage + 1; page < pageControl.numberOfPages; page = page + 1 {
//            purgePage(page)
//        }
        
        for page in (nextPage + 1)..<pageControl.numberOfPages {
            purgePage(page)
        }
        
        for page in previousPage...nextPage {
            purgePage(page)
        }
       
        
        
//        for page = nextPage + 1 where page < pageControl.numberOfPages {
//            
//        }
        
//        for var page = previousPage; page <= nextPage; page += 1 {
//            loadPage(page)
//        }
        
    }
    
    
    
    func loadPage(_ page: Int) {
        
        if page < 0 || page >= pageControl.numberOfPages {
            return
        }
        
        if let pageScrollView = pageScrollViews[page] {
            setZoomScale(pageScrollView)
            
        }
        else {
            let pageScrollView = getViewAtPage(page) as! UIScrollView
            
            setZoomScale(pageScrollView)
            
            mainScrollView.addSubview(pageScrollView)
            pageScrollViews[page] = pageScrollView
        }
        
    }
    
    
    func purgePage(_ page: Int) {
        
        //        print("\(__FUNCTION__) \(page)")
        
        if page < 0 || page >= pageScrollViews.count {
            
            //            print("\(__FUNCTION__) \(page) abort.")
            
            return
        }
        
        //        print("\(__FUNCTION__) \(page) try...")
        
        if let pageView = pageScrollViews[page] {
            
            //            print("\(__FUNCTION__) \(page) done!")
            
            pageView.removeFromSuperview()
            pageScrollViews[page] = nil
        }
        else {
            
            //            print("\(__FUNCTION__) \(page) nil, ignore.")
            
        }
        
    }
    
    
    func centerScrollViewContents(_ scrollView: UIScrollView) {
        
        //        print("\(__FUNCTION__)")
        //        print("\(__FUNCTION__):scrollView.frame=\(scrollView.frame)")
        
        let imageView = scrollView.viewWithTag(self.viewForZoomTag)
        let imageViewSize = imageView!.frame.size
        //        print("\(__FUNCTION__):imageViewSize=\(imageViewSize)")
        
        let scrollViewSize = scrollView.bounds.size
        //        print("\(__FUNCTION__):scrollViewSize=\(scrollViewSize)")
        
        //        print("\(__FUNCTION__):scrollView.contentSize=\(scrollView.contentSize)")
        //        print("\(__FUNCTION__):scrollView.zoomScale=\(scrollView.zoomScale)")
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ?
            (scrollViewSize.height - imageViewSize.height) / 2 : 0
        
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ?
            (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding)
    }
    
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //        print("\(__FUNCTION__)")
        centerScrollViewContents(scrollView)
    }
//
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(viewForZoomTag)
        
        
    }
    
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        print("\(__FUNCTION__)")
    //    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("\(#function)")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("\(#function)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("\(#function)")
        //        loadVisiblePages()
        
        
        //        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        //        pageControl.currentPage = Int(pageNumber)
        //
        //        print("\(__FUNCTION__):pageControl.currentPage=\(pageControl.currentPage)")
        //
        //        loadVisiblePages()
        //        currentPageView = pageViews[pageControl.currentPage]
        //
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = targetContentOffset.pointee.x
        let zoomRatio = scrollView.contentSize.height / mainScrollViewContentSize.height
        if zoomRatio == 1 {
            let mainScrollViewWidthPerPage = mainScrollViewContentSize.width / CGFloat(pageControl.numberOfPages)
            let currentPage = targetOffset / (mainScrollViewWidthPerPage * zoomRatio)
            pageControl.currentPage = Int(currentPage)
            loadVisiblePages()
        }
        else {
            let mainScrollViewWidthPerPage = mainScrollViewContentSize.width / CGFloat(pageControl.numberOfPages)
            let currentPage = targetOffset / (mainScrollViewWidthPerPage * zoomRatio)
            
            print(" currentPage=\(currentPage)")
            
            
            //            pageControl.currentPage = Int(currentPage)
            //            
            //            loadVisiblePages()
            
        }
}

    @IBAction func likeButtonAction (_ sender: AnyObject) {
        let obj : TENoteContent = noteObj.note[0] as! TENoteContent
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",obj.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_LIKE_CONTENT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    @IBAction func downloadButtonAction (_ sender: AnyObject) {
        let imageView = UIImageView()
        let obj : TENoteContent = noteObj.note[0] as! TENoteContent
        imageView.sd_setImage(with: URL(string: IMAGE_URL + obj.content_path)) { (image, error, nil, url) in
            let imageRepresentation = UIImagePNGRepresentation(imageView.image!)
            let imageData = UIImage(data: imageRepresentation!)
            UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
            
            let alert = UIAlertController(title: "Completed", message: "Image has been saved!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
}
