//
//  AdminCategoriesViewController.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 06/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AdminCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableViewCategory: UITableView!
    struct Dict {
        var stringId: String!
        var intRankValue: Int!
        
    }
    
    let dataManager = DataManager()
    
    var array1 = [Categories]()
    private var category = [Categories]()
    
    private var dict = [Int : String]()
    private var dictCategory = [String: String]()
    private var sortedDict = [Dict]()
    //private var dictCat = [[String]]()
    private var sortedCategory = [Categories]()
  
    private var dictCat = [[String]]()
    func fetchData(){
        var row1 = [String]()
        var row2 = [String]()
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.category = []
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data()["rank"] as! Int)")
             let data = document.data()
             let name = data["name"] as? String ?? ""
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? ""
                let id = data["id"] as? String ?? ""
               let newCategory = Categories(name: name, rank: rank, url: url, id: id)
              // let newCategory = Categories1(docId: data)
                print("document is" , document)
             self.category.append(newCategory)
                let newDict = Dict(stringId: document.documentID, intRankValue: rank)
                self.sortedDict.append(newDict)
                self.dictCategory.updateValue(name, forKey: document.documentID)
             self.dict.updateValue(document.documentID, forKey: rank)
                row1.append(name)
                row2.append(document.documentID)
            }
          
            self.dictCat.append(row1)
            self.dictCat.append(row2)
           
            self.sortedCategory = self.category.sorted(by: { $0.rank! < $1.rank! })
            self.sortedDict.sort(by: { $0.intRankValue! < $1.intRankValue! } )
            self.tableViewCategory.reloadData()
            print(self.dict)
            print("hello")
            print(self.sortedDict)
        }
    }
}
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchData()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        tableViewCategory.delegate = self
        tableViewCategory.dataSource = self
        self.tableViewCategory.separatorStyle = UITableViewCell.SeparatorStyle.none
        fetchData()
        self.tableViewCategory.allowsSelection = false
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.init(white: 1, alpha: 0.5)
       // self.tabBarController = [tabTwoItem]
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        let sec:AddCategoryViewController = self.storyboard?.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
        sec.selectionDelegate = self
       // sec.strname = nameTxtField.text
      //  self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Category", style: .plain, target: nil, action: nil)
      //  self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.pushViewController(sec, animated: true)
        fetchData()
        self.tableViewCategory.reloadData()
        
    }
    
    
    func getUid(string channelName: String, IndexPath index: IndexPath) -> String
    {
       // let indexPath1 = IndexPath(row: sender.tag, section: 0)
        
        var currentUid = ""
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
               // print("\(document.documentID) => \(document.data()["price"] as! Int)")
             
             let data = document.data()
             let id = data["id"] as? String ?? ""
                print(" id is:" , id)
                let name = data["name"] as? String ?? ""
                print("name is:" , name)
                print("self.sortedCategory[index.row].name! is:", self.sortedCategory[index.row].name!)
                if name == self.sortedCategory[index.row].name! {
                    currentUid = id
                }
            
              }
           
           }
       }

        return currentUid
    }
    
    
    @IBAction func editCategoryButtonTapped(_ sender: UIButton) {
        let indexPath1 = IndexPath(row: sender.tag, section: 0)
        let sec:AddCategoryViewController = self.storyboard?.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
        //print(" hi ")
        //print("\(sortedDict[indexPath1.row].stringId ?? "nil")")
        sec.selectionDelegate = self
       // sec.uid = "\(sortedDict[indexPath1.row].stringId ?? " ")"
        var currentUid = "\(sortedCategory[indexPath1.row].id!)"
        sec.uid =  currentUid
        print("String id issssssss" , currentUid)
        print("category name is:",sortedCategory[indexPath1.row].name!)
        sec.category = "\(sortedCategory[indexPath1.row].name!)"
        sec.rank = "\(sortedCategory[indexPath1.row].rank!)"
        sec.imageurl = "\(sortedCategory[indexPath1.row].url!)"
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Edit Category", style: .plain, target: nil, action: nil)
       // self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.pushViewController(sec, animated: true)
        self.tableViewCategory.reloadData()
    }
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        let sec:AdminProductViewController = self.storyboard?.instantiateViewController(identifier: "AdminProductViewController") as! AdminProductViewController
       
        sec.categoryDict = self.dictCat
        sec.categoryDropDown = sortedCategory
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Product", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
     
        self.navigationController?.pushViewController(sec, animated: true)
        
    }
    
    @objc private func dismissSelf()
    { }
    
   
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedCategory.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoryNameLabel.text = "\(sortedCategory[indexPath.row].name!)"
        cell.categoryPriceLabel.text = "Rank: " + " \(sortedCategory[indexPath.row].rank!)"
        dataManager.getImageFrom(url: "\(sortedCategory[indexPath.row].url!)", imageView: cell.tableViewCategoryImage)
        
        cell.tableViewCategoryImage.layer.cornerRadius = cell.tableViewCategoryImage.frame.size.height/2

        cell.tableViewCategoryImage.layer.masksToBounds = false
        cell.tableViewCategoryImage.clipsToBounds = true
        cell.tableViewCategoryImage.layer.backgroundColor = UIColor.white.cgColor
        cell.categoryTableViewInnerView.layer.cornerRadius = 5
        cell.categoryTableViewInnerView.layer.borderWidth = 0.0
                cell.categoryTableViewInnerView.layer.shadowColor = UIColor.black.cgColor
                cell.categoryTableViewInnerView.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.categoryTableViewInnerView.layer.shadowRadius = 5.0
        cell.categoryTableViewInnerView.layer.shadowOpacity = 0.4
                cell.categoryTableViewInnerView.layer.masksToBounds = false
        cell.editCategoryTableView.tag = indexPath.row
        cell.editCategoryTableView.addTarget(self, action: #selector(editCategoryButtonTapped(_:)), for: .touchUpInside)
       
        return cell
    }
}
extension AdminCategoriesViewController: PassAction
{
    func addTapped(name: String) {
        
        fetchData()
        self.tableViewCategory.reloadData()
        
    }
    
    
}
