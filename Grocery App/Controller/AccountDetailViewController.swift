//
//  AccountDetailViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 27/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class AccountDetailViewController : UIViewController,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    //Mark :- Properties

    let defaults = UserDefaults.standard
    let dataManager = DataManager()
    let db = Firestore.firestore()
    var phoneNumber : String?
    var ref: DocumentReference? = nil
    var url : String?
    var imageUrl : String?
    @IBOutlet weak var nameEditButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressEditButton: UIButton!
    @IBOutlet weak var addressFirstLineLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var addressFirstLineTextField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var addressFirstLineView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    
    //Mark :- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        addressFirstLineTextField.delegate = self
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addPhotoButton.layer.shadowOpacity = 0.5
        addPhotoButton.layer.shadowColor = UIColor.lightGray.cgColor
        addPhotoButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        profileImageView.image = UIImage(named: "profile")
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        phoneNumberLabel.text = self.defaults.string(forKey: "UserMobileNo")
    
        
        saveButton.layer.shadowColor = UIColor.darkGray.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        saveButton.layer.shadowOpacity = 0.5
        
        logOutButton.layer.shadowColor = UIColor.darkGray.cgColor
        logOutButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        logOutButton.layer.shadowOpacity = 0.5
        mainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUserDetails()
    }
    
    //Mark :- Helper function
    
    func configureUserDetails(){
        guard let user = Auth.auth().currentUser else {return}
        db.collection("users").document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data =  document.data()
                self.nameLabel.text = data?["name"] as! String ?? " "
                self.addressFirstLineLabel.text = data?["address"] as! String ?? " "
                self.imageUrl = data?["url"] as? String
                self.dataManager.getImageFrom(url: self.imageUrl, imageView: self.profileImageView)
                self.nameLabel.isHidden = false
                self.addressFirstLineLabel.isHidden = false
                self.nameTextField.isHidden = true
                self.addressFirstLineTextField.isHidden = true
                self.nameEditButton.isHidden = false
                self.addressEditButton.isHidden = false
                self.saveButton.isHidden = true
            } else {
                self.nameTextField.isHidden = false
                self.addressFirstLineTextField.isHidden = false
                self.nameLabel.isHidden = true
                self.addressFirstLineLabel.isHidden = true
                self.nameEditButton.isHidden = true
                self.addressEditButton.isHidden = true
                self.nameTextField.becomeFirstResponder()
                print("Document does not exist")
                
            }
    
}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profileImageView.contentMode = .scaleAspectFill
        var data = NSData()
        data = profileImageView.image!.jpegData(compressionQuality: 0.4)! as NSData
            // set upload path
    
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
           let storageRef = Storage.storage().reference().child("iosImages/myimage.png")
        storageRef.putData(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                //store downloadURL
                    storageRef.downloadURL { [self] (url, error) in
                        if let pictureUrl = url?.absoluteString{
                        self.url = pictureUrl
                        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["url" : pictureUrl])
                        }
                    }
                //store downloadURL at database
                  }

                }
        self.dismiss(animated: true, completion: nil)
    }
    
    //Mark :- Action

    @objc func nameTextFieldEditingDidChange(_ textField: UITextField){
        if let text = textField.text, text.count > 0{
            nameView.backgroundColor = .systemGray5
        }else{
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Please write your name" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15) ])
            nameView.backgroundColor = .red
        }
    }
    
    @IBAction func nameEditButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: nil, preferredStyle: .alert)

        alert.addTextField {  (textField) in
            textField.text = self.defaults.string(forKey: "userName")
            textField.autocapitalizationType = .words
        }

    
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
           if let textField = alert?.textFields![0] , let text = textField.text{
            self.db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["name" : text])
            self.defaults.set(text, forKey: "userName")
            }
            alert?.dismiss(animated: true) {
                self.configureUserDetails()
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addressEditButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "New Address", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = self.defaults.string(forKey: "userAddressFirstLine")
            textField.autocapitalizationType = .words
        }
    
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField1 = alert?.textFields![0] , let text1 = textField1.text {
                self.db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["address" : text1])
                self.defaults.set(text1,forKey: "userAddressFirstLine")
            }
            alert?.dismiss(animated: true) {
                self.configureUserDetails()
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func addressTextFieldEditingDidChange(_ textField: UITextField){
        if let text = textField.text, text.count > 0{
            addressFirstLineView.backgroundColor = .systemGray5
        }else{
            addressFirstLineTextField.attributedPlaceholder = NSAttributedString(string: "Please write your address" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15) ])
            addressFirstLineView.backgroundColor = .red
        }
    }
    
    @IBAction func addProfilePicture(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imageController, animated: true,completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if let name = nameTextField.text, let addressFirstLine = addressFirstLineTextField.text, let phoneNumber = Auth.auth().currentUser?.phoneNumber {
            if (name.count > 0 && addressFirstLine.count > 0) {
                let userCollection = db.collection("users")
                let id = Auth.auth().currentUser!.uid
                let userDocument = userCollection.document(id)
                userDocument.setData([
                    "name": "\(name)",
                    "address": "\(addressFirstLine)",
                    "id" : id,
                    "phone" : phoneNumber,
                    "url" : url
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(id)")
                        self.defaults.set(name, forKey: "userName")
                        self.defaults.set(addressFirstLine,forKey: "userAddressFirstLine")
                        let alertControler = UIAlertController(title: nil, message: "Saved", preferredStyle: .alert)
                        let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                            alertControler.dismiss(animated: true, completion: nil)
                                
                        }
                        alertControler.addAction(actionOk)
                        self.present(alertControler, animated: true) {
                            self.configureUserDetails()
                        }
                        }
                    }
                }else if name.count == 0 && addressFirstLine.count > 0 {
                let alertControler = UIAlertController(title: nil, message: "Please give your name", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                    alertControler.dismiss(animated: true, completion: nil)
                    
                }
                alertControler.addAction(actionOk)
                self.present(alertControler, animated: true, completion: nil)
            }else if name.count > 0 && addressFirstLine.count == 0 {
                let alertControler = UIAlertController(title: nil, message: "Please give your address", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                    alertControler.dismiss(animated: true, completion: nil)
                    
                }
                alertControler.addAction(actionOk)
                self.present(alertControler, animated: true, completion: nil)
            }else if name.count == 0 && addressFirstLine.count == 0 {
                let alertControler = UIAlertController(title: nil, message: "Please give your name and address", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                    alertControler.dismiss(animated: true, completion: nil)
                    
                }
                alertControler.addAction(actionOk)
                self.present(alertControler, animated: true, completion: nil)
            }
    }
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
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
       
               self.present(alertControler, animated: true, completion: nil)
    }
}

extension AccountDetailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            return true
    }
    
    
}
