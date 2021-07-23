//
//  CustomTextField.swift
//  Grocery App
//
//  Created by Shubha Sachan on 27/04/21.
//

import UIKit

//Otp text field

protocol CustomTexFieldDelegate : UITextFieldDelegate {
    func didPressBackspace(textField : CustomTextField)
}

class CustomTextField : UITextField {
    
    
    var customDelegate : CustomTexFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        keyboardAppearance = .light
        keyboardType = .numberPad
        backgroundColor = UIColor(named: "buttoncolor")
        textAlignment = .center
        setDimensions(height: 50, width: 50)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        textContentType = .oneTimeCode
        tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        super.deleteBackward()
            customDelegate?.didPressBackspace(textField: self)
                
    }
}
