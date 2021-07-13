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

class CellClassTableViewCell: UITableViewCell {
    
}

protocol PassActionProtocol {
    func addTapped(name: String)
}

class AddProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var heightTagsCollectionView: NSLayoutConstraint!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    var productImageid = ""
    @IBOutlet weak var imagePickerClicked: UIButton!
    @IBAction func imagePickerClicked(_ sender: Any) {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate = self
        imagecontroller.sourceType = UIImagePickerController.SourceType.photoLibrary
        

        self.present(imagecontroller, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        addProductImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addProductImage: UIImageView!
    var uid = ""
    var categoryIdd = ""
    var price = ""
    var active = ""
    var descript = ""
    var discount = " "
    var tags = [String]()
    var name = ""
   var category = ""
    var selectedActiveStatus = ""
    let dataManager = DataManager()
    var dataStorage = [[String]]()
    @IBOutlet weak var activeDropDownButton: UIButton!
    @IBOutlet weak var descriptionDropDownButton: UIButton!
    var productCategoryDict = [[String]]()
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDescription: UITextField!
    
    @IBOutlet weak var productPrice: UITextField!
    
    @IBOutlet weak var productDiscount: UITextField!
    @IBAction func productDiscount(_ sender: Any) {
    }
    
    @IBOutlet weak var productCategory: UITextField!
    @IBOutlet weak var productActiveStatus: UITextField!
    @IBOutlet weak var productTags: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var selectionDelegateAddProductController: PassActionProtocol?
    
    @IBOutlet weak var addButtonInAddProduct: UIButton!
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedCategory = ""
    var tag = [String]()
    var searchKey = [String]()
    var width = CGFloat()

    func width(text:String?, font: UIFont, height:CGFloat) -> CGFloat {
       var currentWidth: CGFloat!
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
       label.text = text
       label.font = font
       label.numberOfLines = 1
       label.sizeToFit()
       
       currentWidth = label.frame.width
       label.removeFromSuperview()
       return currentWidth
   }
    
   
    
    var contentView = UIView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
      
        productDiscount.keyboardType = UIKeyboardType.decimalPad
        productPrice.keyboardType = UIKeyboardType.decimalPad
        productName.keyboardType = UIKeyboardType.default
        productDescription.keyboardType = UIKeyboardType.default
        productActiveStatus.keyboardType = UIKeyboardType.default
        productCategory.keyboardType = UIKeyboardType.default
        productTags.keyboardType = UIKeyboardType.default
      //  fetchCategory()
      //  print("category count is" , productCategoryDict[0].count)
      
        productActiveStatus.text = "true"
        productCategory.text = "\(productCategoryDict[0][0])"
        if selectedCategory == ""
        {
            selectedCategory = "\(productCategoryDict[0][0])"
        }
        addButtonInAddProduct.layer.cornerRadius = 5
        addProductImage.layer.cornerRadius = addProductImage.frame.size.height/2
    
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        if tag.isEmpty
        {
            heightTagsCollectionView.constant = 0
        }
       else
        {
            heightTagsCollectionView.constant = 50
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Product", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        if productImageid != ""
        {
        dataManager.getImageFrom(url: "\(productImageid)", imageView: addProductImage)
        }
       // print("category count is" , productCategoryDict[0].count)
       // print("category id is:", categoryIdd)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Product", style: .plain, target: nil, action: nil)

        
        productDiscount.delegate = self
        productTags.delegate = self
        productCategory.delegate = self
        productName.delegate = self
        productPrice.delegate = self
        productActiveStatus.delegate = self
        productDescription.delegate = self
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClassTableViewCell.self, forCellReuseIdentifier: "Productcell2")
         
        print("uid is: \(uid)")
        if name != "" {
        
            productName.text = name
            productDescription.text = descript
            productPrice.text = price
            productDiscount.text = discount
            var i = 0
           while i < productCategoryDict[0].count {
               if categoryIdd == productCategoryDict[1][i] {
                   category = productCategoryDict[0][i]
                   
               }
                
                  i = i + 1
                
            }
            selectedCategory = category
            productCategory.text = category
            print("category id:" , categoryIdd)
            print("category is:" , category)
            print("tags is" , tag)
            print("selected category is:" , selectedCategory)
            productActiveStatus.text = active
            selectedActiveStatus = active
            name = ""
            descript = ""
            price = ""
            category = ""
            active = ""
            categoryIdd = ""
            tags = [""]
            discount = " "
            
            
        }
        // Do any additional setup after loading the view.
    }
   
  
    func getSearchKeys(name: String) -> [String]
    {
        let stringName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        var i = 0
        var j = 0
        var p = 0
        while j < stringName.count
        {
            if stringName[stringName.index(stringName.startIndex, offsetBy: j)] == " "   {
                
                if j - i >= 3 {
                    for k in i+2 ... j-1 {
                        let index = stringName.index(stringName.startIndex, offsetBy: i)
                        let lastIndex = stringName.index(stringName.startIndex, offsetBy: k )
                        let range = index...lastIndex
                        let substring = String(stringName[range])
                        searchKey.append(substring)
                    }
                }
                i = j + 1
                p = j
            }
            else if j == stringName.count-1 {
                
                if j - i >= 3 {
                    for k in i+2 ... j-1 {
                        let index = stringName.index(stringName.startIndex, offsetBy: i)
                        let lastIndex = stringName.index(stringName.startIndex, offsetBy: k )
                        let range = index...lastIndex
                        let substring = String(stringName[range])
                        searchKey.append(substring)
                    }
                }
                i = j + 1
            }
            j = j + 1
        }
       // let range = ..<stringName.endIndex
        if p > 0 {
        searchKey.append((String)(stringName.suffix(stringName.count - p - 1)))
        }
        searchKey.append(name)
        print("search key is:" , searchKey)
        return searchKey
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == productName {
            productName.layer.borderWidth = 2
            productName.layer.borderColor = UIColor.systemGreen.cgColor
         //   textField.keyboardType = UIKeyboardType.default
           
           
        }
        else if textField == productDescription {
           
            productDescription.layer.borderWidth = 2
            productDescription.layer.borderColor = UIColor.systemGreen.cgColor
           // textField.keyboardType = UIKeyboardType.default
            //scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        }
         else if textField == productCategory {
            productCategory.layer.borderWidth = 2
            productCategory.layer.borderColor = UIColor.systemGreen.cgColor
           // textField.keyboardType = UIKeyboardType.default
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        }
        else if textField == productPrice {
            productPrice.layer.borderWidth = 2
            productPrice.layer.borderColor = UIColor.systemGreen.cgColor
           // textField.keyboardType = UIKeyboardType.decimalPad
            
         
        }
       else if textField == productTags {
        
        productTags.layer.borderWidth = 2
        productTags.layer.borderColor = UIColor.systemGreen.cgColor
       // textField.keyboardType = UIKeyboardType.default
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        }
        else if textField == productActiveStatus {
          
            productActiveStatus.layer.borderWidth = 2
            productActiveStatus.layer.borderColor = UIColor.systemGreen.cgColor
            //textField.keyboardType = UIKeyboardType.default
            
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
            
        }
        else if textField == productDiscount {
            productDiscount.layer.borderWidth = 2
            productDiscount.layer.borderColor = UIColor.systemGreen.cgColor
            
            
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == productTags {
            if textField.text!.isEmpty 
           {
            print("empty type again")
           }
            else  {
                
                if tag.contains(productTags.text ?? "") == true
                {
                    print("same tag")
                    productTags.text = nil
                    productTags.placeholder = "tags"
                }
               else {
                productTags.autocorrectionType = .no
            tag.append("\(productTags.text ?? "")")
                heightTagsCollectionView.constant = 50
            
            print("tags:" ,tag)
           
            productTags.resignFirstResponder()
                productTags.text = nil
                productTags.placeholder = "tags"
        
            tagsCollectionView.reloadData()
            
            }
            }
            
        }
        else {
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
        if textField == productName {
            self.getSearchKeys(name: self.productName.text ?? "")
            productName.layer.borderWidth = 0
            productName.layer.borderColor = UIColor.white.cgColor
           
        }
       else if textField == productDescription {
            productDescription.layer.borderWidth = 0
            productDescription.layer.borderColor = UIColor.white.cgColor
        }
       else if textField == productCategory {
            productCategory.layer.borderWidth = 0
            productCategory.layer.borderColor = UIColor.white.cgColor
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
        else if textField == productPrice {
            productPrice.layer.borderWidth = 0
            productPrice.layer.borderColor = UIColor.white.cgColor
            
        }
       else if textField == productTags {
            productTags.layer.borderWidth = 0
            productTags.layer.borderColor = UIColor.white.cgColor
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
       else if textField == productActiveStatus {
            productActiveStatus.layer.borderWidth = 0
            productActiveStatus.layer.borderColor = UIColor.white.cgColor
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
       else if textField == productDiscount {
            productDiscount.layer.borderWidth = 0
            productDiscount.layer.borderColor = UIColor.white.cgColor
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("no of tags:" ,  tag.count)
        return tag.count
    }
  var j = 0
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCell", for: indexPath) as! TagsCollectionViewCell
        cell.tagLabel.text = tag[indexPath.row]
        cell.layer.cornerRadius = 15
        cell.cancelButton.tag = indexPath.row
       
        cell.cancelButton.addTarget(self, action: #selector(deleteTags(_:)), for: .touchUpInside)
       
        return cell
    }
    
    
    
    
    
    
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
    width = self.width(text: tag[indexPath.row], font: UIFont.systemFont(ofSize: 17), height: 48)
        print("width" , "\(width)")
    print("width is:", width)
        return CGSize(width: width + 131, height: 48)
        
        
    }
   
    @IBAction func deleteTags(_ sender: UIButton) {
        let indexPath3 = IndexPath(row: sender.tag, section: 0)
        tag.remove(at: indexPath3.row)
        print("new tag list:" , tag)
        if tag.isEmpty
        {
            heightTagsCollectionView.constant = 0
        }
        tagsCollectionView.reloadData()
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
        if dataStorage[0].count <= 5 {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            self.tableView.frame = CGRect(x: 50, y: frames.origin.y  + frames.height , width: 300, height: CGFloat( self.dataStorage[0].count * 50))
            self.transparentView.alpha = 0.5
        }, completion: nil)
    }
        else {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                
                self.tableView.frame = CGRect(x: 50, y: frames.origin.y  + frames.height , width: 300, height: 5 * 50)
                self.transparentView.alpha = 0.5
            }, completion: nil)
        }
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
        var category = productCategory.text
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
        
       let timeStamp = NSDate().timeIntervalSince1970
       let myTimeInterval = TimeInterval(timeStamp)
       let  time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        db.collection("products").document("\(id)").setData([
            "active": boolValue!,
           "category_id": "\(categoryID ?? "")",
            "id": "\(id)",
            "description": trimString(selectedField: productDescription),
            "name": trimString(selectedField: productName),
            "price": Double(trimString(selectedField: productPrice)) as Any,
            "discount": Double(trimString(selectedField: productDiscount)) as Any,

            "search_keys": searchKey,
            "createdAt": Timestamp(date: Date()),
            "updatedAt": Timestamp(date: Date()),
            "tags": tag,
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.showCompletion(messageValue: "Document successfully written!")
                print("search key:" , self.searchKey)
            }
        }
        

    }

    
    var trueArray = [["true","false"],["0","0"]]
    var selectedTextField: UITextField!
    @IBAction func activeDropDownClicked(_ sender: Any) {
      
        selectedTextField = productPrice
        selectedTextField.resignFirstResponder()
        selectedTextField = productActiveStatus
        dataStorage = trueArray
        print(dataStorage)
        addTranparentView(frames: activeDropDownButton.frame)
        
       
            }
    
    
    @IBAction func categoryDropDownClicked(_ sender: Any) {
        selectedTextField = productPrice
        selectedTextField.resignFirstResponder()
        selectedTextField = productCategory
        dataStorage = productCategoryDict
        
        print(dataStorage)
        addTranparentView(frames: descriptionDropDownButton.frame)
       
        
    }
    var indexPathOfSelected = -1
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStorage[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellP = tableView.dequeueReusableCell(withIdentifier: "Productcell2", for: indexPath)
       
        cellP.textLabel?.text = dataStorage[0][indexPath.row]
     
        if selectedCategory == dataStorage[0][indexPath.row]
        {
            print("selected category is: " , selectedCategory)
            cellP.backgroundColor = UIColor.gray
            indexPathOfSelected = indexPath.row
            //tableView.reloadData()
            selectedCategory = ""
        }
        else if selectedActiveStatus == dataStorage[0][indexPath.row]
        {
            print("selected category is: " , selectedCategory)
            cellP.backgroundColor = UIColor.gray
            indexPathOfSelected = indexPath.row
            //tableView.reloadData()
            selectedActiveStatus = ""
        }
        
        return cellP
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTextField.text = dataStorage[0][indexPath.row]
        tableView.reloadData()
        removeTranparentView()
       
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
        return placeHolder ?? ""
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        print("add tapped")
        if productName.text!.isEmpty 
        {
            productName.layer.borderWidth = 2
            productName.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "Please input product name")
            print("input field/fields missing")
        }
        else if productDescription.text!.isEmpty {
            productDescription.layer.borderWidth = 2
            productDescription.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "Please input product description")
        }
        else if productPrice.text!.isEmpty {
            productPrice.layer.borderWidth = 2
            productPrice.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "Please input product price")
        }
        else if productCategory.text!.isEmpty {
            productCategory.layer.borderWidth = 2
            productCategory.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "Please input product category")
        }
       
        
        else if productActiveStatus.text!.isEmpty {
            productActiveStatus.layer.borderWidth = 2
            productActiveStatus.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "Please input product status")
        }
        else if productDiscount.text!.isEmpty {
            productDiscount.layer.borderWidth = 2
            productDiscount.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "Please input product discount")
        }
        else if tag.isEmpty {
            productTags.layer.borderWidth = 2
            productTags.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "Please input product tags")
        }
        else if productName.text?.count ?? 0 >= 200
        {
            productName.layer.borderWidth = 2
            productName.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "No of characters exceeded")
            
        }
        else if productDescription.text?.count ?? 0 >= 200 {
            productDescription.layer.borderWidth = 2
            productDescription.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "No of characters exceeded")
        }
        else if productPrice.text?.count ?? 0 >= 20{
            productPrice.layer.borderWidth = 2
            productPrice.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "No of characters exceeded")
        }
        else if productDiscount.text?.count ?? 0 >= 20{
            productDiscount.layer.borderWidth = 2
            productDiscount.layer.borderColor = UIColor.systemRed.cgColor
            showAlert(messageValue: "No of characters exceeded")
        }
        
        
       
        
        
        else {
        if uid == ""
        {
        setData2()
        selectionDelegateAddProductController?.addTapped(name: "yes")
        }
        else
        {
            
            print("selected uid is:" , uid)
            let db = Firestore.firestore()
           // var array: Array<String> = tag
           // let id = randomString(of: 20)
            var category = productCategory.text
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
            
           // let timeStamp = NSDate().timeIntervalSince1970
            //let myTimeInterval = TimeInterval(timeStamp)
           // let  time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
            
            db.collection("products").document("\(uid)").updateData([
                "active": boolValue!,
                "category_id": "\(categoryID ?? " ")",
               
               
                "description": trimString(selectedField: productDescription),
                "name": trimString(selectedField: productName),
                "price": Double(trimString(selectedField: productPrice)) as Any,
                "discount": Double(trimString(selectedField: productDiscount)) as Any,

                "updatedAt": Timestamp(date: Date()),
                "tags": tag,
                
            ]) { [self] err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("tag:" , self.tag)
                    print("uid edited is:" ,  self.uid)
                    print("Document successfully updated!")
                    showCompletion(messageValue: "Document successfully updated!")
                    self.uid = "nil"
                }
            }
            selectionDelegateAddProductController?.addTapped(name: "yes")
        }
    
        }
    }
    
}

