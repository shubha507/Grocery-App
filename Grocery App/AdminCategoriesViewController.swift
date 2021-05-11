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

class AdminCategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
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
    private var dictCat = [[String]]()
    private var sortedCategory = [Categories]()
  
 
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
             let name = data["name"] as? String ?? " "
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? " "
             let newCategory = Categories(name: name, rank: rank, url: url)
             self.category.append(newCategory)
                let newDict = Dict(stringId: document.documentID, intRankValue: rank)
                self.sortedDict.append(newDict)
                self.dictCategory.updateValue(name, forKey: document.documentID)
             self.dict.updateValue(document.documentID, forKey: rank)
                row1.append(name)
                row2.append(document.documentID)
            }
           // self.tblView.reloadData()
            self.dictCat.append(row1)
            self.dictCat.append(row2)
            self.categoriesCollectionView.reloadData()
            //sorting category cells according to rank
            self.sortedCategory = self.category.sorted(by: { $0.rank! < $1.rank! })
            self.sortedDict.sort(by: { $0.intRankValue! < $1.intRankValue! } )
            print(self.dict)
            print("hello")
            print(self.sortedDict)
        }
    }
}
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchData()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        fetchData()
        
    }
    /*override func viewWillAppear(_ animated: Bool) {
        self.categoriesCollectionView.reloadData()
    }*/
    @IBAction func plusButtonTapped(_ sender: Any) {
        let sec:AddCategoryViewController = self.storyboard?.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
        sec.selectionDelegate = self
       // sec.strname = nameTxtField.text
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Category", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(sec, animated: true)
        fetchData()
        self.categoriesCollectionView.reloadData()
        
    }
    
    @IBAction func editCategoryButtonTapped(_ sender: UIButton) {
        let indexPath1 = IndexPath(row: sender.tag, section: 0)
        let sec:AddCategoryViewController = self.storyboard?.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
        print(" hi ")
        print("\(sortedDict[indexPath1.row].stringId ?? "nil")")
        sec.selectionDelegate = self
        sec.uid = "\(sortedDict[indexPath1.row].stringId ?? "nil")"
        sec.category = "\(sortedCategory[indexPath1.row].name!)"
        sec.rank = "Rank: " + "\(sortedCategory[indexPath1.row].rank!)"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Category", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(sec, animated: true)
    }
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        let sec:AdminProductViewController = self.storyboard?.instantiateViewController(identifier: "AdminProductViewController") as! AdminProductViewController
        //sec.selectionDelegate = self
       // sec.strname = nameTxtField.text
        sec.categoryDict = self.dictCat
        sec.categoryDropDown = sortedCategory
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Product", style: .plain, target: nil, action: nil)
        
      //  navigationItem.backButtonTitle(image: Image(systemName: "person.crop.circle").imageScale(.large) , style: .plain , target:nil , action: nil)
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "dismiss", style: .plain, target: self, action: #selector(dismissSelf))
        self.navigationController?.pushViewController(sec, animated: true)
        
    }
    @objc private func dismissSelf()
    { }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AdminCategoriesCollectionViewCell
       
        cell.categoriesNameLabel.text = "\(sortedCategory[indexPath.row].name!)"
        cell.categoriesRankLabel.text = "Rank: " + " \(sortedCategory[indexPath.row].rank!)"
        dataManager.getImageFrom(url: "\(sortedCategory[indexPath.row].url!)", imageView: cell.categoriesImage)
        //cell.categoriesImage.layer.masksToBounds = true
        cell.categoriesImage.layer.cornerRadius = cell.categoriesImage.frame.size.height/2
        //cell.categoriesImage.layer.borderWidth = 1
        cell.categoriesImage.layer.masksToBounds = false
        cell.categoriesImage.clipsToBounds = true
        cell.categoriesImage.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.0
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.4
                cell.layer.masksToBounds = false
        cell.editCategoriesButton.tag = indexPath.row
        cell.editCategoriesButton.addTarget(self, action: #selector(editCategoryButtonTapped(_:)), for: .touchUpInside)
        //cell.layer.borderWidth = 1
        //cell.layer.borderColor = UIColor.black.cgColor
       // cell.layer.backgroundColor = UIColor.lightGray.cgColor
        return cell
    }
    
    

}
extension AdminCategoriesViewController: PassAction
{
    func addTapped(Name: String) {
        fetchData()
        self.categoriesCollectionView.reloadData()
    }
    
    
}
