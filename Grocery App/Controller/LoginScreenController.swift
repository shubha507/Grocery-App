//
//  LoginScreenController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 26/04/21.
//

import UIKit
import FirebaseAuth

class LoginScreenController: UIViewController,UITextFieldDelegate {
    //Mark :- properties
    
    let countryCode = CountryCode()
    
    private let containerView : UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        return vw
    }()
    
    private let continueWithPhoneLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "Continue With Phone"
        lbl.textColor = UIColor(named: "buttoncolor")
        lbl.font = UIFont(name: "PTSans-Bold", size: UIScreen.main.bounds.width / 414 * 29 )
        return lbl
    }()
    
    private let phoneWithHandImgVw : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "phone with hand image"))
        return iv
    }()
    
    private let recieveCodeLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "You will receive a 6 digit code to verify next"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.textColor = .darkGray
        lbl.font = UIFont(name: "PTSans-Regular", size: UIScreen.main.bounds.width / 414 * 25 )
        return lbl
    }()
    
    private let continueButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PTSans-Bold", size: UIScreen.main.bounds.width / 414 * 25 )
        button.backgroundColor = UIColor(red: 0, green: 255/255, blue: 0, alpha: 0.2)
        button.layer.cornerRadius = 20
        button.isUserInteractionEnabled = false
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor.systemGray.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        return button
    }()
        
    private let numberTextField : UITextField = {
        let numField = UITextField()
    numField.backgroundColor = UIColor(white: 1, alpha: 0.1)
    numField.borderStyle = .none
    numField.keyboardAppearance = .light
    numField.keyboardType = .phonePad
    numField.font = UIFont(name: "PTSans-Regular", size:UIScreen.main.bounds.width / 414 * 20 )
    
    return numField
    }()
    
    private let countryCodeTextField : UITextField = {
        let numField = UITextField()
        numField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        numField.borderStyle = .none
        numField.textColor = .black
        numField.font = UIFont(name: "PTSans-Bold", size:UIScreen.main.bounds.width / 414 * 20 )
        numField.isUserInteractionEnabled = false
        return numField
    }()
    
    private let enterNumberLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Enter your phone no.:"
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.font = UIFont(name: "PTSans-Regular", size:UIScreen.main.bounds.width / 414 * 20 )
        lbl.textAlignment = .left
        lbl.textColor = .gray
        return lbl
    }()
    
    private let phoneNumberView : UIView = {
       let vw = UIView()
        vw.backgroundColor = .white
        vw.layer.shadowColor = UIColor.systemGray.cgColor
        vw.layer.shadowOpacity = 0.5
        vw.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        return vw
    }()
    
    //Mark :- Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        view.backgroundColor = UIColor(named: "mygreen")
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberTextField.becomeFirstResponder()
        numberTextField.text = ""
    }

    //Mark :- Helper method

    func configureUI(){
        
        view.addSubview(continueWithPhoneLbl)
        continueWithPhoneLbl.centerX(inView: view)
        continueWithPhoneLbl.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40)
        
        
        view.addSubview(containerView)
        containerView.anchor(top: continueWithPhoneLbl.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15,paddingLeft: 0, paddingBottom: 0,paddingRight: 0)
       

        containerView.addSubview(phoneWithHandImgVw)
        phoneWithHandImgVw.centerX(inView: view)
        phoneWithHandImgVw.anchor(top : containerView.topAnchor , paddingTop: 30)
        phoneWithHandImgVw.setHeight(UIScreen.main.bounds.height / 896 * 200)
        let aspectRatioConstraint = NSLayoutConstraint(item: phoneWithHandImgVw , attribute: .height, relatedBy: .equal , toItem:phoneWithHandImgVw ,attribute: .width, multiplier: (1.0 / 1.0) ,constant: 0)
        phoneWithHandImgVw.addConstraint(aspectRatioConstraint)
        
        containerView.addSubview(recieveCodeLabel)
        recieveCodeLabel.centerX(inView: view)
        recieveCodeLabel.anchor(top : phoneWithHandImgVw.bottomAnchor ,left : view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 40, paddingRight: 40)
        
        phoneNumberView.addSubview(continueButton)
        continueButton.centerY(inView: phoneNumberView)
        continueButton.setDimensions(height: 50, width: 150)
        continueButton.anchor(right : phoneNumberView.rightAnchor , paddingRight: 15)
        continueButton.addTarget(self, action: #selector(continueButtonPushed), for: .touchUpInside)
        
        
        setupStack()
        
        view.addSubview(phoneNumberView)
        phoneNumberView.setDimensions(height: 70, width: view.frame.width)
        phoneNumberView.layer.cornerRadius = 20
        phoneNumberView.anchor(top: recieveCodeLabel.bottomAnchor, paddingTop: 20)
        }
    
    
    func setupStack(){
        let horizontalStack = UIStackView(arrangedSubviews: [countryCodeTextField, numberTextField])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 0
        countryCodeTextField.setWidth(35)
        countryCodeTextField.text = "+91"
            //  countryCodeTextField.text = "+\(countryCode.setCountryCode())"
        numberTextField.addTarget(self, action: #selector(textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        
        let stack = UIStackView(arrangedSubviews: [enterNumberLabel, horizontalStack])
        stack.axis = .vertical
        stack.spacing = 0
        
        phoneNumberView.addSubview(stack)
        stack.centerY(inView: phoneNumberView)
        stack.anchor(left : phoneNumberView.leftAnchor , paddingLeft: 15)
        stack.setDimensions(height: 50, width: 200)
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 10
    }
    
    //Mark :- Action 

    @objc func textDidChange(textfield: UITextField){
        if let text = numberTextField.text?.trimmingCharacters(in: .whitespaces), text.count == 10 {
            textfield.endEditing(true)
            continueButton.backgroundColor = UIColor(named: "mygreen")
            continueButton.isUserInteractionEnabled = true
        }else{
            continueButton.backgroundColor = UIColor(red: 0, green: 255/255, blue: 0, alpha: 0.2)
            continueButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func continueButtonPushed(){
        guard let phnNumber = numberTextField.text else { return }
        let number = "+91\(phnNumber)"
       // let number = "+\(countryCode.setCountryCode())\(phnNumber)"
       PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
          print("verifying")
          if let error = error {
            print(error.localizedDescription)
            let alertControler = UIAlertController(title: nil, message: error.localizedDescription , preferredStyle: .alert)
            let actionTry = UIAlertAction(title: "Try Again", style: .default) { (action) in
                self.continueButtonPushed()
            }
            let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                alertControler.dismiss(animated: true, completion: nil)
            }
            alertControler.addAction(actionOk)
            alertControler.addAction(actionTry)
            
            alertControler.setBackgroundColor(color:.white)
            
            self.present(alertControler, animated: true, completion: nil)
            return
          }else{
            guard let verificationID = verificationID else { return }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let controller = VerificationScreenController()
            controller.modalPresentationStyle = .fullScreen
            controller.mobNo = "+91 \(phnNumber)"
            self.present(controller, animated: false,completion: nil)
            }
       
        }
          }
      }
