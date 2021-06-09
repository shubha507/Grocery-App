//
//  LoginScreenController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 26/04/21.
//

import UIKit
import FirebaseAuth

class LoginScreenController: UIViewController {
    //Mark :- properties
    
    private let continueWithPhoneLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "Continue With Phone"
        lbl.font = UIFont.boldSystemFont(ofSize: 25)
        return lbl
    }()
    
    private let phoneWithHandImgVw : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "phone with hand image"))
        return iv
    }()
    
    private let recieveCodeLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "You'll receive a 4 digit code to verify next"
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.textColor = .darkGray
        return lbl
    }()
    
    private let continueButton = CustomButton()
        
    private let numberTextField : UITextField = {
        let numField = UITextField()
    numField.backgroundColor = UIColor(white: 1, alpha: 0.1)
    numField.borderStyle = .none
    numField.keyboardAppearance = .light
    numField.keyboardType = .phonePad
    numField.attributedText = NSAttributedString(string: "", attributes: [.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
    numField.textColor = .black
    numField.font = UIFont.boldSystemFont(ofSize: 20)
    numField.placeholder = "+912222222222"
    return numField
    }()
    
    private let enterNumberLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Enter your phone"
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .left
        lbl.textColor = .darkGray
        return lbl
    }()
    
    private let phoneNumberView : UIView = {
       let vw = UIView()
        vw.backgroundColor = .white
        return vw
    }()
    
    //Mark :- Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.delegate = self
        view.backgroundColor = UIColor(named: "mywhite")
        configureUI()
        
    }

    //Mark :- Helper method

    func configureUI(){
        
        view.addSubview(continueWithPhoneLbl)
        continueWithPhoneLbl.centerX(inView: view)
        continueWithPhoneLbl.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)

        view.addSubview(phoneWithHandImgVw)
        phoneWithHandImgVw.centerX(inView: view)
        phoneWithHandImgVw.anchor(top : continueWithPhoneLbl.bottomAnchor , paddingTop: 10)
        phoneWithHandImgVw.setDimensions(height: 200, width: 200)
        
        view.addSubview(recieveCodeLabel)
        recieveCodeLabel.centerX(inView: view)
        recieveCodeLabel.anchor(top : phoneWithHandImgVw.bottomAnchor ,left : view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 40, paddingRight: 40)
        
        phoneNumberView.addSubview(continueButton)
        continueButton.centerY(inView: phoneNumberView)
        continueButton.setDimensions(height: 50, width: 150)
        continueButton.anchor(right : phoneNumberView.rightAnchor , paddingRight: 10)
        continueButton.addTarget(self, action: #selector(continueButtonPushed), for: .touchUpInside)
        continueButton.setTitle("Continue" , for: .normal)
        
        
        setupStack()
        
        view.addSubview(phoneNumberView)
        phoneNumberView.setDimensions(height: 70, width: view.frame.width)
        phoneNumberView.layer.cornerRadius = 20
        phoneNumberView.anchor(top: recieveCodeLabel.bottomAnchor, paddingTop: 15)
        }
    
    
    func setupStack(){
        let stack = UIStackView(arrangedSubviews: [enterNumberLabel, numberTextField])
        stack.axis = .vertical
        stack.spacing = 0
        
        phoneNumberView.addSubview(stack)
        stack.centerY(inView: phoneNumberView)
        stack.anchor(left : phoneNumberView.leftAnchor , paddingLeft: 15)
        stack.setDimensions(height: 50, width: 200)
    }
    
    //Mark :- Action 

    @objc func continueButtonPushed(){
        
        guard let phoneNumber = numberTextField.text else { return }
        
        if phoneNumber.count == 13 {
        numberTextField.endEditing(true)
    
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print(error.localizedDescription)
            return
          }else{
            guard let verificationID = verificationID else { return }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let controller = VerificationScreenController()
            controller.modalPresentationStyle = .fullScreen
            if let text = self.numberTextField.text {
            controller.mobNo = text
            }
            self.present(controller, animated: true, completion: nil)
          }
        }
        }else if phoneNumber.count < 13 {
          let alertController = UIAlertController(title: nil, message: "Please add country code and 10 digit phone number", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (dismissAction: UIAlertAction!) in alertController.dismiss(animated: true, completion: nil) })
            alertController.modalPresentationStyle = .custom
            alertController.addAction(action)
            self.present(alertController,
                                           animated: true,
                                           completion: nil)
        }
        
    }
    
}

extension LoginScreenController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location <= 12
    }
}
