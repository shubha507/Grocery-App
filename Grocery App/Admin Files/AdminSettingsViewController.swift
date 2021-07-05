//
//  AdminSettingsViewController.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 14/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class AdminSettingsViewController: UIViewController, UITextFieldDelegate {

    let dataManager = DataManager()
    @IBOutlet weak var logoutButtonAdminSettingsController: UIButton!
    @IBOutlet weak var saveButtonAdminSettingsController: UIButton!
    @IBOutlet weak var profileAddressTextField: UITextField!
    @IBOutlet weak var profileNumberTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        profileAddressTextField.delegate = self
        profileNameTextField.delegate = self
        logoutButtonAdminSettingsController.layer.cornerRadius = 10
        saveButtonAdminSettingsController.layer.cornerRadius = 10
        profileNumberTextField.isEnabled = false
        profileNumberTextField.textColor = UIColor.darkGray
        profileImage.layer.cornerRadius = 5
        checkUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkUser()
    }
    func checkUser()
    {
     var role = String()
     let db = Firestore.firestore()
     guard let user = Auth.auth().currentUser else {return }
     db.collection("users").document(user.uid).getDocument { (document, error) in
         if let document = document, document.exists {
             let data =  document.data()
           print("user data is:" , data)
            self.dataManager.getImageFrom(url: "\(data?["url"] ?? "")", imageView: self.profileImage )
            self.profileNumberTextField.text = data?["phone"] as? String ?? ""
            self.profileNameTextField.text = data?["name"] as? String ?? ""
            self.profileAddressTextField.text = data?["address"] as? String ?? ""
         }
         else {
         }
         
         }

     
    }
    func showAlert( messageValue: String  )
    {
        let alert = UIAlertController(title: "Error!", message: messageValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (handle) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        if profileAddressTextField.text!.isEmpty {
            print("input field/fields missing")
            showAlert(messageValue: "Value of field missing")
            profileAddressTextField.layer.borderWidth = 2
            profileAddressTextField.layer.borderColor = UIColor.systemRed.cgColor
        }
        else if profileNameTextField.text!.isEmpty  {
            print("input field/fields missing")
            showAlert(messageValue: "Value of field missing")
            profileNameTextField.layer.borderWidth = 2
            profileNameTextField.layer.borderColor = UIColor.systemRed.cgColor
        }
        else
        {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection("users").document(user?.uid ?? "").updateData([
            
           "address": "\(profileAddressTextField.text ?? "")",
            "name": "\(profileNameTextField.text ?? "")"
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
            }
        }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == profileAddressTextField {
            if textField.text!.isEmpty {
            print("empty field type again")
                profileAddressTextField.layer.borderWidth = 2
                profileAddressTextField.layer.borderColor = UIColor.systemRed.cgColor
            }
            else {
            return textField.resignFirstResponder()
            }
           
        }
        else if textField == profileNameTextField {
            
            if textField.text!.isEmpty {
            print("empty field type again")
                profileNameTextField.layer.borderWidth = 2
                profileNameTextField.layer.borderColor = UIColor.systemRed.cgColor
            }
            else {
            return textField.resignFirstResponder()
            }
        }
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == profileAddressTextField {
            profileAddressTextField.layer.borderWidth = 2
            profileAddressTextField.layer.borderColor = UIColor.systemGreen.cgColor
            textField.keyboardType = UIKeyboardType.default
        }
        else if textField == profileNameTextField {
            profileNameTextField.layer.borderWidth = 2
            profileNameTextField.layer.borderColor = UIColor.systemGreen.cgColor
            textField.keyboardType = UIKeyboardType.default
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == profileAddressTextField {
            profileAddressTextField.layer.borderWidth = 0
            profileAddressTextField.layer.borderColor = UIColor.white.cgColor
        }
        else if textField == profileNameTextField {
            profileNameTextField.layer.borderWidth = 0
            profileNameTextField.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        let alertControler = UIAlertController(title: nil, message: "Do you want to logout?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        
        let actionNo = UIAlertAction(title: "No", style: .default) { (action) in
            alertControler.dismiss(animated: true, completion: nil)
        }
        
        alertControler.addAction(actionYes)
        alertControler.addAction(actionNo)
        alertControler.setBackgroundColor(color:.white)
        
        self.present(alertControler, animated: true, completion: nil)
    }
    
    
}
