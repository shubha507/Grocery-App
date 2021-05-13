//
//  CustomTabBar.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit

class CustomTabBar : UITabBar {
    
    private var shapeLayer: CALayer?
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor(named: "mygreen")?.cgColor
        shapeLayer.lineWidth = 1.0
        
//        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
//        shapeLayer.shadowRadius = 10
//        shapeLayer.shadowColor = UIColor.red.cgColor
//        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        }else{
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
       self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
        self.unselectedItemTintColor = UIColor(named: "mylightgreen")
        self.tintColor = UIColor(named: "mywhite")
    }

    func createPath() -> CGPath {
        let height: CGFloat = 30
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 15))//start pos
        path.addQuadCurve(to: CGPoint(x: 50, y: -25), controlPoint: CGPoint(x: 3 , y: -20))
        path.addLine(to: CGPoint(x: centerWidth-70, y: -32))
        path.addQuadCurve(to: CGPoint(x: centerWidth-55, y: -20), controlPoint: CGPoint(x: centerWidth-57, y: -30))
        path.addQuadCurve(to: CGPoint(x: centerWidth, y: 32), controlPoint: CGPoint(x: centerWidth-50 , y: 30))
        path.addQuadCurve(to: CGPoint(x: centerWidth+55, y: -20), controlPoint: CGPoint(x: centerWidth+50 , y: 30))
        path.addQuadCurve(to: CGPoint(x: centerWidth+70, y: -32), controlPoint: CGPoint(x:centerWidth+57, y: -30))
        path.addLine(to: CGPoint(x: self.frame.width-50, y: -25))
        path.addQuadCurve(to: CGPoint(x: self.frame.width, y: 15), controlPoint: CGPoint(x: self.frame.width-3, y: -25))
       path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
       path.addLine(to: CGPoint(x: 0, y: self.frame.height))
       path.close()
        
        return path.cgPath
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
            for member in subviews.reversed() {
                let subPoint = member.convert(point, from: self)
                guard let result = member.hitTest(subPoint, with: event) else { continue }
                return result
            }
            return nil
        }
}
