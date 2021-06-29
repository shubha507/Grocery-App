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

class AdminSettingsViewController: UIViewController {

    let dataManager = DataManager()
    @IBOutlet weak var logoutButtonAdminSettingsController: UIButton!
    @IBOutlet weak var saveButtonAdminSettingsController: UIButton!
    @IBOutlet weak var profileAddressTextField: UITextField!
    @IBOutlet weak var profileNumberTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButtonAdminSettingsController.layer.cornerRadius = 10
        saveButtonAdminSettingsController.layer.cornerRadius = 10
        profileNumberTextField.isEnabled = false
        profileNumberTextField.textColor = UIColor.darkGray
        profileImage.layer.cornerRadius = 5
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
    @IBAction func saveButtonTapped(_ sender: Any) {
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
