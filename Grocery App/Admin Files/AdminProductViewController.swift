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
import FirebaseFirestoreSwift
class CellClass: UITableViewCell {
    
}
class AdminProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate {
 private let Button = UIButton()
    let dataManager = DataManager()
    
    @IBOutlet weak var productTableView: UITableView!
    
   
    let searchController = UISearchController(searchResultsController: nil)
    private var product = [Product]()
    var categoryDropDown = [Categories]()
  //  let transparentView = UIView()
  //  let tableView = UITableView()
  //  let alertView = UIView()
   
    
  
    var categoryDict = [[String]]()
    
    
    var dictCat = [[String]]()
    
    func fetchCategory()
    {
        var row1 = [String]()
        var row2 = [String]()
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data()["rank"] as! Int)")
             let data = document.data()
             let name = data["name"] as? String ?? ""
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? ""
                let id = data["id"] as? String ?? ""
                let newCategory = Categories(data: data)
              // let newCategory = Categories1(docId: data)
                print("document is" , document)
             
                
               
                row1.append(name)
                row2.append(document.documentID)
            }
          
            //self.tableView.reloadData()
            self.dictCat.append(row1)
            self.dictCat.append(row2)
           // self.tableView.reloadData()
           
        }
    }
        //tableView.reloadData()
        
}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //productTableView.isUserInteractionEnabled = false
            
        
        
        
        productTableView.delegate = self
        productTableView.dataSource = self
      
        productTableView.allowsSelection = false
       
        //tableView.backgroundColor = UIColor.white
       let  buttonIcon = UIImage(systemName: "plus")
         let rightBarButtonItem = UIBarButtonItem(title: "add", style: UIBarButtonItem.Style.done, target: self, action: #selector(addProduct))
        rightBarButtonItem.image = buttonIcon
       
        let buttonIcon2 = UIImage(systemName: "magnifyingglass")
        let rightBarButtonItem2 = UIBarButtonItem(title: "magnifyingglass", style: UIBarButtonItem.Style.done, target: self, action: #selector(filter))
        rightBarButtonItem2.image = buttonIcon2
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem, rightBarButtonItem2]
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        searchBarSetup()
       // searchController.isActive = false
        
        self.productTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(CellClass.self, forCellReuseIdentifier: "Productcell1")
//
        fetchData()
        fetchCategory()
        
        
       
    }
    private func searchBarSetup()
    {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = nil
       // searchController.hidesNavigationBarDuringPresentation = false
        //searchController.isActive = false
    }
//    let label = UILabel()
//    let clearButton = UIButton()
//
//
//    func addalertView()
//    {
//        let window = UIApplication.shared.keyWindow
//        alertView.frame = window?.frame ??  self.view.frame
//        self.view.addSubview(alertView)
//
//        label.frame = CGRect(x: 120, y: 350 , width: 300, height: 40)
//        self.view.addSubview(label)
//        label.text = "No Products Found....."
//
//    }
//    func removeAlertView()
//    {
//
//        label.frame = CGRect(x: 0, y: 0 , width: 0, height: 0)
//
//            }
//    func addTranparentView(frames: CGRect) {
//        let window = UIApplication.shared.keyWindow
//        transparentView.frame = window?.frame ??  self.view.frame
//        self.view.addSubview(transparentView)
//        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y , width: frames.width, height: 0)
//        self.view.addSubview(tableView)
//        categoryDict = dictCat
//        clearButton.frame = CGRect(x: 270, y: CGFloat( (self.categoryDict[0].count  ) * 50) , width: 100, height: 50)
//        tableView.layer.cornerRadius = 5
//
//        clearButton.setTitle("Clear", for: .normal)
//        clearButton.tintColor = UIColor.systemGreen
//        clearButton.setTitleColor(UIColor.systemGreen, for: .normal)
//        clearButton.layer.borderColor = UIColor.black.cgColor
//        self.tableView.addSubview(clearButton)
//        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
//        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//       // let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTranparentView))
//        //transparentView.addGestureRecognizer(tapgesture)
//        transparentView.alpha = 0
//        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
//
//            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y , width: frames.width, height: CGFloat( (self.categoryDict[0].count + 3 ) * 50))
//            self.transparentView.alpha = 0.5
//        }, completion: nil)
//    }
    
//    @objc func clearButtonTapped()
//    {
//        fetchData()
//       // tableView.backgroundColor = UIColor.white
//        removeTranparentView()
//        removeAlertView()
//        tableView.layer.backgroundColor = UIColor.white.cgColor
//        tableView.reloadData()
//
//    }
    
//    @objc func removeTranparentView() {
//        let frames = view.frame
//        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
//            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y , width: frames.width, height: 0)
//            self.transparentView.alpha = 0
//
//        }, completion: nil)
//       // tableView.backgroundColor = UIColor.white
//    }
    private var sortedDict = [Dict]()
    var arrayCategories = [String]()
    struct Dict {
        var stringId: String!
        var intRankValue: Int!
        
    }
    var stringTags = [String]()
    var searchKeyValues = [String]()
      func fetchData(){
           let db = Firestore.firestore()
           db.collection("products").getDocuments() { (querySnapshot, err) in
           if let err = err {
               print("Error getting documents: \(err)")
           } else {
            
            self.stringTags = []
            self.product = []
               for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data()["price"] as! Double)")
              
                let newProduct = Product(data: document.data())
                print(" price:" , newProduct.price ?? 0 )
                self.stringTags = newProduct.tags ?? []
                
               
                self.product.append(newProduct)
                
                //let newDict = Dict(stringId: document.documentID, intRankValue: price)
                
                //self.sortedDict.append(newDict)
               }
             
              
            self.productTableView.reloadData()
              
           }
       }
   }
  
    
    
    @objc private func addProduct()
    {
        print("tapped")
        let sec:AddProductViewController = self.storyboard?.instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        sec.selectionDelegateAddProductController = self
        categoryDict = dictCat
        sec.productCategoryDict = self.categoryDict
       
       // self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Product", style: .plain, target: nil, action: nil)
        //self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        //self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.pushViewController(sec, animated: true)
        self.productTableView.reloadData()
    }
    
   
    
    @IBAction func editProductClicked(_ sender: UIButton) {
        let indexPath2 = IndexPath(row: sender.tag, section: 0)
        let sec:AddProductViewController = self.storyboard?.instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController

        print("arrayCategories", arrayCategories)
        sec.selectionDelegateAddProductController = self
        categoryDict = dictCat
        sec.productCategoryDict = self.categoryDict
        sec.productImageid = "\(product[indexPath2.row].url!)"
        sec.uid = "\(product[indexPath2.row].id ?? "")"
        sec.categoryIdd = "\(product[indexPath2.row].categoryId!)"
        sec.active = "\(product[indexPath2.row].active!)"
        sec.discount = "\(product[indexPath2.row].discount!)"
            sec.name = "\(product[indexPath2.row].name!)"
        sec.price = "\(product[indexPath2.row].price!)"
        print("string tags:" , stringTags)
        sec.tag = product[indexPath2.row].tags ?? [" "]
            sec.descript = "\(product[indexPath2.row].description!)"

       // self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Edit Product", style: .plain, target: nil, action: nil)
       // self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.pushViewController(sec, animated: true)
        self.productTableView.reloadData()
    }
    
    
    
    
    
    
    @objc private func filter()
    {
        //searchController.isActive = true
        print("tapped")
        //print(categoryDict)
        navigationItem.searchController = searchController
        searchController.isActive = true
       // fetchCategory()
        
     //   print("category count is" , categoryDict[0].count)
        
        //addTranparentView(frames: view.frame )
        
        //self.navigationItem.rightBarButtonItems = [searchController]
     
    }
    
   

    
   
        
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.productTableView
//        {
            
            return product.count
//        }
//        else if tableView == self.tableView
//        {
//
//        return dictCat[0].count + 1
//        }
//        return 2
    }
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString()
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: NSUnderlineStyle.single.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            if tableView == self.productTableView
//            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellProduct", for: indexPath) as! TableViewProductTableViewCell
               cell.tableProductName.text = "\(product[indexPath.row].name!)"
            cell.tableProductDescription.text = " \(product[indexPath.row].description!)"
                if self.product[indexPath.row].discount ?? 0 > 0
                {
                    var priceAfterDiscount = (self.product[indexPath.row].discount ?? 0) * (self.product[indexPath.row].price ?? 0) / 100
                    priceAfterDiscount = ((self.product[indexPath.row].price ?? 0) - priceAfterDiscount)
                cell.tableProductPrice.text = "Rs. " + "\(Int(priceAfterDiscount))"
                    cell.tableProductDiscountPrice.text = "Rs. " + "\(Int(self.product[indexPath.row].price ?? 0))"
                    cell.tableProductDiscountPrice.attributedText = cell.tableProductDiscountPrice.text?.strikeThrough()
                }
                else
                {
                    cell.tableProductPrice.text = "Rs. " + "\(Int(self.product[indexPath.row].price ?? 0))"
                        cell.tableProductDiscountPrice.text = ""
                    
                }
                dataManager.getImageFrom(url: "\(product[indexPath.row].url!)", imageView: cell.tableProductImage)
               // TableViewProductTableViewCell.init(style: UITableViewCell.CellStyle, reuseIdentifier: "tableViewCellProduct" )
                /*cell.tableProductImage.layer.cornerRadius = cell.tableProductImage.frame.size.height/2
                
                cell.tableProductImage.layer.masksToBounds = false
                cell.tableProductImage.clipsToBounds = true
                cell.tableProductImage.layer.backgroundColor = UIColor.white.cgColor
                cell.tableViewInnerView.layer.cornerRadius = 5
                cell.tableViewInnerView.layer.borderWidth = 0.0
                        cell.tableViewInnerView.layer.shadowColor = UIColor.black.cgColor
                        cell.tableViewInnerView.layer.shadowOffset = CGSize(width: 0, height: 0)
                        cell.tableViewInnerView.layer.shadowRadius = 5.0
                cell.tableViewInnerView.layer.shadowOpacity = 0.4
                        cell.tableViewInnerView.layer.masksToBounds = false*/

                cell.tableEditButton.tag = indexPath.row
                cell.tableEditButton.addTarget(self, action: #selector(editProductClicked(_:)), for: .touchUpInside)
                return cell
                
//            }
//            else if tableView == self.tableView
//            {
//
//                let cellP = tableView.dequeueReusableCell(withIdentifier: "Productcell1", for: indexPath)
//            if indexPath.row < categoryDict[0].count {
//            cellP.textLabel?.text = categoryDict[0][indexPath.row]
//
//            }
//            else if indexPath.row == categoryDict[0].count {
//                cellP.textLabel?.text = ""
//
//
//            }
//
//            return cellP
//            }
//            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == self.productTableView
//     {
        return 130
        
//     }
//     else if tableView == self.tableView
//     {
//        return 50
//    }
//        return 10
    }
    
    var i = 0
    var categoryUid: String = ""
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        categoryUid = categoryDict[1][indexPath.row]
//        print(categoryUid)
//        let db = Firestore.firestore()
//        db.collection("products").getDocuments() { (querySnapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//        } else {
//            self.product = []
//            self.stringTags = []
//            for document in querySnapshot!.documents {
//
//
//                var catId: String = ""
//
//                catId = document.get("category_id") as! String
//
//                print("cat id:" , document.get("category_id") ?? "")
//                if self.categoryUid == catId {
//                    self.removeAlertView()
//                    let newProduct = Product(data: document.data())
//                    print(" price:" , newProduct.price ?? 0 )
//                    self.stringTags = newProduct.tags ?? []
//             self.product.append(newProduct)
//                    self.i = self.i+1
//                }
//                else {
//                    if self.i == 0 {
//                    print("No products")
//                    self.addalertView()
//                    }
//                    else{
//
//                    }
//                                    }
//            }
//            self.productTableView.reloadData()
//            self.removeTranparentView()
//            self.i = 0
//
//        }
//    }
   
//}

    func productsMatchingWithSearch(searchedText : String?){
        
        let db = Firestore.firestore()
        db.collection("products").whereField("search_keys", arrayContains: searchedText!).getDocuments() {  (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.product = []
                for document in querySnapshot!.documents {
                    let newProduct = Product(data : document.data())
                    self.stringTags = newProduct.tags ?? []
                    print("string tag",self.stringTags)
                    self.product.append(newProduct)
                    
                }
                self.productTableView.reloadData()
                print(self.product)
            }
           

        }
    }
    
}
extension AdminProductViewController: PassActionProtocol
{
    func addTapped(name: String) {
        
        self.productTableView.reloadData()
        fetchData()
    }
    
    
}

extension AdminProductViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        if searchText == ""
        {
           fetchData()
        }
        else
        {
            print("search text is:" , searchText.lowercased())
            productsMatchingWithSearch(searchedText: searchText.lowercased())
        }
        self.productTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
    }
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
       // navigationItem.searchController = nil
        let searchText = searchController.searchBar.text
        productsMatchingWithSearch(searchedText: searchText?.lowercased())
    }
}
