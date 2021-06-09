//
//  CustomButton.swift
//  Grocery App
//
//  Created by Shubha Sachan on 01/06/21.
//

import UIKit

class CustomButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 20
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        layer.shadowOpacity = 0.5
        backgroundColor = UIColor(named: "mygreen")
        setTitleColor(.white, for: .normal)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
