//
//  Extension.swift
//  Grocery App
//
//  Created by Shubha Sachan on 08/05/21.
//

import UIKit

extension UIButton{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft],
            cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

class curvedView : UIView {
    
        override func draw(_ rect: CGRect) {
            let bezierPath = UIBezierPath()
            
            bezierPath.move(to: CGPoint(x: 60, y: 66))
            bezierPath.addQuadCurve(to: CGPoint(x: 96, y: 76), controlPoint: CGPoint(x: 75, y: 73))
            
            bezierPath.close()
        }
}

protocol passQuantityChangeData {
    func quantityChanged(cellIndex:Int?, quant: Int?, isQuantViewOpen : Bool?)
}

class CartManager{
    
 static let shared = CartManager()
    
 var productAddedToCart = [Product]()
}

