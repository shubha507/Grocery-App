//
//  CustomTextField.swift
//  Grocery App
//
//  Created by Shubha Sachan on 27/04/21.
//

import UIKit

//Otp text field 
class CustomTextField : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 10
        keyboardAppearance = .light
        keyboardType = .numberPad
        backgroundColor = UIColor(named: "buttoncolor")
        textAlignment = .center
        setDimensions(height: 50, width: 50)
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.blue.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
