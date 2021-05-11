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
class AddCategoryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newCategoryTxtField: UITextField!
    @IBOutlet weak var newRankTxtField: UITextField!
    var uid = "nil"
    var category = " "
    var rank = " "
    var selectionDelegate: PassAction!
   
   
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
