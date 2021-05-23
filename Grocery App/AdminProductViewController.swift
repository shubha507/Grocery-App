//
//  AdminProductViewController.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 07/05/21.
//
import DropDown
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class CellClass: UITableViewCell {
    
}
class AdminProductViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
 private let Button = UIButton()
    let dataManager = DataManager()
    
    @IBOutlet weak var prodcutCollectionView: UICollectionView!
    private var product = [Product]()
    var categoryDropDown = [Categories]()
    let transparentView = UIView()
    let tableView = UITableView()
    let alertView = UIView()
   // private var dict = [Int : String]()
   
   // private var sortedDict = [Dict]()
    
   // private var sortedCategory = [Categories]()
    
  
    var categoryDict = [[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "dismiss", style: .plain, target: self, action: #selector(dismissSelf))
        
       let  buttonIcon = UIImage(systemName: "plus")
         let rightBarButtonItem = UIBarButtonItem(title: "add", style: UIBarButtonItem.Style.done, target: self, action: #selector(addProduct))
        rightBarButtonItem.image = buttonIcon
       // self.navigationItem.rightBarButtonItem = rightBarButtonItem
        let buttonIcon2 = UIImage(systemName: "magnifyingglass")
        let rightBarButtonItem2 = UIBarButtonItem(title: "magnifyingglass", style: UIBarButtonItem.Style.done, target: self, action: #selector(filter))
        rightBarButtonItem2.image = buttonIcon2
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem, rightBarButtonItem2]
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        prodcutCollectionView.delegate = self
        prodcutCollectionView.dataSource = self
     
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Productcell1")
        fetchData()
    }
    let label = UILabel()
    let clearButton = UIButton()
    func addalertView()
    {
        let window = UIApplication.shared.keyWindow
        alertView.frame = window?.frame ??  self.view.frame
        self.view.addSubview(alertView)
        
        label.frame = CGRect(x: 120, y: 350 , width: 300, height: 40)
        self.view.addSubview(label)
        label.text = "No Products Found....."
        
    }
    func removeAlertView()
    {
        
        label.frame = CGRect(x: 0, y: 0 , width: 0, height: 0)
      
            }
    func addTranparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ??  self.view.frame
        self.view.addSubview(transparentView)
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y , width: frames.width, height: 0)
        self.view.addSubview(tableView)
        clearButton.frame = CGRect(x: 270, y: CGFloat( (self.categoryDict[0].count  ) * 50) , width: 100, height: 50)
        tableView.layer.cornerRadius = 5
       
        clearButton.setTitle("Clear", for: .normal)
        clearButton.tintColor = UIColor.systemGreen
        clearButton.setTitleColor(UIColor.systemGreen, for: .normal)
        clearButton.layer.borderColor = UIColor.black.cgColor
        self.tableView.addSubview(clearButton)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTranparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y , width: frames.width, height: CGFloat( (self.categoryDict[0].count + 3 ) * 50))
            self.transparentView.alpha = 0.5
        }, completion: nil)
    }
    
    @objc func clearButtonTapped()
    {
        fetchData()
        removeTranparentView()
        removeAlertView()
        
    }
    
    @objc func removeTranparentView() {
        let frames = view.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y , width: frames.width, height: 0)
            self.transparentView.alpha = 0
           
        }, completion: nil)
    }
    private var sortedDict = [Dict]()
    var arrayCategories = [String]()
    struct Dict {
        var stringId: String!
        var intRankValue: Int!
        
    }
    var stringTags = [String]()
    
       func fetchData(){
           let db = Firestore.firestore()
           db.collection("products").getDocuments() { (querySnapshot, err) in
           if let err = err {
               print("Error getting documents: \(err)")
           } else {
               self.product = []
               for document in querySnapshot!.documents {
                   print("\(document.documentID) => \(document.data()["price"] as! Int)")
                
                let data = document.data()
                let active = data["active"] as? Bool ?? true
                let name = data["name"] as? String ?? " "
                let categoryId = data["category_id"] as? String ?? " "
                let tags = data["tags"] as? [String] ?? [" "]
                let description = data["description"] as? String ?? " "
                let price = data["price"] as? Int ?? 0
                let url = data["url"] as? String ?? " "
                self.stringTags = tags
                print("self.stringTags:" , tags)
                let newProduct = Product(active: active, categoryId: categoryId, description: description, price: price, name: name, tags: self.stringTags, url: url)
                self.product.append(newProduct)
                let newDict = Dict(stringId: document.documentID, intRankValue: price)
                //self.arrayCategories.append()
                self.sortedDict.append(newDict)
               }
             
               self.prodcutCollectionView.reloadData()
              
           }
       }
   }
    
    @objc private func addProduct()
    {
        print("tapped")
        let sec:AddProductViewController = self.storyboard?.instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        sec.selectionDelegate2 = self
        sec.productCategoryDict = self.categoryDict
       // sec.strname = nameTxtField.text
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Product", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.pushViewController(sec, animated: true)
    }
    
   
    
    @IBAction func editProductClicked(_ sender: UIButton) {
        let indexPath2 = IndexPath(row: sender.tag, section: 0)
        let sec:AddProductViewController = self.storyboard?.instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
       // print(" hi ")
       // print("\(sortedDict[indexPath1.row].stringId ?? "nil")")
        print("arrayCategories", arrayCategories)
        sec.selectionDelegate2 = self
        sec.productCategoryDict = self.categoryDict
        sec.productImageid = "\(product[indexPath2.row].url!)"
        sec.uid = "\(sortedDict[indexPath2.row].stringId ?? "nil")"
        sec.categoryIdd = "\(product[indexPath2.row].categoryId!)"
        sec.active = "\(product[indexPath2.row].active!)"
            sec.name = "\(product[indexPath2.row].name!)"
        sec.price = "\(product[indexPath2.row].price!)"
        print("string tags:" , stringTags)
        sec.tag = product[indexPath2.row].tags ?? [" "]
            sec.descript = "\(product[indexPath2.row].description!)"

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Edit Product", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.pushViewController(sec, animated: true)
    }
    
    
    
    
    
    @objc private func filter()
    {
        print("tapped")
        print(categoryDict)
        print("category count is" , categoryDict[0].count)
        
        addTranparentView(frames: view.frame )
     
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! AdminProductCollectionViewCell
       
       // cell.productName.numberOfLines = 0
        
       
        //cell.productName.lineBreakMode = .byWordWrapping
        //cell.productName.sizeToFit()
        cell.productName.text = "\(product[indexPath.row].name!)"
        cell.productDescription.text = " \(product[indexPath.row].description!)"
        cell.productPrice.text = "Price:  " + "\(product[indexPath.row].price ?? 0)"
        dataManager.getImageFrom(url: "\(product[indexPath.row].url!)", imageView: cell.productImage)
        //cell.categoriesImage.layer.masksToBounds = true
        cell.productImage.layer.cornerRadius = cell.productImage.frame.size.height/2
        //cell.categoriesImage.layer.borderWidth = 1
        cell.productImage.layer.masksToBounds = false
        cell.productImage.clipsToBounds = true
        cell.productImage.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.0
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.4
                cell.layer.masksToBounds = false

        cell.editProductButton.tag = indexPath.row
        cell.editProductButton.addTarget(self, action: #selector(editProductClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryDict[0].count + 1
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellP = tableView.dequeueReusableCell(withIdentifier: "Productcell1", for: indexPath)
            if indexPath.row < categoryDict[0].count {
            cellP.textLabel?.text = categoryDict[0][indexPath.row]
                
            }
            else if indexPath.row == categoryDict[0].count {
                cellP.textLabel?.text = ""
                //cellP.backgroundColor = UIColor.systemGreen
               
            }
            return cellP
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 50
    }
    
    var i = 0
    var categoryUid: String = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryUid = categoryDict[1][indexPath.row]
        print(categoryUid)
        let db = Firestore.firestore()
        db.collection("products").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.product = []
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data()["price"] as! Int)")
             
             let data = document.data()
             let active = data["active"] as? Bool ?? true
             let name = data["name"] as? String ?? " "
             let categoryId = data["categoryId"] as? String ?? " "
             let tags = data["tags"] as? [String] ?? [" "]
             let description = data["description"] as? String ?? " "
             let price = data["price"] as? Int ?? 0
             let url = data["url"] as? String ?? " "
                var catId: String = " "
              
                catId = document.get("category_id") as! String
                print("cat id:" , document.get("category_id") ?? "nil")
                if self.categoryUid == catId {
                    self.removeAlertView()
                    let newProduct = Product(active: active, categoryId: categoryId, description: description, price: price, name: name, tags:self.stringTags, url: url)
             self.product.append(newProduct)
                    self.i = self.i+1
                }
                else {
                    if self.i == 0 {
                    print("No products")
                    self.addalertView()
                    }
                    else{
                        
                    }
                                    }
            }
            self.prodcutCollectionView.reloadData()
            self.removeTranparentView()
            self.i = 0
            //self.categoryUid = " "
        }
    }
    }
    
}
extension AdminProductViewController: PassActionProtocol
{
    func addTapped(Name: String) {
        fetchData()
        self.prodcutCollectionView.reloadData()
    }
    
    
}
