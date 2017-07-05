//
//  ExtensionUtil.swift
//
//

import UIKit

//class ExtensionUtil: NSObject {
//    
//}
//
extension String {
    
    func removeCharsFromEnd(_ count_:Int) -> String {
        let stringLength = self.characters.count
        
        let substringIndex = (stringLength < count_) ? 0 : stringLength - count_
        
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: substringIndex))
    }
    
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
}


extension UIView {
    func triggerShakeAnimation() {
        let MAX_SHAKES = 6
        let SHAKE_DURATION: TimeInterval = 0.05
        let SHAKE_TRANSFORM: CGFloat = 4
        
        var direction: CGFloat = 1
        
        for i in 0..<MAX_SHAKES {
            UIView.animate(withDuration: SHAKE_DURATION,
                                       delay: SHAKE_DURATION * TimeInterval(i),
                                       options: .curveEaseIn,
                                       animations: {
                                        if i >= MAX_SHAKES {
                                            self.transform = CGAffineTransform.identity
                                        } else {
                                            self.transform = CGAffineTransform(translationX: SHAKE_TRANSFORM * direction, y: 0)
                                        }
                }, completion: nil)
            direction *= -1
        }
    }
    
    func rotate360Degrees(_ image :UIImageView) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func removeAllSubviews() {
        let subViews = self.subviews
        for subview in subViews{
                subview.removeFromSuperview()
        }
    }
}

