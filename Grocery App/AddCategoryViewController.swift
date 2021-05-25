//
//  AddCategoryViewController.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 06/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
protocol PassAction {
    func addTapped(Name: String)
}
class AddCategoryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   
    
    @IBAction func imagePickerTapped(_ sender: Any) {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate = self
        imagecontroller.sourceType = UIImagePickerController.SourceType.photoLibrary
        //imagecontroller.sourceType = UIImagePickerController.SourceType.camera

        self.present(imagecontroller, animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newCategoryTxtField {
            newCategoryTxtField.layer.borderWidth = 2
            newCategoryTxtField.layer.borderColor = UIColor.systemGreen.cgColor
            textField.keyboardType = UIKeyboardType.default
        }
        else if textField == newRankTxtField {
            newRankTxtField.layer.borderWidth = 2
            newRankTxtField.layer.borderColor = UIColor.systemGreen.cgColor
            textField.keyboardType = UIKeyboardType.numberPad
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newCategoryTxtField {
            if textField.text!.isEmpty {
            print("empty field type again")
                textField.layer.borderWidth = 2
                textField.layer.borderColor = UIColor.systemRed.cgColor
            }
            else {
            return textField.resignFirstResponder()
            }
           
        }
        else if textField == newRankTxtField {
            
            if textField.text!.isEmpty {
            print("empty field type again")
               
            }
            else {
            return textField.resignFirstResponder()
            }
        }
        return textField.resignFirstResponder()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == newCategoryTxtField {
            newCategoryTxtField.layer.borderWidth = 0
            newCategoryTxtField.layer.borderColor = UIColor.white.cgColor
        }
        else if textField == newRankTxtField {
            newRankTxtField.layer.borderWidth = 0
            newRankTxtField.layer.borderColor = UIColor.white.cgColor
        }
    }
    func imagePicker()
    {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate = self
        imagecontroller.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagecontroller, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        addCategoryImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    let dataManager = DataManager()
    var imageurl = " "
    @IBOutlet weak var addCategoryImage: UIImageView!
    @IBOutlet weak var newCategoryTxtField: UITextField!
    @IBOutlet weak var newRankTxtField: UITextField!
    var uid = "nil"
    var category = " "
    var rank = " "
    var selectionDelegate: PassAction!
   
    @IBOutlet weak var addButton: UIButton!
    
    func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    func setData() {
        let db = Firestore.firestore()
        let id = randomString(of: 20)
        db.collection("categories").document("\(id)").setData([
            "id": "\(id)",
            "name": "\(newCategoryTxtField.text ?? "nil")",
            "rank": Int("\(newRankTxtField.text ?? "nil")")!,
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
               
            }
        }
        

    }
    func updateData()
    {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
 
        addButton.layer.cornerRadius = 5
        addCategoryImage.layer.cornerRadius = addCategoryImage.frame.size.height/2
        dataManager.getImageFrom(url: "\(imageurl)", imageView: addCategoryImage)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Category", style: .plain, target: nil, action: nil)
        newCategoryTxtField.delegate = self
        newRankTxtField.delegate = self
        print("uid is: \(uid)")
        if category != " " {
        self.newRankTxtField.text =  self.rank
        self.newCategoryTxtField.text = self.category
            category = " "
            rank = " "
        }
        else {
            
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addButtonTapped(_ sender: Any) {
         if newCategoryTxtField.text!.isEmpty {
            newCategoryTxtField.layer.borderWidth = 2
            newCategoryTxtField.layer.borderColor = UIColor.systemRed.cgColor
        }
        else if newRankTxtField.text!.isEmpty  {
            print("input field/fields missing")
            newRankTxtField.layer.borderWidth = 2
            newRankTxtField.layer.borderColor = UIColor.systemRed.cgColor
        }
        
        else {
        if uid == "nil" {
        setData()
        selectionDelegate?.addTapped(Name: "yes")
        }
        else {
            let db = Firestore.firestore()
            
            db.collection("categories").document("\(uid)").updateData([
                "name": "\(newCategoryTxtField.text ?? "nil")",
                "rank": Int("\(newRankTxtField.text ?? "nil")")!,
                
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document \(self.uid) updated successfully!")
                    self.uid = "nil"
                }
            }
            
            selectionDelegate?.addTapped(Name: "yes")
        }
    }
    }
    

}
