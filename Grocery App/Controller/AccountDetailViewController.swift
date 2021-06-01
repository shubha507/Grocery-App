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
    
    let dataManager = DataManager()
    let db = Firestore.firestore()
    var phoneNumber : String?
    var alertControler : UIAlertController?
    var ref: DocumentReference? = nil
    var url : String?
    var imageUrl : String?
    @IBOutlet weak var nameEditButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressEditButton: UIButton!
    @IBOutlet weak var addressFirstLineLabel: UILabel!
    @IBOutlet weak var addressSecondLineLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var addressSecondLineTextField: UITextField!
    @IBOutlet weak var addressFirstLineTextField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var addressFirstLineView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        addressSecondLineTextField.delegate = self
        addressFirstLineTextField.delegate = self
        scrollVw.layer.cornerRadius = 30
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addPhotoButton.layer.shadowOpacity = 0.5
        addPhotoButton.layer.shadowColor = UIColor.lightGray.cgColor
        addPhotoButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if let phoneNumber = Auth.auth().currentUser?.phoneNumber {
            phoneNumberLabel.text = phoneNumber
        }
        
        nameTextField.addTarget(self, action: #selector(nameTextFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        
        addressFirstLineTextField.addTarget(self, action: #selector(addressTextFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        
          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUserDetails()
    }
    
    
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

        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
        }

    
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
           if let textField = alert?.textFields![0] , let text = textField.text{
            self.db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["name" : text])
            }
            alert!.dismiss(animated: true) {
                self.configureUserDetails()
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addressEditButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "New Address", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Address Line 1"
            textField.autocapitalizationType = .words
        }
       
        alert.addTextField { (textField) in
            textField.placeholder = "Address Line 2"
            textField.autocapitalizationType = .words
        }
    
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField1 = alert?.textFields![0] , let text1 = textField1.text , let textField2 = alert?.textFields![1] , let text2 = textField2.text   {
                self.db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["address_first_line" : text1 , "address_second_line" : text2])
            }
            alert!.dismiss(animated: true) {
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
    
    func configureUserDetails(){
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data =  document.data()
                self.nameLabel.text = data?["name"] as! String ?? " "
                self.addressFirstLineLabel.text = data?["address_first_line"] as! String ?? " "
                self.addressSecondLineLabel.text = data?["address_second_line"] as! String ?? " "
                self.imageUrl = data?["url"] as? String
                self.dataManager.getImageFrom(url: self.imageUrl, imageView: self.profileImageView)
                self.nameLabel.isHidden = false
                self.addressSecondLineLabel.isHidden = false
                self.addressFirstLineLabel.isHidden = false
                self.nameTextField.isHidden = true
                self.addressFirstLineTextField.isHidden = true
                self.addressSecondLineTextField.isHidden = true
                self.nameEditButton.isHidden = false
                self.addressEditButton.isHidden = false
                self.saveButton.isHidden = true
            } else {
                self.nameTextField.isHidden = false
                self.addressFirstLineTextField.isHidden = false
                self.addressSecondLineTextField.isHidden = false
                self.nameLabel.isHidden = true
                self.addressSecondLineLabel.isHidden = true
                self.addressFirstLineLabel.isHidden = true
                self.nameEditButton.isHidden = true
                self.addressEditButton.isHidden = true
                print("Document does not exist")
                
            }
    
}
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
          // if keyboard size is not available for some reason, dont do anything
          return
        }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height+20, right: 0.0)
        scrollVw.contentInset = contentInsets
        scrollVw.scrollIndicatorInsets = contentInsets
      }

      @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
        
        // reset back the content inset to zero after keyboard is gone
        scrollVw.contentInset = contentInsets
        scrollVw.scrollIndicatorInsets = contentInsets
      }
    
    @IBAction func addProfilePicture(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imageController, animated: true,completion: nil)
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if let name = nameTextField.text, let addressFirstLine = addressFirstLineTextField.text, let addressSecondLine = addressSecondLineTextField.text, let phoneNumber = Auth.auth().currentUser?.phoneNumber {
            if (name.count > 0 && addressFirstLine.count > 0) {
                let userCollection = db.collection("users")
                let id = Auth.auth().currentUser!.uid
                let userDocument = userCollection.document(id)
                userDocument.setData([
                    "name": "\(name)",
                    "address_first_line": "\(addressFirstLine)",
                    "address_second_line":" \(addressSecondLine)",
                    "id" : id,
                    "phone" : phoneNumber,
                    "url" : url
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(id)")
                        let alertControler = UIAlertController(title: nil, message: "Saved", preferredStyle: .alert)
                        let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                            self.alertControler?.dismiss(animated: true) {
                                }
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
                    self.alertControler?.dismiss(animated: true, completion: nil)
                    
                }
                alertControler.addAction(actionOk)
                self.present(alertControler, animated: true, completion: nil)
            }else if name.count > 0 && addressFirstLine.count == 0 {
                let alertControler = UIAlertController(title: nil, message: "Please give your address", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.alertControler?.dismiss(animated: true, completion: nil)
                    
                }
                alertControler.addAction(actionOk)
                self.present(alertControler, animated: true, completion: nil)
            }else if name.count == 0 && addressFirstLine.count == 0 {
                let alertControler = UIAlertController(title: nil, message: "Please give your name and address", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.alertControler?.dismiss(animated: true, completion: nil)
                    
                }
                alertControler.addAction(actionOk)
                self.present(alertControler, animated: true, completion: nil)
            }
    }
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        alertControler = UIAlertController(title: nil, message: "Do you want to logout?", preferredStyle: .alert)
               let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
                   let firebaseAuth = Auth.auth()
                  do {
                    try firebaseAuth.signOut()
                  } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                  }
               }
       
               let actionNo = UIAlertAction(title: "No", style: .default) { (action) in
                   self.alertControler?.dismiss(animated: true, completion: nil)
               }
       
               alertControler?.addAction(actionYes)
               alertControler?.addAction(actionNo)
        alertControler?.setBackgroundColor(color:.white)
       
               self.present(alertControler!, animated: true, completion: nil)
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
