//
//  DetailDashBoardFirstView.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 04/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class DetailDashBoardFirstView: UIView {

    @IBOutlet weak var LiveClassesLabel: UILabel!
    
    @IBOutlet weak var titileLabel: UILabel!
    
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var studentLabel: UILabel!
    
    
    func setUpTheLabels(_ model:Live_Classes)
    {
        self.LiveClassesLabel.text = ""
        self.titileLabel.text = "Title :" + model.title
        self.percentageLabel.text
            = String(describing: model.average_percentage_in_live_class) + " % Attendance"
        self.studentLabel.text = model.total_invitees_attended_in_live_class + " Students Attended"
        drawFullCircle(end: CGPoint(x: self.percentageLabel.frame.origin.x, y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: percentageLabel, completionPercentage: abs(Double(model.average_percentage_in_live_class)))
    }
    
    func drawFullCircle(end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, completionPercentage : Double)
    {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2+10), radius: CGFloat(70), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(M_PI/2 + M_PI*2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        //shapeLayer.lineDashPattern = [5 ,5]
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = circlePath.cgPath
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor
//707070
        shapeLayer1.lineWidth = 30
        //shapeLayer1.addSublayer(shapeLayer)
        
        let angle = completionPercentage * 3.6
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width/2,y: view.frame.size.height/2+10), radius: CGFloat(70), startAngle: CGFloat(M_PI/2), endAngle:CGFloat(((90 + angle)/180)*M_PI), clockwise: true)
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = circlePath1.cgPath
        // shapeLayer2.lineDashPattern = [5 ,5]
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.strokeColor = UIColor.white.cgColor
        shapeLayer2.lineWidth = 1.0
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = circlePath1.cgPath
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.strokeColor = UIColor.green.cgColor
         shapeLayer3.strokeColor = UIColor.init(hexString: "2F9DD4").cgColor
        shapeLayer3.lineWidth = 30
      //  shapeLayer3.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer3)
        
        
        
    }
    

    
}
