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
    
    var nameEdited : Bool?
    var addressEdited : Bool?
    var defaults = UserDefaults.standard
    var userDetail = UserDetailsModel()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        nameTextField.delegate = self
        addressFirstLineTextField.delegate = self
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addPhotoButton.layer.shadowOpacity = 0.5
        addPhotoButton.layer.shadowColor = UIColor.lightGray.cgColor
        addPhotoButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveButton.isUserInteractionEnabled = false
        saveButton.backgroundColor = UIColor(red: 0, green: 255/255, blue: 0, alpha: 0.2)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor(named: "mygreen")?.cgColor
        if let phoneNumber = Auth.auth().currentUser?.phoneNumber {
            phoneNumberLabel.text = phoneNumber
        }
        
        nameTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        
        addressFirstLineTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        
        logOutButton.layer.shadowOpacity = 1.0
        logOutButton.layer.shadowColor = UIColor.systemGray.cgColor
        logOutButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUserDetails()
    }
    
    
    @objc func textFieldEditingDidChange(_ textfield: UITextField){
        if textfield == nameTextField {
            userDetail.name = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        }else{
            userDetail.address = addressFirstLineTextField.text?.trimmingCharacters(in: .whitespaces)
        }
        
        if userDetail.canSaveData {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor(named: "mygreen")
        }else{
            saveButton.isUserInteractionEnabled = false
            saveButton.backgroundColor = UIColor(red: 0, green: 255/255, blue: 0, alpha: 0.2)
        }
    }
    
    @IBAction func nameEditButtonPressed(_ sender: Any) {
        if nameEdited == nil && addressEdited == nil{
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor(named: "mygreen")
        }
        saveButton.isHidden = false
        nameLabel.isHidden = true
        nameTextField.isHidden = false
        nameTextField.becomeFirstResponder()
        nameTextField.text = defaults.string(forKey: "name")
        nameEdited = true
        
       }
    
    @IBAction func addressEditButtonPressed(_ sender: Any) {
        if addressEdited == nil &&  nameEdited == nil {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor(named: "mygreen")
        }
        saveButton.isHidden = false
        addressFirstLineLabel.isHidden = true
        addressFirstLineTextField.isHidden = false
        addressFirstLineTextField.becomeFirstResponder()
        addressFirstLineTextField.text = defaults.string(forKey: "address")
        addressEdited = true
        
        
        
    }
    
    func configureUserDetails(){
        guard let user = Auth.auth().currentUser else {return}
        db.collection("users").document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data =  document.data()
                self.nameLabel.text = data?["name"] as! String ?? ""
                self.addressFirstLineLabel.text = data?["address"] as! String ?? ""
                self.imageUrl = data?["url"] as? String
                self.dataManager.getImageFrom(url: self.imageUrl, imageView: self.profileImageView)
                self.nameLabel.isHidden = false
                self.addressFirstLineLabel.isHidden = false
                self.nameTextField.isHidden = true
                self.addressFirstLineTextField.isHidden = true
                self.nameEditButton.isHidden = false
                self.addressEditButton.isHidden = false
                self.saveButton.isHidden = true
                self.userDetail.name = self.defaults.string(forKey: "name")
                self.userDetail.address = self.defaults.string(forKey: "address")
            } else {
                self.nameTextField.isHidden = false
                self.addressFirstLineTextField.isHidden = false
                self.nameLabel.isHidden = true
                self.addressFirstLineLabel.isHidden = true
                self.nameEditButton.isHidden = true
                self.addressEditButton.isHidden = true
                self.nameTextField.becomeFirstResponder()
            }
            
        }
    }
    
    
    @IBAction func addProfilePicture(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        let actionSheet = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)

            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in

                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imageController.sourceType = .camera
                    self.present(imageController, animated: true, completion: nil)
                }else{
                    let alertControler = UIAlertController(title: nil, message: "Camera not available", preferredStyle: .alert)
                    
                    let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
                        alertControler.dismiss(animated: true, completion: nil)
                    }
                    
                   
                    alertControler.addAction(actionOk)
                    alertControler.setBackgroundColor(color:.white)
                    
                    self.present(alertControler, animated: true, completion: nil)
                }


            }))

            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
                imageController.sourceType = .photoLibrary
                self.present(imageController, animated: true, completion: nil)
            }))


            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(actionSheet, animated: true, completion: nil)
        imageController.allowsEditing = true
        self.present(imageController, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.image = info[.editedImage] as? UIImage
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor(named: "mygreen")?.cgColor
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
        guard let user = Auth.auth().currentUser else {return}
        db.collection("users").document(user.uid).getDocument { [self] (document, error) in
            if let document = document, !document.exists {
                if let name = self.nameTextField.text, let addressFirstLine = self.addressFirstLineTextField.text, let user = Auth.auth().currentUser, let phoneNumber = user.phoneNumber {
               
                let userCollection = db.collection("users")
                let id = user.uid
                let user = users(name: name, id: id, address: addressFirstLine, phone: phoneNumber, url: url ?? nil, fcmToken: nil)
                let userDocument = userCollection.document(id)
                userDocument.setData(
                    user.getData()
                ){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(id)")
                            self.configureUserDetails()
                        self.defaults.setValue(name, forKey: "name")
                        self.defaults.setValue(addressFirstLine, forKey: "address")
                        print("userDetail \(userDetail.name)")
                        let alert = UIAlertController(title: nil, message: "Saved", preferredStyle: .actionSheet)
                        
                        self.present(alert, animated: true, completion: nil)

                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when){
                          // your code with delay
                          alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
           
        }
        }else{
                if let nameEdit = nameEdited, let addressEdit = addressEdited, (addressEdit == false  && nameEdit == true){
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["name" : nameTextField.text])
                    defaults.setValue(nameTextField.text, forKey: "name")
                    print("only name edited ")
                    configureUserDetails()
                    nameEdited = false
                    
                }else if let nameEdit = nameEdited, (addressEdited == nil && nameEdit == true){
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["name" : nameTextField.text])
                    defaults.setValue(nameTextField.text, forKey: "name")
                    print("only name edited ")
                    configureUserDetails()
                    nameEdited = false
                }else if let addressEdit = addressEdited,let nameEdit = nameEdited, (addressEdit == true && nameEdit != true) {
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["address" : addressFirstLineTextField.text])
                    defaults.setValue(addressFirstLineTextField.text, forKey: "address")
                    print("only address edited ")
                    configureUserDetails()
                    addressEdited = false
                }
                else if let addressEdit = addressEdited,(nameEdited == nil && addressEdit == true) {
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["address" : addressFirstLineTextField.text])
                    defaults.setValue(addressFirstLineTextField.text, forKey: "address")
                    print("only address edited ")
                    configureUserDetails()
                    addressEdited = false
                }else if  let nameEdit = nameEdited, let addressEdit = addressEdited, (addressEdit == true && nameEdit == true) {
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["name" : nameTextField.text])
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["address" : addressFirstLineTextField.text])
                    defaults.setValue(addressFirstLineTextField.text, forKey: "address")
                    defaults.setValue(nameTextField.text, forKey: "name")
                    print("both edited ")
                    configureUserDetails()
                    nameEdited = false
                    addressEdited = false
                }
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
        alertControler.setBackgroundColor(color:.white)
        
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
