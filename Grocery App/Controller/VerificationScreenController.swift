//
//  VerificationScreenController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 26/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class VerificationScreenController : UIViewController {
    
    var mobNo : String?
    
    private let arrowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(showLoginScreen), for: .touchUpInside)
        return button
    }()
    
    @objc func showLoginScreen(){
        let controller = LoginScreenController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    
    private let verifyPhoneLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "Verify Phone"
        lbl.font = UIFont.boldSystemFont(ofSize: 25)
        return lbl
    }()
    
    private let codeSentLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.textColor = .darkGray
        
        return lbl
    }()
    
    private let firstNumberTxtField = CustomTextField()
    private let secondNumberTxtField = CustomTextField()
    private let thirdNumberTxtField = CustomTextField()
    private let fourthNumberTxtField = CustomTextField()
    private let fifthNumberTxtField = CustomTextField()
    private let sixthNumberTxtField = CustomTextField()

    
    private let dontRecieveCodeButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "Didn't recieve code?", attributes: atts)

        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 16)]
        attributedTitle.append(NSAttributedString(string: " Request again", attributes: boldAtts))

        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    private let getCallButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "Get via Call", attributes: atts)

        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    private let verifyButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify and Create Account" , for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "myyellow")
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(verifyOTPAndCreateAccount), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNumberTxtField.delegate = self
        secondNumberTxtField.delegate = self
        thirdNumberTxtField.delegate = self
        fourthNumberTxtField.delegate = self
        
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNumberTxtField.becomeFirstResponder()
    }
    
    func configureUI(){

        
        view.addSubview(arrowButton)
        arrowButton.setDimensions(height: 45, width: 45)
        arrowButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        
        view.addSubview(verifyPhoneLbl)
        verifyPhoneLbl.centerX(inView: view)
        verifyPhoneLbl.centerY(inView: arrowButton, leftAnchor: arrowButton.rightAnchor,paddingLeft: 55)
        
        view.addSubview(codeSentLbl)
        codeSentLbl.centerX(inView: view)
        codeSentLbl.anchor(top:verifyPhoneLbl.bottomAnchor, paddingTop: 30)
        codeSentLbl.text = "Code is sent to \(self.mobNo!)"

        setupStack()
        
        view.addSubview(getCallButton)
        getCallButton.centerX(inView: view)
        getCallButton.anchor(top : dontRecieveCodeButton.bottomAnchor, paddingTop: 3)
        
        view.addSubview(verifyButton)
        verifyButton.setDimensions(height: 50, width: view.frame.width - 30)
        verifyButton.anchor(top : getCallButton.bottomAnchor, left : view.leftAnchor,right : view.rightAnchor, paddingTop: 10 , paddingLeft: 15, paddingRight: 15)

    }
    
    func setupStack(){
        
        let stack = UIStackView(arrangedSubviews: [firstNumberTxtField,secondNumberTxtField,thirdNumberTxtField,fourthNumberTxtField,fifthNumberTxtField,sixthNumberTxtField])
        stack.axis = .horizontal
        stack.spacing = 10
        
        firstNumberTxtField.addTarget(self, action: #selector(textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        
        secondNumberTxtField.addTarget(self, action: #selector(textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        
        thirdNumberTxtField.addTarget(self, action: #selector(textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        
        fourthNumberTxtField.addTarget(self, action: #selector(textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        
        fifthNumberTxtField.addTarget(self, action: #selector(textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        
        sixthNumberTxtField.addTarget(self, action: #selector(textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        
        view.addSubview(stack)
        stack.anchor(top : codeSentLbl.bottomAnchor ,  paddingTop: 80)
        stack.centerX(inView: view)
        
        view.addSubview(dontRecieveCodeButton)
        dontRecieveCodeButton.centerX(inView: view)
        dontRecieveCodeButton.anchor(top : stack.bottomAnchor, paddingTop: 20)
    }
    
    @objc func textDidChange(textfield : UITextField){
        let text = textfield.text
        
        if text?.utf16.count == 1 {
            switch textfield {
            
            case firstNumberTxtField:
                secondNumberTxtField.becomeFirstResponder()
                break
                
            case secondNumberTxtField:
                thirdNumberTxtField.becomeFirstResponder()
                break
                
            case thirdNumberTxtField:
                fourthNumberTxtField.becomeFirstResponder()
                break
                
            case fourthNumberTxtField:
                fifthNumberTxtField.becomeFirstResponder()
                break
                
            case fifthNumberTxtField:
                sixthNumberTxtField.becomeFirstResponder()
                break
                
            case sixthNumberTxtField:
                sixthNumberTxtField.endEditing(true)
                
            default:
                break
            }
        }
    }
    
    @objc func verifyOTPAndCreateAccount(){
        let otp = "\(firstNumberTxtField.text!)\(secondNumberTxtField.text!)\(thirdNumberTxtField.text!)\(fourthNumberTxtField.text!)\(fifthNumberTxtField.text!)\(sixthNumberTxtField.text!)"
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: otp)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            print(error.localizedDescription)
          }else{
            self.present(HomeViewController(), animated: true, completion: nil)
          }
    }
    }
}

extension VerificationScreenController : UITextFieldDelegate {
    
}
