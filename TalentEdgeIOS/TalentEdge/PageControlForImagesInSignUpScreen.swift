//
//  PageControlForImagesInSignUpScreen.swift
//  Oxigen
//
//  Created by Jaspreet Singh on 14/02/17.
//  Copyright © 2017 Oxigen Services. All rights reserved.
//

import UIKit

class PageControlForImagesInSignUpScreen: UIPageControl {
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateDots() {
        for i in 0..<self.subviews.count {
            let dot: UIView? = self.subviews[i]
            if i == self.currentPage {
                //dot?.backgroundColor = UIColor(hexString: "#555555")
                 dot?.backgroundColor = UIColor(hexString: "#FFFFFF")
                dot?.frame = CGRect(x: CGFloat(dot!.frame.origin.x), y: CGFloat(dot!.frame.origin.y), width: CGFloat(10), height: CGFloat(10))
                dot?.layer.cornerRadius = dot!.frame.size.height / 2
            }
            else {
                dot?.backgroundColor = UIColor(hexString: "#AAAAAA")
                 //dot?.backgroundColor = UIColor(hexString: "#000000")
                dot?.frame = CGRect(x: CGFloat(dot!.frame.origin.x), y: CGFloat(dot!.frame.origin.y), width: CGFloat(10), height: CGFloat(10))
                dot?.layer.cornerRadius = dot!.frame.size.height / 2
                //                dot?.layer.borderColor = UIColor.lightGray.cgColor
                //                dot?.layer.borderWidth = 1
            }
        }
    }
    
    
    func setCurrentPageLocal(_ page: Int) {
        super.currentPage = page
        self.updateDots()
    }
    
}
