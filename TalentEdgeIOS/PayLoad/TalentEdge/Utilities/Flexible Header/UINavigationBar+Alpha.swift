//
//  UINavigationBar+Alpha.swift
//  StretchyHeaderView


import Foundation
import UIKit
import CoreGraphics

private func image(with rect: CGRect, color: UIColor) -> UIImage {
    UIGraphicsBeginImageContext(rect.size)
    defer {
        UIGraphicsEndImageContext()
    }
    
    let context = UIGraphicsGetCurrentContext()
//    context.
//    context!.setFillColor(color.cgColor)
//    context!.fill(rect)
    
    
    return UIGraphicsGetImageFromCurrentImageContext()!
}

extension UINavigationBar {
    
    fileprivate struct AssociatedKeys {
        static var kScrollView = "scrollView"
        static var kBarColor = "barColor"
    }
    
    public var barColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kBarColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kBarColor) as? UIColor
        }
    }
    
    fileprivate var scrollView: UIScrollView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kScrollView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kScrollView) as? UIScrollView
        }
    }
    
    fileprivate var distance: CGFloat {
        return scrollView!.contentInset.top
    }
    
    fileprivate func updateAlpha(_ alpha: CGFloat = 0.0) {
        let color = (barColor ?? tintColor)?.withAlphaComponent(alpha)
//        let color = (barColor ?? tintColor).withAlphaComponent(alpha)
        setBackgroundImage(image(with: CGRect(x: 0, y: 0, width: 1, height: 1), color: (color?.withAlphaComponent(alpha))!), for: .default)
    }
    
    public func attachToScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        self.shadowImage = UIImage()
        self.tintColor = UIColor.white
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        scrollView.addObserver(self, forKeyPath: kContentOffset, options: .new, context: nil)
    }
    
    public func reset() {
        self.scrollView?.removeObserver(self, forKeyPath: kContentOffset)
        self.scrollView = nil
        self.shadowImage = nil
        self.tintColor = nil
        self.titleTextAttributes = nil
        self.setBackgroundImage(nil, for: .default)
    }
    
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView else { return }
        
        let offsetY = scrollView.contentOffset.y
        if offsetY > -distance {
            let alpha = min(1, 1 - ((-distance + 120 - offsetY) / 64))
            updateAlpha(alpha)
        } else {
            updateAlpha(0)
        }

    }

}
