//
//  Extension.swift
//  Grocery App
//
//  Created by Shubha Sachan on 08/05/21.
//

import UIKit



extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
}
