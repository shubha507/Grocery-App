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

class VerificationScreenController : UIViewController,CustomTexFieldDelegate {
    
    //Mark :- Properties
    var mobNo : String?
    
    var dataManager = DataManager()
    
    private let textFieldArray = [CustomTextField]?.self
    
    private let textFielsIndex : [CustomTextField : Int] = [:]
    var signinAlert = UIAlertController()
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
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
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
        button.addTarget(self, action: #selector(sendOTPAgain), for: .touchUpInside)
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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 255/255, blue: 0, alpha: 0.2)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(verifyOTPAndCreateAccount), for: .touchUpInside)
        return button
    }()
    
    //Mark :- LifeCycle method
 override func viewDidLoad() {
        super.viewDidLoad()
         
        firstNumberTxtField.delegate = self
        secondNumberTxtField.delegate = self
        thirdNumberTxtField.delegate = self
        fourthNumberTxtField.delegate = self
        fifthNumberTxtField.delegate = self
        sixthNumberTxtField.delegate = self
    
    firstNumberTxtField.customDelegate = self
    secondNumberTxtField.customDelegate = self
    thirdNumberTxtField.customDelegate = self
    fourthNumberTxtField.customDelegate = self
    fifthNumberTxtField.customDelegate = self
    sixthNumberTxtField.customDelegate = self
   
    
    getCallButton.isHidden = true
        view.backgroundColor = .white
        configureUI()
    
 }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNumberTxtField.becomeFirstResponder()
    }
    
    //Mark :- Helper Method
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
        if let mobNo = mobNo {
            codeSentLbl.text = "Code is sent to \(mobNo.suffix(10))"
        }
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
        

        view.addSubview(stack)
        stack.anchor(top : codeSentLbl.bottomAnchor ,  paddingTop: 80)
        stack.centerX(inView: view)
        
        view.addSubview(dontRecieveCodeButton)
        dontRecieveCodeButton.centerX(inView: view)
        dontRecieveCodeButton.anchor(top : stack.bottomAnchor, paddingTop: 20)
    }
    

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 1 {
            print(string)
                    switch textField {

                    case firstNumberTxtField:
                        firstNumberTxtField.text = "\(string) "
                        firstNumberTxtField.resignFirstResponder()
                        secondNumberTxtField.becomeFirstResponder()
                        break

                    case secondNumberTxtField:
                        secondNumberTxtField.text = "\(string) "
                        secondNumberTxtField.resignFirstResponder()
                        thirdNumberTxtField.becomeFirstResponder()
                        break

                    case thirdNumberTxtField:
                        thirdNumberTxtField.text = "\(string) "
                        thirdNumberTxtField.resignFirstResponder()
                        fourthNumberTxtField.becomeFirstResponder()
                        break

                    case fourthNumberTxtField:
                        fourthNumberTxtField.text = "\(string) "
                        fourthNumberTxtField.resignFirstResponder()
                        fifthNumberTxtField.becomeFirstResponder()
                        break

                    case fifthNumberTxtField:
                        fifthNumberTxtField.text = "\(string) "
                        fifthNumberTxtField.resignFirstResponder()
                        sixthNumberTxtField.becomeFirstResponder()
                        break

                    case sixthNumberTxtField:
                        sixthNumberTxtField.text = "\(string) "
                        sixthNumberTxtField.resignFirstResponder()
                        sixthNumberTxtField.endEditing(true)

                    default:
                        break
                    }
            return true
        } else {
            switch textField{
                       case sixthNumberTxtField:
                        sixthNumberTxtField.text = ""
                        sixthNumberTxtField.resignFirstResponder()
                        fifthNumberTxtField.becomeFirstResponder()
                           break



                       case fifthNumberTxtField:
                        fifthNumberTxtField.text = ""
                           fifthNumberTxtField.resignFirstResponder()
                           fourthNumberTxtField.becomeFirstResponder()
                           break


                       case fourthNumberTxtField:
                        fourthNumberTxtField.text = ""
                        fourthNumberTxtField.resignFirstResponder()
                           thirdNumberTxtField.becomeFirstResponder()
                           break


                       case thirdNumberTxtField:
                        thirdNumberTxtField.text = ""
                        thirdNumberTxtField.resignFirstResponder()
                          secondNumberTxtField.becomeFirstResponder()
                           break


                       case secondNumberTxtField:
                        secondNumberTxtField.text = ""
                        secondNumberTxtField.resignFirstResponder()
                           firstNumberTxtField.becomeFirstResponder()
                           break

                        case  firstNumberTxtField:
                            firstNumberTxtField.text = ""

                       default:
                           break
                }
            return false
            }
        
    }
    
    func didPressBackspace(textField: CustomTextField) {
        switch textField {
        case sixthNumberTxtField:
         sixthNumberTxtField.resignFirstResponder()
         fifthNumberTxtField.becomeFirstResponder()
            break



        case fifthNumberTxtField:
            fifthNumberTxtField.resignFirstResponder()
            fourthNumberTxtField.becomeFirstResponder()
            break


        case fourthNumberTxtField:
         fourthNumberTxtField.resignFirstResponder()
            thirdNumberTxtField.becomeFirstResponder()
            break


        case thirdNumberTxtField:
         thirdNumberTxtField.resignFirstResponder()
           secondNumberTxtField.becomeFirstResponder()
            break


        case secondNumberTxtField:
         secondNumberTxtField.resignFirstResponder()
            firstNumberTxtField.becomeFirstResponder()
            break

         case  firstNumberTxtField:
             break
            
        default:
            break
 }
}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text1 = firstNumberTxtField.text, let text2 = secondNumberTxtField.text, let text3 = thirdNumberTxtField.text, let  text4 = fourthNumberTxtField.text, let text5 = fifthNumberTxtField.text ,let text6 = sixthNumberTxtField.text, !text1.isEmpty && !text2.isEmpty && !text3.isEmpty && !text4.isEmpty && !text5.isEmpty && !text6.isEmpty {
            verifyButton.backgroundColor = UIColor(named: "mygreen")
            verifyButton.isUserInteractionEnabled = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        verifyButton.backgroundColor = UIColor(red: 0, green: 255/255, blue: 0, alpha: 0.2)
        verifyButton.isUserInteractionEnabled = false
    }

        
    @objc func verifyOTPAndCreateAccount(){
        let otpText = "\(firstNumberTxtField.text!)\(secondNumberTxtField.text!)\(thirdNumberTxtField.text!)\(fourthNumberTxtField.text!)\(fifthNumberTxtField.text!)\(sixthNumberTxtField.text!)"
        let otp = otpText.replacingOccurrences(of: " ", with: "")
        print(otp)
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: otp)
        signinAlert = UIAlertController(title: "Signing in...", message: nil, preferredStyle: .alert)
        signinAlert.view.tintColor = UIColor.black
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();

        signinAlert.view.addSubview(loadingIndicator)
            self.present(signinAlert, animated: true)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            self.signinAlert.dismiss(animated: true) {
                let alert  = UIAlertController(title: "Enter Correct OTP", message: nil, preferredStyle: .alert)
                
                let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(actionOk)
                self.present(alert, animated: true)
                
            }
            
          }else{
            if let mobNo = self.mobNo {
            AppSharedDataManager.shared.phnNo = mobNo
            }
            self.present(HomeViewController(), animated: true, completion: nil)
          }
    }
    }
    
    @objc func sendOTPAgain(){
        firstNumberTxtField.text = ""
        secondNumberTxtField.text = ""
        thirdNumberTxtField.text = ""
        fourthNumberTxtField.text = ""
        fifthNumberTxtField.text = ""
        sixthNumberTxtField.text = ""
        dataManager.requestOTPAgain(number: mobNo)
    }
}

extension VerificationScreenController : UITextFieldDelegate {
    
}
