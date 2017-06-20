//
//  Agrume.swift
//  Agrume
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public protocol AgrumeDataSource {
    
    /// The number of images contained in the data source
    var numberOfImages: Int { get }
    
    /// Return the image for the passed in image
    ///
    /// - Parameter index: The index (collection view item) being displayed
    /// - Parameter completion: The completion that returns the image to be shown at the index
    func imageForIndex(_ index: Int, completion: (UIImage?) -> Void)
    
}

public final class Agrume: UIViewController {
    
    fileprivate static let TransitionAnimationDuration: TimeInterval = 0.3
    fileprivate static let InitialScalingToExpandFrom: CGFloat = 0.6
    fileprivate static let MaxScalingForExpandingOffscreen: CGFloat = 1.25
    
    fileprivate static let ReuseIdentifier = "ReuseIdentifier"
    
    fileprivate var images: [UIImage]!
    fileprivate var imageURLs: [URL]!
    fileprivate var imageIDS: [NSNumber]!

    fileprivate var startIndex: Int?
    fileprivate var notesObject: TENotes!
    fileprivate var moduleData : TEModuleDetailData!
    fileprivate let backgroundBlurStyle: UIBlurEffectStyle
    fileprivate let dataSource: AgrumeDataSource?
    
    var imageIndexArray = [Int]()
    
    public typealias DownloadCompletion = (_ image: UIImage?) -> Void
    
    public var didDismiss: (() -> Void)?
    public var didScroll: ((_ index: Int) -> Void)?
    public var download: ((_ url: URL, _ completion: DownloadCompletion) -> Void)?
    
//    public convenience init(image: UIImage, backgroundBlurStyle: UIBlurEffectStyle? = .Dark) {
//        self.init(image: image, imageURL: nil, backgroundBlurStyle: backgroundBlurStyle,noteObject:TENotes(),moduleObject:TEModuleDetailData())
//    }
//    
//    public convenience init(imageURL: NSURL, backgroundBlurStyle: UIBlurEffectStyle? = .Dark) {
//        self.init(image: nil, imageURL: imageURL, backgroundBlurStyle: backgroundBlurStyle,noteObject:TENotes(),moduleObject:TEModuleDetailData())
//    }
//    
//    public convenience init(dataSource: AgrumeDataSource, startIndex: Int? = nil,
//                            backgroundBlurStyle: UIBlurEffectStyle? = .Dark) {
//        self.init(image: nil, images: nil, dataSource: dataSource, startIndex: startIndex,
//                  backgroundBlurStyle: backgroundBlurStyle,noteObject:TENotes(),moduleObject:TEModuleDetailData())
//    }
//    
//    public convenience init(images: [UIImage], startIndex: Int? = nil, backgroundBlurStyle: UIBlurEffectStyle? = .Dark) {
//        self.init(image: nil, images: images, startIndex: startIndex, backgroundBlurStyle: backgroundBlurStyle, noteObject:TENotes(),moduleObject:TEModuleDetailData())
//    }
    
    public convenience init(imageURLs: [URL],imageIDS: [NSNumber], startIndex: Int? = nil, backgroundBlurStyle: UIBlurEffectStyle? = .dark , noteObject : TENotes,moduleObject : TEModuleDetailData?) {
        self.init(image: nil, imageURLs: imageURLs, startIndex: startIndex, backgroundBlurStyle: backgroundBlurStyle, noteObject:noteObject, moduleObject:moduleObject, imageIDS : imageIDS)
    }
    
    fileprivate init(image: UIImage? = nil, imageURL: URL? = nil, images: [UIImage]? = nil,
                 dataSource: AgrumeDataSource? = nil, imageURLs: [URL]? = nil, startIndex: Int? = nil,
                 backgroundBlurStyle: UIBlurEffectStyle? = .dark, noteObject : TENotes?, moduleObject : TEModuleDetailData? , imageIDS: [NSNumber]?) {
        assert(backgroundBlurStyle != nil)
        self.images = images
        if let image = image {
            self.images = [image]
        }
        self.imageURLs = imageURLs
        if let imageURL = imageURL {
            self.imageURLs = [imageURL]
        }
        self.imageIDS = imageIDS
        
        self.notesObject = noteObject
        self.moduleData = moduleObject
        self.dataSource = dataSource
        self.startIndex = startIndex
        self.backgroundBlurStyle = backgroundBlurStyle!
        visibleIndexPath = IndexPath(item: 0, section: 0)
        super.init(nibName: nil, bundle: nil)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(Agrume.orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    deinit {
        downloadTask?.cancel()
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    fileprivate func frameForCurrentDeviceOrientation() -> CGRect {
        let bounds = view.bounds
        if UIDeviceOrientationIsLandscape(currentDeviceOrientation()) {
            if bounds.width / bounds.height > bounds.height / bounds.width {
                return bounds
            } else {
                return CGRect(origin: bounds.origin, size: CGSize(width: bounds.height, height: bounds.width))
            }
        }
        return bounds
    }
    
    fileprivate func currentDeviceOrientation() -> UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    fileprivate var backgroundSnapshot: UIImage!
    fileprivate var backgroundImageView: UIImageView!
    fileprivate lazy var blurContainerView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    fileprivate lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: self.backgroundBlurStyle))
        blurView.frame = self.view.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = self.view.frame.size
        
        let collectionView = UICollectionView(frame: CGRect(x: self.view.frame.origin.x, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height-104), collectionViewLayout: layout)
        collectionView.register(AgrumeCell.self, forCellWithReuseIdentifier: Agrume.ReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.delaysContentTouches = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    fileprivate var _countLabel: UILabel?
    var countLabel: UILabel {
        if _countLabel == nil {
            
            let countLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 20, y: 0, width: 40, height: 40))
            countLabel.text = String(format : "1/%d", imageURLs.count)
            countLabel.textAlignment = .center
            countLabel.textColor = UIColor.darkGray
            countLabel.font = UIFont.init(name: "Helvetica", size: 12.0)
            _countLabel = countLabel
        }
        return _countLabel!
    }
    
    
    fileprivate lazy var downloadSubview: UIView = {
        let downloadSubview = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height-40, width: self.view.frame.size.width, height: 40))
        let thumbLabel = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        thumbLabel.setImage(UIImage(named : "ic_thumb_up_blue.png"), for: UIControlState())
        thumbLabel.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        thumbLabel.tag = 102
        thumbLabel.isUserInteractionEnabled  = (self.notesObject.like_text == "")
        downloadSubview.addSubview(thumbLabel)
        let likeLabel = UILabel(frame: CGRect(x: 35, y: 0, width: 70, height: 40))
        likeLabel.text = "You liked it"
        likeLabel.tag = 101
        likeLabel.font = UIFont.init(name: "Helvetica", size: 12.0)
        downloadSubview.addSubview(likeLabel)
        
        downloadSubview.backgroundColor = kGrayColor
        if self.notesObject.allow_download.boolValue == true {
            let downloadButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 100, y: 0, width: 100, height: 40))
            downloadButton.setTitle("Download", for: UIControlState())
            downloadButton.titleLabel?.font = UIFont.init(name: "Helvetica", size: 15.0)
            downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
            downloadButton.setTitleColor(UIColor.darkGray, for: UIControlState())
            downloadSubview.addSubview(downloadButton)
            
        }
        return downloadSubview
    }()
    
    fileprivate lazy var navigationSubview: UIView = {
        let navigationSubview = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 64))
        let backButton = UIButton(frame: CGRect(x: 10, y: 20, width: 30, height: 40))
        backButton.setImage(UIImage(named: "back_arrow_white.png"), for: UIControlState())
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationSubview.addSubview(backButton)
        let titleLabel = UILabel(frame: CGRect(x: 55, y: 20, width: self.view.frame.size.width-50, height: 28))
        titleLabel.text = "Reference Notes"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        navigationSubview.addSubview(titleLabel)
        let subTitleLabel : UILabel = UILabel(frame: CGRect(x: 45, y: 45, width: self.view.frame.size.width-50, height: 20))
        subTitleLabel.text = self.moduleData.module_name
        subTitleLabel.textColor = .white
        subTitleLabel.font = UIFont.systemFont(ofSize: 13.0)
        navigationSubview.addSubview(subTitleLabel)
        //        let downloadButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 100, y: 0, width: 100, height: 40))
        //        downloadButton.setTitle("Download", forState: .Normal)
        //        downloadButton.titleLabel?.font = UIFont.init(name: "Helvetica", size: 12.0)
        
        //        navigationSubview.addSubview(downloadButton)
        navigationSubview.backgroundColor = kNavigationBarColor
        
        return navigationSubview
    }()
    
    fileprivate lazy var spinner: UIActivityIndicatorView = {
        let activityIndicatorStyle: UIActivityIndicatorViewStyle = self.backgroundBlurStyle == .dark ? .whiteLarge : .gray
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
        spinner.center = self.view.center
        spinner.startAnimating()
        spinner.alpha = 0
        return spinner
    }()
    
    
    fileprivate var downloadTask: URLSessionDataTask?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = backgroundSnapshot
        view.addSubview(backgroundImageView)
        blurContainerView.addSubview(blurView)
        view.addSubview(blurContainerView)
        view.addSubview(collectionView)
        downloadSubview.addSubview(countLabel)
        view.addSubview(downloadSubview)
        view.addSubview(navigationSubview)
//        view.viewWithTag(101)?.hidden = !self.notesObject.like.boolValue
        imageIndexArray.append(imageIDS[0].intValue)
        if let index = startIndex {
            collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: [],
                                                   animated: false)
        }
        view.addSubview(spinner)
    }
    
    func dismiss() {
        dismissAfterFlick()
    }
    
    func likeButtonAction () {
        //        let obj : TENoteContent = notesObject.note[0] as! TENoteContent
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        let str = String(format: "content_id=%d",notesObject.id.intValue)
        ServerCommunication.singleton.requestWithPost(API_LIKE_CONTENT ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            if successResponseDict.value(forKey: "message") as! String == "Success" {
                self.notesObject.like = NSNumber(value: self.notesObject.like.boolValue ? 0 : 1 as Int)
                self.view.viewWithTag(101)?.isHidden = false
                self.view.viewWithTag(102)?.isUserInteractionEnabled = false
                self.notesObject.like = NSNumber(value: self.notesObject.like.boolValue ? 0 : 1 as Int)
            }
        }) { (errorResponseDict) -> Void in
            DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    
    func downloadButtonAction () {
        //        let arr = collectionView.indexPathsForVisibleItems()
        downloadImage(imageURLs[visibleIndexPath.row]){ (image) in
            let imageRepresentation = UIImagePNGRepresentation(image!)
            let imageData = UIImage(data: imageRepresentation!)
            UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
            let alert = UIAlertController(title: "Completed", message: "Image has been saved!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate var lastUsedOrientation: UIDeviceOrientation?
    
    public override func viewWillAppear(_ animated: Bool) {
        lastUsedOrientation = currentDeviceOrientation()
    }
    
    fileprivate func deviceOrientationFromStatusBarOrientation() -> UIDeviceOrientation {
        return UIDeviceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!
    }
    
    fileprivate var initialOrientation: UIDeviceOrientation!
    
    public func showFrom(_ viewController: UIViewController) {
        backgroundSnapshot = UIApplication.shared.delegate?.window??.rootViewController?.view.snapshot()
        view.frame = frameForCurrentDeviceOrientation()
        view.isUserInteractionEnabled = false
        initialOrientation = deviceOrientationFromStatusBarOrientation()
        updateLayoutsForCurrentOrientation()
        
        DispatchQueue.main.async {
            self.collectionView.alpha = 0
            self.downloadSubview.alpha = 0
            self.navigationSubview.alpha = 0
            self.collectionView.frame = CGRect(x: self.view.frame.origin.x, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height-104)
            let scaling = Agrume.InitialScalingToExpandFrom
            self.collectionView.transform = CGAffineTransform(scaleX: scaling, y: scaling)
            self.downloadSubview.transform = CGAffineTransform(scaleX: scaling, y: scaling)
            self.navigationSubview.transform = CGAffineTransform(scaleX: scaling, y: scaling)
            viewController.present(self, animated: false) {
                UIView.animate(withDuration: Agrume.TransitionAnimationDuration,
                                           delay: 0,
                                           options: .beginFromCurrentState,
                                           animations: { [weak self] in
                                            self?.collectionView.alpha = 1
                                            self?.collectionView.transform = CGAffineTransform.identity
                                            self?.downloadSubview.alpha = 1
                                            self?.downloadSubview.transform = CGAffineTransform.identity
                                            self?.navigationSubview.alpha = 1
                                            self?.navigationSubview.transform = CGAffineTransform.identity
                                            
                    }, completion: { [weak self] finished in
                        self?.view.isUserInteractionEnabled = finished
                    })
            }
        }
    }
    
    func backButtonAction() {
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        var string = ""
        for item in imageIndexArray {
            string = string + String(format: "%d,",item)
        }
        
        let str = String(format: "content_id=%d&notes_id=%@",self.notesObject.id.intValue, string)
        ServerCommunication.singleton.requestWithPost(API_VIEW_NOTES_ACK ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            print(successResponseDict)
            self.dismissAfterFlick()
        }) { (errorResponseDict) -> Void in
//            DataUtils.showAlertMessage(errorResponseDict.valueForKey("errDesc") as! String, withTitle: "", delegate: self)
        }
    }
    
    public func showImageAtIndex(_ index : Int) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: [],
                                               animated: true)
    }
    
    public func reload() {
        DispatchQueue.main.async  {
            self.collectionView.reloadData()
        }
    }
    
    fileprivate var visibleIndexPath: IndexPath!
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        
        visibleRect.origin = self.collectionView.contentOffset
        visibleRect.size = self.collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint)!
        countLabel.text = String(format : "%d/%d",visibleIndexPath.row + 1, imageURLs.count)
        if !(imageIndexArray.contains(imageIDS[visibleIndexPath.row].intValue)) {
            imageIndexArray.append(imageIDS[visibleIndexPath.row].intValue)
        }
        print(visibleIndexPath)
        
    }
    
}

extension Agrume {
    
    // MARK: Rotation
    
    @objc fileprivate func orientationDidChange() {
        let orientation = currentDeviceOrientation()
        guard let lastOrientation = lastUsedOrientation else { return }
        let landscapeToLandscape = UIDeviceOrientationIsLandscape(orientation) && UIDeviceOrientationIsLandscape(lastOrientation)
        let portraitToPortrait = UIDeviceOrientationIsPortrait(orientation) && UIDeviceOrientationIsPortrait(lastOrientation)
        guard (landscapeToLandscape || portraitToPortrait) && orientation != lastUsedOrientation else { return }
        lastUsedOrientation = orientation
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.updateLayoutsForCurrentOrientation()
        }) 
    }
    
    public override func viewWillTransition(to size: CGSize,
                                                  with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateLayoutsForCurrentOrientation()
            }, completion: { [weak self] _ in
                self?.lastUsedOrientation = self?.deviceOrientationFromStatusBarOrientation()
            })
    }
    
    fileprivate func updateLayoutsForCurrentOrientation() {
        var transform = CGAffineTransform.identity
        if initialOrientation == .portrait {
            switch (currentDeviceOrientation()) {
            case .landscapeLeft:
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            case .landscapeRight:
                transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            case .portraitUpsideDown:
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            default:
                break
            }
        } else if initialOrientation == .portraitUpsideDown {
            switch (currentDeviceOrientation()) {
            case .landscapeLeft:
                transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            case .landscapeRight:
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            case .portrait:
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            default:
                break
            }
        } else if initialOrientation == .landscapeLeft {
            switch (currentDeviceOrientation()) {
            case .landscapeRight:
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            case .portrait:
                transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            case .portraitUpsideDown:
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            default:
                break
            }
        } else if initialOrientation == .landscapeRight {
            switch (currentDeviceOrientation()) {
            case .landscapeLeft:
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            case .portrait:
                transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            case .portraitUpsideDown:
                transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
            default:
                break
            }
        }
        
        backgroundImageView.center = view.center
        backgroundImageView.transform = transform.concatenating(CGAffineTransform(scaleX: 1, y: 1))
        
        spinner.center = view.center
        
        collectionView.performBatchUpdates({ [unowned self] in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.frame = CGRect(x: self.view.frame.origin.x, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height-104)
            let width = self.collectionView.frame.width
            let page = Int((self.collectionView.contentOffset.x + (0.5 * width)) / width)
            let updatedOffset = CGFloat(page) * self.collectionView.frame.width
            self.collectionView.contentOffset = CGPoint(x: updatedOffset, y: self.collectionView.contentOffset.y)
            
            let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = self.view.frame.size
        }) { _ in
            for visibleCell in self.collectionView.visibleCells as! [AgrumeCell] {
                DispatchQueue.main.async(execute: { () -> Void in
                    visibleCell.updateScrollViewAndImageViewForCurrentMetrics()
                })
                
            }
        }
    }
    
}

extension Agrume: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.numberOfImages
        }
        return images?.count > 0 ? images.count : imageURLs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        downloadTask?.cancel()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Agrume.ReuseIdentifier,
                                                                         for: indexPath) as! AgrumeCell
        
        if let images = self.images {
            cell.image = images[indexPath.row]
        } else if let imageURLs = self.imageURLs {
            spinner.alpha = 1
            let completion: DownloadCompletion = { [weak self] image in
                cell.image = image
                self?.spinner.alpha = 0
            }
            
            if let download = download {
                download(imageURLs[indexPath.row], completion)
            } else {
                downloadImage(imageURLs[indexPath.row], completion: completion)
            }
        } else if let dataSource = self.dataSource {
            spinner.alpha = 1
            let index = indexPath.row
            
            dataSource.imageForIndex(index) { [weak self] image in
                DispatchQueue.main.async {
                    if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                        cell.image = image
                        self?.spinner.alpha = 0
                    }
                }
            }
        }
        // Only allow panning if horizontal swiping fails. Horizontal swiping is only active for zoomed in images
        collectionView.panGestureRecognizer.require(toFail: cell.swipeGesture)
        cell.dismissAfterFlick = dismissAfterFlick
//        cell.notesObject = self.notesObject
//        cell.viewedIndexArray = self.imageIndexArray
        cell.dismissByExpanding = dismissByExpanding
        return cell
    }
    
    fileprivate func downloadImage(_ url: URL, completion: @escaping DownloadCompletion) {
        downloadTask = ImageDownloader.downloadImage(url) { image in
            completion(image)
        }
    }
    
    fileprivate func dismissAfterFlick() {
        
        let headers : [String:String] = [
            "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
            "token": ModelManager.singleton.loginData.token,
            "deviceType": "IOS"
        ]
        var string = ""
        for item in imageIndexArray {
            string = string + String(format: "%d,",item)
        }
        
        let str = String(format: "content_id=%d&notes_id=%@",self.notesObject.id.intValue, string)
        ServerCommunication.singleton.requestWithPost(API_VIEW_NOTES_ACK ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
            UIView.animate(withDuration: Agrume.TransitionAnimationDuration,
                delay: 0,
                options: .beginFromCurrentState,
                animations: {
                    self.collectionView.alpha = 0
                    self.downloadSubview.alpha = 0
                    self.navigationSubview.alpha = 0
                    self.blurContainerView.alpha = 0
                }, completion: self.dismissCompletion)
//            self.dismissAfterFlick()
        }) { (errorResponseDict) -> Void in
//            DataUtils.showAlertMessage(errorResponseDict.valueForKey("errDesc") as! String, withTitle: "", delegate: self)
        }

           }
    
    fileprivate func dismissByExpanding() {
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: Agrume.TransitionAnimationDuration,
                                   delay: 0,
                                   options: .beginFromCurrentState,
                                   animations: {
                                    self.collectionView.alpha = 0
                                    self.downloadSubview.alpha = 0
                                    self.navigationSubview.alpha = 0
                                    self.blurContainerView.alpha = 0
                                    let scaling = Agrume.MaxScalingForExpandingOffscreen
                                    self.collectionView.transform = CGAffineTransform(scaleX: scaling, y: scaling)
                                    self.downloadSubview.transform = CGAffineTransform(scaleX: scaling, y: scaling)
                                    self.navigationSubview.transform = CGAffineTransform(scaleX: scaling, y: scaling)
            }, completion: dismissCompletion)
    }
    
    
    fileprivate func dismissCompletion(_ finished: Bool) {
        presentingViewController?.dismiss(animated: false) {
            self.didDismiss?()
        }
    }
    
}

extension Agrume: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {
        didScroll?(indexPath.row)
        
        if let dataSource = self.dataSource {
            let collectionViewCount = collectionView.numberOfItems(inSection: 0)
            let dataSourceCount = dataSource.numberOfImages
            
            // if dataSource hasn't changed the number of images then there is no need to reload (we assume that the same number shall result in the same data)
            guard collectionViewCount != dataSourceCount else { return }
            
            if indexPath.row >= dataSourceCount { // if the dataSource number of images has been decreased and we got out of bounds
                showImageAtIndex(dataSourceCount - 1)
                reload()
            } else if indexPath.row == collectionViewCount - 1 { // if we are at the last element of the collection but we are not out of bounds
                reload()
            }
        }
    }
}
