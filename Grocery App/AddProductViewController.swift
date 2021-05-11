//
//  AddProductViewController.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 09/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import DropDown

class CellClass1: UITableViewCell {
    
}

protocol PassActionProtocol {
    func addTapped(Name: String)
}

class AddProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var uid = "nil"
    var categoryIdd = " "
    var price = " "
    var active = " "
    var descript = " "
    var tags = " "
    var name = " "
   var category = " "
    
    var dataStorage = [[String]]()
    @IBOutlet weak var activeDropDownButton: UIButton!
    @IBOutlet weak var descriptionDropDownButton: UIButton!
    var productCategoryDict = [[String]]()
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDescription: UITextField!
    
    @IBOutlet weak var productPrice: UITextField!
    
    @IBOutlet weak var ProductCategory: UITextField!
    
    @IBOutlet weak var productActiveStatus: UITextField!
    @IBOutlet weak var productTags: UITextField!
    var selectionDelegate2: PassActionProtocol!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("category count is" , productCategoryDict[0].count)
        print("category id is:", categoryIdd)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Product", style: .plain, target: nil, action: nil)

        productTags.delegate = self
        ProductCategory.delegate = self
        productName.delegate = self
        productPrice.delegate = self
        productActiveStatus.delegate = self
        productDescription.delegate = self
        //selectedTextField.delegate = self
        
       // print("datastorage count is" , dataStorage[0].count)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass1.self, forCellReuseIdentifier: "Productcell2")
        
        print("uid is: \(uid)")
        if name != " " {
        
            productName.text = name
            productDescription.text = descript
            productPrice.text = price
            
            var i = 0
            while i < productCategoryDict[0].count {
                if categoryIdd == productCategoryDict[1][i] {
                    category = productCategoryDict[0][i]
                    i = i + 1
                }
                else{
                    i = i + 1
                }
            }
            
            ProductCategory.text = category
            print("category id:" , categoryIdd)
            print("category is:" , category)
            productActiveStatus.text = active
            
            name = " "
            descript = " "
            price = " "
            category = " "
            active = " "
            categoryIdd = " "
            tags = " "
            
            
        }
        // Do any additional setup after loading the view.
    }
   
    func addTranparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ??  self.view.frame
        self.view.addSubview(transparentView)
        tableView.frame = CGRect(x: 50, y: frames.origin.y + frames.height  , width: 300, height: 0)
        self.view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 5
       
   
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTranparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            self.tableView.frame = CGRect(x: 50, y: frames.origin.y  + frames.height , width: 300, height: CGFloat( self.dataStorage[0].count * 50))
            self.transparentView.alpha = 0.5
        }, completion: nil)
    }
    
    @objc func removeTranparentView() {
        let frames = view.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height , width: frames.width, height: 0)
            self.transparentView.alpha = 0
           
        }, completion: nil)
    }
    
    func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    func setData2() {
        let db = Firestore.firestore()
        let id = randomString(of: 20)
        var category = ProductCategory.text
        var categoryID: String!
                var boolValue: Bool!
        if productActiveStatus.text == "true"
        {
           boolValue = true
        }
        else{
          boolValue = false
        }
        var i = 0
        while i < productCategoryDict[0].count {
            if category == productCategoryDict[0][i] {
                categoryID = productCategoryDict[1][i]
                i = i + 1
            }
            else{
                i = i + 1
            }
        }
        
        db.collection("products").document("\(id)").setData([
            "active": boolValue!,
            "category_id": "\(categoryID ?? "nil")",
            "description": "\(productDescription.text ?? "nil")",
            "name": "\(productName.text ?? "nil")",
            "price": Int("\(productPrice.text ?? "nil")")!,
            "tags": "\(productTags.text ?? "nil")",
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
               
            }
        }
        

    }

    
    var trueArray = [["true","false"],["0","0"]]
    var selectedTextField: UITextField!
    @IBAction func activeDropDownClicked(_ sender: Any) {
        //self.dataStorage = self.productCategoryDict
        selectedTextField = productActiveStatus
        dataStorage = trueArray
        print(dataStorage)
        addTranparentView(frames: activeDropDownButton.frame)
        //dataSource = productCategoryDict
            }
    
    
    @IBAction func categoryDropDownClicked(_ sender: Any) {
        selectedTextField = ProductCategory
        dataStorage = productCategoryDict
        print(dataStorage)
        addTranparentView(frames: descriptionDropDownButton.frame)
        //var row1 = ["true","false"]
       // var row2 = ["0","0"]
       // self.dataStorage.append(row1)
       // self.dataStorage.append(row2)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStorage[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellP = tableView.dequeueReusableCell(withIdentifier: "Productcell2", for: indexPath)
       
        cellP.textLabel?.text = dataStorage[0][indexPath.row]
        return cellP
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTextField.text = dataStorage[0][indexPath.row]
        removeTranparentView()
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        print("add tapped")
        if uid == "nil"
        {
        setData2()
        selectionDelegate2?.addTapped(Name: "yes")
        }
        else{
            let db = Firestore.firestore()
            let id = randomString(of: 20)
            var category = ProductCategory.text
            var categoryID: String!
                    var boolValue: Bool!
            if productActiveStatus.text == "true"
            {
               boolValue = true
            }
            else{
              boolValue = false
            }
            var i = 0
            while i < productCategoryDict[0].count {
                if category == productCategoryDict[0][i] {
                    categoryID = productCategoryDict[1][i]
                    i = i + 1
                }
                else{
                    i = i + 1
                }
            }
            
            db.collection("products").document("\(id)").setData([
                "active": boolValue!,
                "category_id": "\(categoryID ?? "nil")",
                "description": "\(productDescription.text ?? "nil")",
                "name": "\(productName.text ?? "nil")",
                "price": Int("\(productPrice.text ?? "nil")")!,
                "tags": "\(productTags.text ?? "nil")",
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.uid = "nil"
                }
            }
            selectionDelegate2?.addTapped(Name: "yes")

        }
    }
    
}

