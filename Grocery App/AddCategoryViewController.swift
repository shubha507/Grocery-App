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
    func addTapped(name: String)
}
class AddCategoryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   
    
    @IBAction func imagePickerTapped(_ sender: Any) {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate = self
        imagecontroller.sourceType = UIImagePickerController.SourceType.photoLibrary
        

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
    var imageurl = ""
    @IBOutlet weak var addCategoryImage: UIImageView!
    @IBOutlet weak var newCategoryTxtField: UITextField!
    @IBOutlet weak var newRankTxtField: UITextField!
    var uid = ""
    var category = ""
    var rank = ""
    var selectionDelegate: PassAction?
   
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
            
            "name": trimString(selectedField: newCategoryTxtField) ,
            "rank": Int(trimString(selectedField: newRankTxtField)) as Any ,
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.showCompletion(messageValue: "Document successfully written!")
               
            }
        }
        

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
    func showAlert( messageValue: String  )
    {
        let alert = UIAlertController(title: "Error!", message: messageValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (handle) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCompletion( messageValue: String  )
    {
        let alert = UIAlertController(title: nil, message: messageValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (handle) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func trimString(selectedField: UITextField) -> String
    {
        var placeHolder = selectedField.text
        placeHolder = placeHolder?.trimmingCharacters(in: .whitespacesAndNewlines)
        return placeHolder ?? " "
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        if newCategoryTxtField.text!.isEmpty {
            print("input field/fields missing")
            showAlert(messageValue: "Value of field missing")
            newCategoryTxtField.layer.borderWidth = 2
            newCategoryTxtField.layer.borderColor = UIColor.systemRed.cgColor
        }
        else if newRankTxtField.text!.isEmpty  {
            print("input field/fields missing")
            showAlert(messageValue: "Value of field missing")
            newRankTxtField.layer.borderWidth = 2
            newRankTxtField.layer.borderColor = UIColor.systemRed.cgColor
        }
        else if  newCategoryTxtField.text?.count ?? 0 >= 20 {
            print("character count exceeded")
            showAlert(messageValue: "No of characters exceeded")
            newCategoryTxtField.layer.borderWidth = 2
            newCategoryTxtField.layer.borderColor = UIColor.systemRed.cgColor
            
        }
        else if newRankTxtField.text?.count ?? 0 >= 20 {
            print("character count exceeded")
            showAlert(messageValue: "No of characters exceeded")
            newRankTxtField.layer.borderWidth = 2
            newRankTxtField.layer.borderColor = UIColor.systemRed.cgColor
        }
        
        else {
        if uid == "" {
        setData()
        selectionDelegate?.addTapped(name: "yes")
        }
        else {
            let db = Firestore.firestore()
            
            
            db.collection("categories").document("\(uid)").updateData([
              
                "name": trimString(selectedField: newCategoryTxtField) ,
                "rank": Int(trimString(selectedField: newRankTxtField)) as Any ,
               
                
            ]) { [self] err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document \(self.uid) updated successfully!")
             
                    showCompletion(messageValue: "Document successfully updated!")
                    self.uid = "nil"
                }
            }
            
            selectionDelegate?.addTapped(name: "yes")
        }
    }
    }
    

}
