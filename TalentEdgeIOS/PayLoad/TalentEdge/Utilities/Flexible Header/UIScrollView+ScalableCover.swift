//
//  UIScrollView+ScalableCover.swift
//  StretchyHeaderView


import Foundation
import UIKit
import ObjectiveC

let kContentOffset = "contentOffset"

// MARK: - Scalable Cover
class ScalableCover: UIImageView {
    var maxHeight: CGFloat!
    var scrollView: UIScrollView! {
        didSet {
            scrollView.addObserver(self, forKeyPath: kContentOffset, options: .new, context: nil)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func removeFromSuperview() {
        scrollView.removeObserver(self, forKeyPath: kContentOffset)
        super.removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if scrollView.contentOffset.y < 0 {
            let offset = -scrollView.contentOffset.y
            self.frame = CGRect(x: -offset, y: -offset, width: scrollView.bounds.size.width + offset * 2, height: maxHeight + offset)

        } else {
            self.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.size.width, height: maxHeight)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setNeedsLayout()
    }

}

class ScalableLabel: UILabel {
    var maxHeight: CGFloat!
    var scrollView: UIScrollView! {
        didSet {
            scrollView.addObserver(self, forKeyPath: kContentOffset, options: .new, context: nil)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentMode = .ScaleAspectFill
        self.clipsToBounds = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        scrollView.removeObserver(self, forKeyPath: kContentOffset)
        super.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if scrollView.contentOffset.y < 0 {
            let offset = -scrollView.contentOffset.y
            self.frame = CGRect(x: -offset, y: -offset, width: scrollView.bounds.size.width + offset * 2, height: maxHeight + offset)
            
        } else {
            self.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.size.width, height: maxHeight)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setNeedsLayout()
    }
    
}


// MARK: - UIScrollView Extension
extension UIScrollView {

    fileprivate struct AssociatedKeys {
        static var kScalableCover = "scalableCover"
        static var kScalableLabel = "scalableLabel"
    }

    fileprivate var scalableCover: ScalableCover? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kScalableCover, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kScalableCover) as? ScalableCover
        }
    }
    
    fileprivate var scalableLabel: ScalableLabel? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kScalableLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kScalableLabel) as? ScalableLabel
        }
    }
    
    

    public func addScalableCover(with image: UIImage, maxHeight: CGFloat = 200) {
        let cover = ScalableCover(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 0))
        
        cover.backgroundColor = UIColor.clear
        cover.image = image
        cover.maxHeight = 0
        cover.scrollView = self
        addSubview(cover)
        sendSubview(toBack: cover)
        self.scalableCover = cover
//        self.scalableCover!.addTitleLabel()

        self.contentInset = UIEdgeInsetsMake(maxHeight, 0, 0, 0)
    }
    
//    public func addScalableLabel(with title: String, maxHeight: CGFloat = 200) {
//        let cover = ScalableLabel(frame: CGRect(x: 20, y: 150, width: self.bounds.size.width, height: 0))
//        cover.backgroundColor = UIColor.clearColor()
//        cover.text = title
//        cover.maxHeight = 0
//        cover.scrollView = self
//        
//        addSubview(cover)
//        sendSubviewToFront(cover)
////                sendSubview(toBack: cover)
//        
//        self.scalableLabel = cover
//        self.contentInset = UIEdgeInsetsMake(maxHeight, 0, 0, 0)
//    }

    public func removeScalableCover() {
        scalableCover?.removeFromSuperview()
        scalableCover = nil
    }
}

extension ScalableCover {
    
    internal var titleLabel:UILabel{
//        var frame = CGRectMake(0, 0, 200, 200);
        let titleLabel = UILabel(frame: self.bounds)
        return titleLabel
    }
    
    
    public func addTitleLabel(){
        self.addSubview(titleLabel)
    }
    
}
