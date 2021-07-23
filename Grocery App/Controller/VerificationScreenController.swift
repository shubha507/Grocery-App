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
    
    private let contentView : UIView = {
        let vw = UIView()

        vw.backgroundColor = UIColor(named: "buttoncolor")
        return vw
    }()
    
    private let textFieldArray = [CustomTextField]?.self
    
    private let textFielsIndex : [CustomTextField : Int] = [:]
    var signinAlert = UIAlertController()
    
    private let arrowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showLoginScreen), for: .touchUpInside)
        return button
    }()
    
    @objc func showLoginScreen(){
        let controller = LoginScreenController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
    
    private let verifyPhoneLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "Verify Phone"
        lbl.font = UIFont(name: "PTSans-Bold",size: UIScreen.main.bounds.width / 414 * 29)
        lbl.textColor = .white
        return lbl
    }()
    
    private let codeSentLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "PTSans-Regular", size: UIScreen.main.bounds.width / 414 * 18)
        lbl.textAlignment = .center
        lbl.textColor = .darkGray
        lbl.numberOfLines = 0
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
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray, .font: UIFont(name: "PTSans-Regular", size: 20)]
        let attributedTitle = NSMutableAttributedString(string: "Didn't recieve code? ", attributes: atts)

        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue, .font: UIFont(name: "PTSans-Regular", size: 20)]
        let attributedRequestTitle = NSMutableAttributedString(string: "Request again", attributes: boldAtts)
        attributedRequestTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributedRequestTitle.length))
        attributedTitle.append(attributedRequestTitle)
        

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
        button.setTitle("Verify and Proceed" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 255/255, blue: 0, alpha: 0.2)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "PTSans-Bold", size: 23)
        button.isUserInteractionEnabled = false
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor.systemGray.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
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
        view.backgroundColor = UIColor(named: "mygreen")
        configureUI()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tap.cancelsTouchesInView = false
           self.view.addGestureRecognizer(tap)
    
 }
    
    @objc func dismissKeyboard(){
            self.view.endEditing(true)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNumberTxtField.becomeFirstResponder()
    }
    
    //Mark :- Helper Method
   func configureUI(){
        view.addSubview(arrowButton)
        arrowButton.setDimensions(height: 45, width: 45)
    arrowButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 35, paddingLeft: 20)
        
        view.addSubview(verifyPhoneLbl)
        verifyPhoneLbl.centerX(inView: view)
        verifyPhoneLbl.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40)
    
    view.addSubview(contentView)
    contentView.anchor(top: verifyPhoneLbl.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    
    contentView.addSubview(codeSentLbl)
        codeSentLbl.centerX(inView: contentView)
    codeSentLbl.setWidth(UIScreen.main.bounds.width/414 * 400)
        codeSentLbl.anchor(top:contentView.topAnchor, paddingTop: 50)
        if let mobNo = mobNo {
            codeSentLbl.text = "Verification code is sent to \(mobNo)"
        }
    setupStack()
        
    contentView.addSubview(getCallButton)
        getCallButton.centerX(inView: view)
        getCallButton.anchor(top : dontRecieveCodeButton.bottomAnchor, paddingTop: 5)
        
    contentView.addSubview(verifyButton)
        verifyButton.setDimensions(height: 50, width: view.frame.width - 30)
        verifyButton.anchor(top : getCallButton.bottomAnchor, left : view.leftAnchor,right : view.rightAnchor, paddingTop: 2 , paddingLeft: 15, paddingRight: 15)

    }
    
    func setupStack(){
        
        let stack = UIStackView(arrangedSubviews: [firstNumberTxtField,secondNumberTxtField,thirdNumberTxtField,fourthNumberTxtField,fifthNumberTxtField,sixthNumberTxtField])
        stack.axis = .horizontal
        stack.spacing = 10
        

        contentView.addSubview(stack)
        stack.anchor(top : codeSentLbl.bottomAnchor ,  paddingTop: UIScreen.main.bounds.height/896 * 50)
        stack.centerX(inView: view)
        
        contentView.addSubview(dontRecieveCodeButton)
        dontRecieveCodeButton.centerX(inView: view)
        dontRecieveCodeButton.anchor(top : stack.bottomAnchor, paddingTop: UIScreen.main.bounds.height/896 * 45)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.length == 0{
            print(string)
                    switch textField {

                    case firstNumberTxtField:
                        firstNumberTxtField.text = "\(string)"
                        secondNumberTxtField.becomeFirstResponder()
                        break

                    case secondNumberTxtField:
                        secondNumberTxtField.text = "\(string)"
                        thirdNumberTxtField.becomeFirstResponder()
                        break

                    case thirdNumberTxtField:
                        thirdNumberTxtField.text = "\(string)"
                        fourthNumberTxtField.becomeFirstResponder()
                        break

                    case fourthNumberTxtField:
                        fourthNumberTxtField.text = "\(string)"
                        fifthNumberTxtField.becomeFirstResponder()
                        break

                    case fifthNumberTxtField:
                        fifthNumberTxtField.text = "\(string)"
                        sixthNumberTxtField.becomeFirstResponder()
                        break
 
                    case sixthNumberTxtField:
                        sixthNumberTxtField.text = "\(string)"
                        sixthNumberTxtField.resignFirstResponder()
                        sixthNumberTxtField.endEditing(true)
                        break


                    default:
                        break
                    }
            return false
        }else if (range.length == 1){
            print("range.length \(range.length)")
            textField.text = ""
            return false
        }
        return true
    }
    
   func didPressBackspace(textField: CustomTextField) {
    print("back \(textField.text?.count)")
    if textField.text?.utf8.count == 0 {
        switch textField {
        case sixthNumberTxtField:
         fifthNumberTxtField.becomeFirstResponder()
            fifthNumberTxtField.text = ""
            break



        case fifthNumberTxtField:
            fourthNumberTxtField.becomeFirstResponder()
            fourthNumberTxtField.text = ""
            break


        case fourthNumberTxtField:
            thirdNumberTxtField.becomeFirstResponder()
            thirdNumberTxtField.text = ""
            break


        case thirdNumberTxtField:
           secondNumberTxtField.becomeFirstResponder()
            secondNumberTxtField.text = ""
            break


        case secondNumberTxtField:
            firstNumberTxtField.becomeFirstResponder()
            firstNumberTxtField.text = ""
            break

        default:
            break
 }
    }
}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(firstNumberTxtField.text!)\(secondNumberTxtField.text!)\(thirdNumberTxtField.text!)\(fourthNumberTxtField.text!)\(fifthNumberTxtField.text!)\(sixthNumberTxtField.text!)")
        if let text1 = firstNumberTxtField.text, let text2 = secondNumberTxtField.text, let text3 = thirdNumberTxtField.text, let  text4 = fourthNumberTxtField.text, let text5 = fifthNumberTxtField.text ,let text6 = sixthNumberTxtField.text, !text1.trimmingCharacters(in: .whitespaces).isEmpty && !text2.trimmingCharacters(in: .whitespaces).isEmpty && !text3.trimmingCharacters(in: .whitespaces).isEmpty && !text4.trimmingCharacters(in: .whitespaces).isEmpty && !text5.trimmingCharacters(in: .whitespaces).isEmpty && !text6.trimmingCharacters(in: .whitespaces).isEmpty {
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
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp)
        signinAlert = UIAlertController(title: "Signing in...", message: nil, preferredStyle: .alert)
        signinAlert.view.tintColor = UIColor.black
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating();

        signinAlert.view.addSubview(loadingIndicator)
            self.present(signinAlert, animated: false)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                if error.localizedDescription == "The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user." {
            self.signinAlert.dismiss(animated: true) {
                
                self.firstNumberTxtField.text = ""
                self.secondNumberTxtField.text = ""
                self.thirdNumberTxtField.text = ""
                self.fourthNumberTxtField.text = ""
                self.fifthNumberTxtField.text = ""
                self.sixthNumberTxtField.text = ""

                let alert  = UIAlertController(title: "Incorrect Otp Entered", message: nil, preferredStyle: .alert)
                
                let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(actionOk)
                self.present(alert, animated: true)
                
            }
                }else{
                    self.signinAlert.dismiss(animated: true){
                    let alertControler = UIAlertController(title: nil, message: error.localizedDescription , preferredStyle: .alert)
                    let actionTry = UIAlertAction(title: "Try Again", style: .default) { (action) in
                        self.verifyOTPAndCreateAccount()
                    }
                    let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                        alertControler.dismiss(animated: true, completion: nil)
                    }
                    alertControler.addAction(actionOk)
                    alertControler.addAction(actionTry)
                    
                    alertControler.setBackgroundColor(color:.white)
                    
                    self.present(alertControler, animated: true, completion: nil)
                    }
                }
          }else{
            self.signinAlert.dismiss(animated: true)
            if let mobNo = self.mobNo?.trimmingCharacters(in: .whitespaces) {
            AppSharedDataManager.shared.phnNo = mobNo
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      let tabBarController = storyboard.instantiateViewController(identifier: "CustomTabBarViewController") as? CustomTabBarViewController
                tabBarController?.modalPresentationStyle = .fullScreen
                self.present(tabBarController!, animated: false, completion: nil)
            
           }
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
        dataManager.requestOTPAgain(number: mobNo?.trimmingCharacters(in: .whitespaces))
    }
}

extension VerificationScreenController : UITextFieldDelegate {
    
}
