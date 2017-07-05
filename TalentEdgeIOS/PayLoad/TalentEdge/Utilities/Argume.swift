//
//  Argume.swift
//  TalentEdge
//
//  Created by Aditya Sharma on 26/04/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit


import Foundation

public class AgrumeServiceLocator {
    
    public static let shared = AgrumeServiceLocator()
    
    public typealias DownloadHandler = ((url: NSURL, completion: Agrume.DownloadCompletion -> Void) -> Void)
    
    var downloadHandler: DownloadHandler?
    
    /// Register a download handler with the service locator.
    /// Agrume will use this handler for all downloads. This can be overriden on a per call basis
    /// by passing in a different handler for said call.
    ///
    /// – Parameter handler: The download handler
    public func setDownloadHandler(handler: DownloadHandler -> Void) {
        downloadHandler = handler
    }
    
    /// Remove the global handler.
    public func removeDownloadHandler() {
        downloadHandler = nil
    }
    
}

public protocol AgrumeDataSource {
    
    /// The number of images contained in the data source
    var numberOfImages: Int { get }
    
    /// Return the image for the passed in index
    ///
    /// - Parameter index: The index (collection view item) being displayed
    /// - Parameter completion: The completion that returns the image to be shown at the index
    func image(forIndex index: Int, completion: (UIImage?) -> Void)
    
}

public final class Agrume: UIViewController {
    
    static let transitionAnimationDuration: NSTimeInterval = 0.3
    static let initialScalingToExpandFrom: CGFloat = 0.6
    static let maxScalingForExpandingOffscreen: CGFloat = 1.25
    static let reuseIdentifier = "reuseIdentifier"
    
    var images: [UIImage]!
    var imageUrls: [NSURL]!
    private var startIndex: Int?
    private let backgroundBlurStyle: UIBlurEffectStyle?
    private let backgroundColor: UIColor?
    let dataSource: AgrumeDataSource?
    
    public typealias DownloadCompletion = (image: UIImage?) -> Void
    
    /// Optional closure to call whenever Agrume is dismissed.
    public var didDismiss: (() -> Void)?
    /// Optional closure to call whenever Agrume scrolls to the next image in a collection. Passes the "page" index
    public var didScroll: ((index: Int) -> Void)?
    /// An optional download handler. Passed the URL that is supposed to be loaded. Call the completion with the image
    /// when the download is done.
    public var download: ((url: NSURL, completion:  DownloadCompletion-> Void) -> Void)?
    /// Status bar style when presenting
    public var statusBarStyle: UIStatusBarStyle? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    /// Hide status bar when presenting. Defaults to `false`
    public var hideStatusBar: Bool = false
    
    /// Initialize with a single image
    ///
    /// - Parameter image: The image to present
    /// - Parameter backgroundBlurStyle: The UIBlurEffectStyle to apply to the background when presenting
    /// - Parameter backgroundColor: The background color when presenting
    public convenience init(image: UIImage, backgroundBlurStyle: UIBlurEffectStyle? = nil, backgroundColor: UIColor? = nil) {
        self.init(image: image, imageUrl: nil, backgroundBlurStyle: backgroundBlurStyle, backgroundColor: backgroundColor)
    }
    
    /// Initialize with a single image url
    ///
    /// - Parameter imageUrl: The image url to present
    /// - Parameter backgroundBlurStyle: The UIBlurEffectStyle to apply to the background when presenting
    /// - Parameter backgroundColor: The background color when presenting
    public convenience init(imageUrl: NSURL, backgroundBlurStyle: UIBlurEffectStyle? = .Dark, backgroundColor: UIColor? = nil) {
        self.init(image: nil, imageUrl: imageUrl, backgroundBlurStyle: backgroundBlurStyle, backgroundColor: backgroundColor)
    }
    
    /// Initialize with a data source
    ///
    /// - Parameter dataSource: The `AgrumeDataSource` to use
    /// - Parameter startIndex: The optional start index when showing multiple images
    /// - Parameter backgroundBlurStyle: The UIBlurEffectStyle to apply to the background when presenting
    /// - Parameter backgroundColor: The background color when presenting
    public convenience init(dataSource: AgrumeDataSource, startIndex: Int? = nil,
                            backgroundBlurStyle: UIBlurEffectStyle? = .Dark, backgroundColor: UIColor? = nil) {
        self.init(image: nil, images: nil, dataSource: dataSource, startIndex: startIndex,
                  backgroundBlurStyle: backgroundBlurStyle, backgroundColor: backgroundColor)
    }
    
    /// Initialize with an array of images
    ///
    /// - Parameter images: The images to present
    /// - Parameter startIndex: The optional start index when showing multiple images
    /// - Parameter backgroundBlurStyle: The UIBlurEffectStyle to apply to the background when presenting
    /// - Parameter backgroundColor: The background color when presenting
    public convenience init(images: [UIImage], startIndex: Int? = nil, backgroundBlurStyle: UIBlurEffectStyle? = .Dark,
                            backgroundColor: UIColor? = nil) {
        self.init(image: nil, images: images, startIndex: startIndex, backgroundBlurStyle: backgroundBlurStyle,
                  backgroundColor: backgroundColor)
    }
    
    /// Initialize with an array of image urls
    ///
    /// - Parameter imageUrls: The image urls to present
    /// - Parameter startIndex: The optional start index when showing multiple images
    /// - Parameter backgroundBlurStyle: The UIBlurEffectStyle to apply to the background when presenting
    /// - Parameter backgroundColor: The background color when presenting
    public convenience init(imageUrls: [NSURL], startIndex: Int? = nil, backgroundBlurStyle: UIBlurEffectStyle? = .Dark,
                            backgroundColor: UIColor? = nil) {
        self.init(image: nil, imageUrls: imageUrls, startIndex: startIndex, backgroundBlurStyle: backgroundBlurStyle,
                  backgroundColor: backgroundColor)
    }
    
    private init(image: UIImage? = nil, imageUrl: NSURL? = nil, images: [UIImage]? = nil,
                 dataSource: AgrumeDataSource? = nil, imageUrls: [NSURL]? = nil, startIndex: Int? = nil,
                 backgroundBlurStyle: UIBlurEffectStyle? = nil, backgroundColor: UIColor? = nil) {
        switch (backgroundBlurStyle, backgroundColor) {
        case (let blur, .None):
            self.backgroundBlurStyle = blur
            self.backgroundColor = nil
        case (.None, let color):
            self.backgroundColor = color
            self.backgroundBlurStyle = nil
        default:
            self.backgroundBlurStyle = .Dark
            self.backgroundColor = nil
        }
        
        self.images = images
        if let image = image {
            self.images = [image]
        }
        self.imageUrls = imageUrls
        if let imageURL = imageUrl {
            self.imageUrls = [imageURL]
        }
        
        self.dataSource = dataSource
        self.startIndex = startIndex
        super.init(nibName: nil, bundle: nil)
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(orientationDidChange),
                                                         name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        downloadTask?.cancel()
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        required public init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
        }
        
        private func frameForCurrentDeviceOrientation() -> CGRect {
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
        
        private func currentDeviceOrientation() -> UIDeviceOrientation {
        return UIDevice.currentDevice().orientation
        }
        
        private var backgroundSnapshot: UIImage!
        private var backgroundImageView: UIImageView!
        var _blurContainerView: UIView?
        var blurContainerView: UIView {
            if _blurContainerView == nil {
                let view = UIView(frame: self.view.frame)
                view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                view.backgroundColor = backgroundColor ?? UIColor.clearColor()
                _blurContainerView = view
            }
            return _blurContainerView!
        }
        var _blurView: UIVisualEffectView?
        private var blurView: UIVisualEffectView {
            if _blurView == nil {
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: self.backgroundBlurStyle!))
                blurView.frame = self.view.frame
                blurView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                _blurView = blurView
            }
            return _blurView!
        }
        var _collectionView: UICollectionView?
        var collectionView: UICollectionView {
            if _collectionView == nil {
                let layout = UICollectionViewFlowLayout()
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                layout.scrollDirection = .Horizontal
                layout.itemSize = self.view.frame.size
                
                let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
                collectionView.registerClass(AgrumeCell.self, forCellWithReuseIdentifier: Agrume.reuseIdentifier)
                collectionView.dataSource = self
                collectionView.delegate = self
                collectionView.pagingEnabled = true
                collectionView.backgroundColor = .clearColor()
                collectionView.delaysContentTouches = false
                collectionView.showsHorizontalScrollIndicator = false
                _collectionView = collectionView
            }
            return _collectionView!
        }
        var _spinner: UIActivityIndicatorView?
        var spinner: UIActivityIndicatorView {
            if _spinner == nil {
                let activityIndicatorStyle: UIActivityIndicatorViewStyle = self.backgroundBlurStyle == UIBlurEffectStyle.Dark ? UIActivityIndicatorViewStyle.WhiteLarge : UIActivityIndicatorViewStyle.Gray
                let spinner = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
                spinner.center = self.view.center
                spinner.startAnimating()
                spinner.alpha = 0
                _spinner = spinner
            }
            return _spinner!
        }
        var downloadTask: NSURLSessionDataTask?
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            backgroundImageView = UIImageView(frame: view.frame)
            backgroundImageView.image = backgroundSnapshot
            view.addSubview(backgroundImageView)
        }
        
        private var lastUsedOrientation: UIDeviceOrientation?
        
        public override func viewWillAppear(animated: Bool) {
            lastUsedOrientation = currentDeviceOrientation()
        }
        
        func deviceOrientationFromStatusBarOrientation() -> UIDeviceOrientation {
            return UIDeviceOrientation(rawValue: UIApplication.sharedApplication().statusBarOrientation.rawValue)!
        }
        
        var initialOrientation: UIDeviceOrientation!
        
        public func showFrom(viewController: UIViewController, backgroundSnapshotVC: UIViewController? = nil) {
            backgroundSnapshot = (backgroundSnapshotVC ?? viewControllerForSnapshot(fromViewController: viewController))?.view.snapshot()
            view.frame = frameForCurrentDeviceOrientation()
            view.userInteractionEnabled = false
            addSubviews()
            initialOrientation = deviceOrientationFromStatusBarOrientation()
            updateLayoutsForCurrentOrientation()
            showFrom(viewController)
        }
        
        private func addSubviews() {
            if backgroundBlurStyle != nil {
                blurContainerView.addSubview(blurView)
            }
            view.addSubview(blurContainerView)
            view.addSubview(collectionView)
            if let index = startIndex {
                collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: [], animated: false)
            }
            view.addSubview(spinner)
        }
        
        private func showFrom(viewController: UIViewController) {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.blurContainerView.alpha = 1
                self.collectionView.alpha = 0
                self.collectionView.frame = self.view.frame
                let scaling = Agrume.initialScalingToExpandFrom
                self.collectionView.transform = CGAffineTransformMakeScale(scaling, scaling)
                
                viewController.presentViewController(self, animated: true, completion: {
                    UIView.animateWithDuration(Agrume.transitionAnimationDuration, delay: 0, options:[.BeginFromCurrentState], animations: {
                        self.collectionView.alpha = 1
                        self.collectionView.transform = CGAffineTransformIdentity
                        }, completion: { (true) in
                            self.view.userInteractionEnabled = true

                    })
                })
            })
        }
        
        func viewControllerForSnapshot(fromViewController viewController: UIViewController) -> UIViewController? {
            var presentingVC = viewController.view.window?.rootViewController
            while presentingVC?.presentedViewController != nil {
                presentingVC = presentingVC?.presentedViewController
            }
            return presentingVC
        }
        
        public func dismiss() {
            self.dismissAfterFlick()
        }
        
        public func showImage(atIndex index : Int) {
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: [], animated: true)
        }
        
        public func reload() {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
            })
        }
        
        public override var prefersStatusBarHidden: Bool {
            return hideStatusBar
        }
        
        // MARK: Rotation
        
        @objc private func orientationDidChange() {
            let orientation = currentDeviceOrientation()
            guard let lastOrientation = lastUsedOrientation else { return }
            let landscapeToLandscape = UIDeviceOrientationIsLandscape(orientation) && UIDeviceOrientationIsLandscape(lastOrientation)
            let portraitToPortrait = UIDeviceOrientationIsPortrait(orientation) && UIDeviceOrientationIsPortrait(lastOrientation)
            guard (landscapeToLandscape || portraitToPortrait) && orientation != lastUsedOrientation else { return }
            lastUsedOrientation = orientation
            UIView.animateWithDuration(0.6) { 
                 [weak self] in
                self!.updateLayoutsForCurrentOrientation()
            }
        }
    
        public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            coordinator.animateAlongsideTransition({ (context) in
                self.updateLayoutsForCurrentOrientation()
                }, completion: { (context) in
                    self.lastUsedOrientation = self.deviceOrientationFromStatusBarOrientation()
            })
        }
        
        private func updateLayoutsForCurrentOrientation() {
            let transform = newTransform()
            
            backgroundImageView.center = view.center
            backgroundImageView.transform = transform.concatenating(CGAffineTransform(scaleX: 1, y: 1))
            
            spinner.center = view.center
            
            collectionView.performBatchUpdates({ 
                [unowned self] in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.frame = self.view.frame
                let width = self.collectionView.frame.width
                let page = Int((self.collectionView.contentOffset.x + (0.5 * width)) / width)
                let updatedOffset = CGFloat(page) * self.collectionView.frame.width
                self.collectionView.contentOffset = CGPoint(x: updatedOffset, y: self.collectionView.contentOffset.y)
                
                let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                layout.itemSize = self.view.frame.size
                }) { (true) in
                    for visibleCell in self.collectionView.visibleCells as? [AgrumeCell] {
                        visibleCell.updateScrollViewAndImageViewForCurrentMetrics()
                    }
            }
            
                    }
        
        private func newTransform() -> CGAffineTransform {
            var transform: CGAffineTransform = CGAffineTransformIdentity
            if initialOrientation == .Portrait {
                switch (currentDeviceOrientation()) {
                case .LandscapeLeft:
                    transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
                case .LandscapeRight:
                    transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
                case .PortraitUpsideDown:
                    transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                default:
                    break
                }
            } else if initialOrientation == .PortraitUpsideDown {
                switch (currentDeviceOrientation()) {
                case .LandscapeLeft:
                    transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
                case .LandscapeRight:
                    transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
                case .Portrait:
                    transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                default:
                    break
                }
            } else if initialOrientation == .LandscapeLeft {
                switch (currentDeviceOrientation()) {
                case .LandscapeRight:
                    transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                case .Portrait:
                    transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
                case .PortraitUpsideDown:
                    transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
                default:
                    break
                }
            } else if initialOrientation == .LandscapeRight {
                switch (currentDeviceOrientation()) {
                case .LandscapeLeft:
                    transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                case .Portrait:
                    transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
                case .PortraitUpsideDown:
                    transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
                default:
                    break
                }
            }
            return transform
        }
        
    }
    
    extension Agrume: UICollectionViewDataSource {
        
        public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if let dataSource = dataSource {
                return dataSource.numberOfImages
            }
            if let images = images {
                return !images.isEmpty ? images.count : imageUrls.count
            }
            return imageUrls.count
        }
        
        public func collectionView(collectionView: UICollectionView,
                                     cellForItemAt indexPath: NSIndexPath) -> UICollectionViewCell {
            downloadTask?.cancel()
            
            let cell = collectionView.registerClass(AgrumeCell.self, forCellWithReuseIdentifier: Agrume.reuseIdentifier) as! AgrumeCell
            if let images = images {
                cell.image = images[indexPath.row]
            } else if let imageUrls = imageUrls {
                spinner.alpha = 1
                let completion: DownloadCompletion = { [weak self] image in
                    cell.image = image
                    self!.spinner.alpha = 0
                }
                
                if let download = download {
                    download(url: imageUrls[indexPath.row], completion: completion)
                } else if let download = AgrumeServiceLocator.shared.downloadHandler {
                    download(url: imageUrls[indexPath.row], completion: completion)
                } else {
                    downloadImage(imageUrls[indexPath.row], completion: completion)
                }
            } else if let dataSource = dataSource {
                spinner.alpha = 1
                let index = indexPath.row
                
                dataSource.image(forIndex: index) { [weak self] image in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if collectionView.indexPathsForVisibleItems().contains(indexPath) {
                            cell.image = image
                            self!.spinner.alpha = 0
                        }
                    })
                }
            }
            // Only allow panning if horizontal swiping fails. Horizontal swiping is only active for zoomed in images
            collectionView.panGestureRecognizer.requireGestureRecognizerToFail(cell.swipeGesture)
            cell.delegate = self
            return cell
        }
        
        private func downloadImage(url: NSURL, completion: DownloadCompletion -> Void) {
            downloadTask = ImageDownloader.downloadImage(url) { image in
                completion(image)
            }
        }
        
    }
    
    extension Agrume: UICollectionViewDelegate {
        
        public func collectionView(collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                                     forItemAt indexPath: NSIndexPath) {
            didScroll?(index: indexPath.row)
            
            if let dataSource = dataSource {
                let collectionViewCount = collectionView.numberOfItemsInSection(0)
                let dataSourceCount = dataSource.numberOfImages
                
                guard !hasDataSourceCountChanged(dataSourceCount, collectionViewCount: collectionViewCount)
                    else { return }
                
                if isIndexPathOutOfBounds(indexPath, count: dataSourceCount) {
                    showImage(atIndex: dataSourceCount - 1)
                    reload()
                } else if isLastElement(atIndexPath: indexPath, count: collectionViewCount - 1) {
                    reload()
                }
            }
        }
        
        private func hasDataSourceCountChanged(dataSourceCount: Int, collectionViewCount: Int) -> Bool {
            return collectionViewCount == dataSourceCount
        }
        
        private func isIndexPathOutOfBounds(indexPath: NSIndexPath, count: Int) -> Bool {
            return indexPath.item >= count
        }
        
        private func isLastElement(atIndexPath indexPath: NSIndexPath, count: Int) -> Bool {
            return indexPath.item == count
        }
        
    }
    
    extension Agrume: AgrumeCellDelegate {
        
        private func dismissCompletion(finished: Bool) {
            presentingViewController?.dismissViewControllerAnimated(true, completion: {  [unowned self] in
                self.cleanup()
                self.didDismiss?()
            })
        }
        
        private func cleanup() {
            _blurContainerView?.removeFromSuperview()
            _blurContainerView = nil
            _blurView = nil
            _collectionView?.removeFromSuperview()
            _collectionView = nil
            _spinner?.removeFromSuperview()
            _spinner = nil
        }
        
        func dismissAfterFlick() {
            UIView.animateWithDuration(Agrume.transitionAnimationDuration,
                           delay: 0,
                           options: [.BeginFromCurrentState],
                           animations: { [unowned self] in
                            self.collectionView.alpha = 0
                            self.blurContainerView.alpha = 0
                }, completion: dismissCompletion)
        }
        
        func dismissAfterTap() {
            view.userInteractionEnabled = false
            
            UIView.animateWithDuration(Agrume.transitionAnimationDuration,
                           delay: 0,
                           options: [.BeginFromCurrentState],
                           animations: { [unowned self] in
                            self.collectionView.alpha = 0
                            self.blurContainerView.alpha = 0
                            let scaling = Agrume.maxScalingForExpandingOffscreen
                            self.collectionView.transform = CGAffineTransform(scaleX: scaling, y: scaling)
                }, completion: dismissCompletion)
        }
    }
    
    extension Agrume {
        
        // MARK: Status Bar
        
        public override var preferredStatusBarStyle:  UIStatusBarStyle {
            return statusBarStyle ?? super.preferredStatusBarStyle()
        }
        
}

