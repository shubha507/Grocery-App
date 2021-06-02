//
//  HomeViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class HomeViewController : UIViewController, UITableViewDelegate, PerformAction, UITextFieldDelegate {
    
    
    //Mark :- Properties
    var searchedProduct = [Product]()
    var dataManager = DataManager()
    var productArray = [Product]()
    var category = [Categories]()
    var sortedCategory = [Categories]()
    var discount = [Discount]()
    var sortedDiscount = [Discount]()
    var deals = [Deals]()
    var sortedDeals = [Deals]()
    var imageUrl : String?
    var name : String?
    
    private let imageView : UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    private let hiLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Hey"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Shubha"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let searchFoodLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Lets search your grocery food."
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let profileButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let searchTextField : UISearchTextField = {
        let stf = UISearchTextField()
        stf.layer.cornerRadius = 20
        stf.placeholder = "Search your daily grocery food..."
        stf.backgroundColor = .white
        stf.autocapitalizationType = .none
        return stf
    }()
    
    private let tblView : UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(named: "buttoncolor")
        tv.register(CategoriesTableViewCell.self, forCellReuseIdentifier: "cell")
        tv.layer.cornerRadius = 30
        tv.register(DiscountTableViewCell.self, forCellReuseIdentifier: "cell1")
        tv.register(PopularDealsTableViewCell.self,forCellReuseIdentifier: "cell2")
        tv.showsVerticalScrollIndicator = false
        tv.bounces = false
        return tv
    }()
    
    private let searchView : UIView = {
       let vw = UIView()
        vw.backgroundColor = UIColor(named: "buttoncolor")
        vw.layer.cornerRadius = 30
        return vw
    }()
    
    let searchCellCollectionVw: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
       let fc = UICollectionView(frame: .zero, collectionViewLayout: layout)
       fc.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell1")
       fc.backgroundColor = .white
       fc.showsVerticalScrollIndicator = false
       fc.layer.cornerRadius = 30
       fc.bounces = false
       return fc
   }()
    
    private let addToCartButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart >>" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "mygreen")
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
   
    //Mark :- Lifecycle Method

    override func viewDidLoad() {
        super .viewDidLoad()
        searchCellCollectionVw.delegate = self
        searchCellCollectionVw.dataSource = self
        searchTextField.delegate = self
        view.backgroundColor = UIColor(named: "mygreen")
        tblView.delegate = self
        tblView.dataSource = self
        configureUI()
        self.navigationController?.navigationBar.isHidden = true
        searchView.isHidden = true
        fetchDealsData()
        fetchCategoryData()
        fetchDiscountData()
        searchTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureProfilePicture()
    }
    //Mark :- Helper function
    
func configureUI(){
        view.addSubview(profileButton)
        profileButton.setDimensions(height: 50, width: 50)
        profileButton.addSubview(imageView)
        profileButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 60, paddingRight: 30)
        profileButton.layer.cornerRadius = 25
        imageView.anchor(top: profileButton.topAnchor, left: profileButton.leftAnchor, bottom: profileButton.bottomAnchor, right: profileButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        view.addSubview(hiLabel)
        hiLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 30, height: 25)
     
    view.addSubview(nameLabel)
     nameLabel.anchor(top: view.topAnchor, left: hiLabel.rightAnchor, paddingTop: 60, paddingLeft: 5, height: 25)
        
        view.addSubview(searchFoodLabel)
        searchFoodLabel.anchor(top: hiLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 30, width: view.frame.width - 90, height: 25)
        
        view.addSubview(searchTextField)
        searchTextField.anchor(top: searchFoodLabel.bottomAnchor, left: view.leftAnchor, paddingTop : 25, paddingLeft: 30, width: view.frame.width - 60, height: 55)
        
        view.addSubview(tblView)
    tblView.anchor(top: searchTextField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        tblView.separatorStyle = .none
        tblView.allowsSelection = false
    //to show all cells above tabbar
        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
    }
    
    func configureSearchView(){
        view.addSubview(searchView)
        searchView.anchor(top: searchTextField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        searchView.addSubview(searchCellCollectionVw)
        searchCellCollectionVw.anchor(top: self.searchView.topAnchor, left: self.searchView.leftAnchor,bottom: searchView.bottomAnchor, right: self.searchView.rightAnchor, paddingTop: 15, paddingLeft: 10,paddingBottom: 0, paddingRight: 10)
        searchCellCollectionVw.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
    }
    
    func configureProfilePicture(){
        let db = Firestore.firestore()
        
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection("users").document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data =  document.data()
                self.imageUrl = data?["url"] as? String
                self.name = data?["name"] as? String
                self.dataManager.getImageFrom(url: self.imageUrl, imageView: self.imageView)
                self.nameLabel.isHidden = false
                if let text = self.name {
                    if let first = text.components(separatedBy: " ").first{
                        self.nameLabel.text = first
                    }
                }
            }else{
                self.imageView.image = UIImage(named: "profile")
                self.nameLabel.isHidden = true
            }
        }
    }
    
    //fetching categories data(First tbl cell)
    func fetchCategoryData(){
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.category = []
            for document in querySnapshot!.documents {
             let data = document.data()
                print("data \(data)")
             let name = data["name"] as? String ?? " "
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? "No url"
             let id = data["id"]  as? String ?? " "
                let newCategory = Categories(name: name, rank: rank, url: url,id : id)
             self.category.append(newCategory)
            }
            self.tblView.reloadData()
            print("category \(self.category)")
            //sorting category cells according to rank
            self.sortedCategory = self.category.sorted(by: { $0.rank! < $1.rank! })
          
        }
    }
      }
    
    //fetching discount data(second tbl cell)
    func fetchDiscountData(){
        let db = Firestore.firestore()
        db.collection("discounts").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
               print("\(document.documentID) => \(document.data()["rank"] as! Int)")
             let data = document.data()
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? "No url"
             let id = data["id"] as? String ?? " "
             let discount = data["discount"] as? String ?? " "
             let createdAt = data["created_at"] as? String ?? " "
             let title = data["title"] as? String ?? " "
             let offerTitle = data["offerTitle"] as? String ?? " "
             let offerDescription = data["offerDescription"] as? String ?? " "
                let newDiscount = Discount(createdAt: createdAt, discount: discount, url: url, id: id, rank: rank, title : title ,offerTitle : offerTitle, offerDescription:offerDescription )
             self.discount.append(newDiscount)
            }
            self.tblView.reloadData()
            //sorting category cells according to rank
            self.sortedDiscount = self.discount.sorted(by: { $0.rank! < $1.rank! })
        }
    }
}
    
    //fetching Deals data(third cell)
    func fetchDealsData(){
        let db = Firestore.firestore()
        db.collection("deals").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
               print("\(document.documentID) => \(document.data()["rank"] as! Int)")
             let data = document.data()
             let name = data["name"] as? String ?? " "
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? "No url"
             let id = data["id"] as? String ?? " "
             let discount = data["discount"] as? String ?? " "
             let createdAt = data["created_at"] as? String ?? " "
             let newDeals = Deals(createdAt: createdAt, discount: discount, url: url, id: id, name: name, rank: rank )
             self.deals.append(newDeals)
            }
            //sorting category cells according to rank
            self.tblView.reloadData()
            self.sortedDeals = self.deals.sorted(by: { $0.rank! < $1.rank! })
            print("arrdeal \(self.sortedDeals)")
        }
    }
}
    
    func productsMatchingWithSearch(searchedText : String?){
        searchedProduct.removeAll()
        let db = Firestore.firestore()
       db.collection("products").whereField("search_keys", arrayContains: searchedText!).getDocuments() { [self] (querySnapshot, err) in
              if let err = err {
                   print("Error getting documents: \(err)")
              } else {
                   for document in querySnapshot!.documents {
                       let data = document.data()
                       let active = data["active"] as? Bool ?? nil
                       let name = data["name"] as? String ?? ""
                       let categoryId = data["category_id"] as? String ?? ""
                       let description = data["description"] as? String ?? ""
                       let tags = data["tags"] as? [String] ?? []
                       let price = data["price"] as? Int ?? 0
                       let url = data["url"] as? String ?? "No url"
                       let id = data["id"] as? String ?? ""
                       let searchKey = data["search_keys"] as? [String] ?? []
                       if active == true {
                           let newProduct = Product(active: active, categoryId: categoryId, description: description, price: price, name: name, tags: tags, url: url,searchKey: searchKey, id : id)
                       self.searchedProduct.append(newProduct)
                       self.searchCellCollectionVw.reloadData()
                       }
                   }
              }
    }
    }
    
    
    //Mark :- action Method

    @objc func profileButtonTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountVC = storyboard.instantiateViewController(identifier: "AccountDetailViewController") as! AccountDetailViewController
        accountVC.modalPresentationStyle = .fullScreen
        self.present(accountVC, animated: true, completion: nil)
    }
    
    @objc func seeDetailView(){
        let categoryVC = CategoriesViewController()
        categoryVC.dataArray = sortedCategory
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    @objc func addToCartPressed(){
        for product in searchedProduct {
                AppSharedDataManager.shared.productAddedToCart.append(product)
                NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
            
        }
    }
    
    //Mark :- perform action delegate method
    func pushViewController(controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //Mark :- searchTextField delegate method
    @objc func textFieldEditingDidChange(_ textField: UITextField){
        if let text = textField.text {
            if text.count > 0 {
                tblView.isHidden = true
                searchView.isHidden = false
                configureSearchView()
                self.productsMatchingWithSearch(searchedText: text)
            }else{
                searchedProduct = []
                searchCellCollectionVw.reloadData()
                tblView.isHidden = false
                searchView.isHidden = true
                textField.endEditing(true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoriesTableViewCell
            cell.collectionViewData(array: sortedCategory)
            cell.seeAllButton.addTarget(self, action: #selector(seeDetailView), for: .touchUpInside)
            cell.delegate = self
        return cell
        }else if indexPath.row == 1{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1") as! DiscountTableViewCell
            cell1.collectionViewData(array: sortedDiscount)
            return cell1
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! PopularDealsTableViewCell
            cell.collectionViewData(array: sortedDeals)
                
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
           return 250
        }else if indexPath.row == 1{
            return 180
        }else{
            return 300
        }
        
    }

}

extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchedProduct.count > 0{
            return self.searchedProduct.count
        }else{
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell1", for: indexPath) as! ProductCollectionViewCell
        cell.cellNumber = indexPath.row
       cell.addHorizontalView()
     //   cell.addVerticalView()
        if indexPath.row % 2 == 0{
            cell.addVerticalView()
            
        }
        cell.configureCellUI(product: searchedProduct[indexPath.row])
        cell.greenView.isHidden = true
        cell.plusButton.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let productDetailVC = storyboard.instantiateViewController(identifier: "ProductDetailViewController") as! ProductDetailViewController
       // let productDetailVC = ProductDetailViewController()
        productDetailVC.id  = searchedProduct[indexPath.row].id!
        productDetailVC.product = searchedProduct[indexPath.row]
        productDetailVC.modalPresentationStyle = .fullScreen
        productDetailVC.productArray = searchedProduct
        self.present(productDetailVC, animated: true, completion: nil)
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: 300 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
    
}
