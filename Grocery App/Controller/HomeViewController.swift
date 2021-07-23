//  HomeViewController.swift
//  Grocery App

//  Created by Shubha Sachan on 28/04/21.


import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class HomeViewController : UIViewController, UITableViewDelegate, PerformAction, UITextFieldDelegate {
    
    
    //Mark :- Properties
    var dataManager = DataManager()
    var productArray = [Product]()
    var category = [Categories]()
    var sortedCategory = [Categories]()
    var discount = [Discount]()
    var sortedDiscount = [Discount]()
    var deals = [Deals]()
    var sortedDeals = [Deals]()
    var imageUrl : String?
    var isHidden : Bool?
    
    private let imageView : UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    private let hiLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont(name: "PTSans-Regular", size: 18)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let searchFoodLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome to the grocery store"
        lbl.textColor = .white
        lbl.font = UIFont(name: "PTSans-Regular", size: 18)
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
        
        stf.backgroundColor = .white
        stf.autocapitalizationType = .none
        return stf
    }()
    
    private let tblView : UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(named: "buttoncolor")
        tv.register(CategoriesTableViewCell.self, forCellReuseIdentifier: "cell")
        tv.register(DiscountTableViewCell.self, forCellReuseIdentifier: "cell1")
        tv.register(PopularDealsTableViewCell.self,forCellReuseIdentifier: "cell2")
        tv.showsVerticalScrollIndicator = false
        tv.bounces = false
        return tv
    }()
    
    
    //Mark :- Lifecycle Method
    override func viewDidLoad() {
        super .viewDidLoad()
        
        searchTextField.delegate = self
        view.backgroundColor = UIColor(named: "mygreen")
        tblView.delegate = self
        tblView.dataSource = self
        configureUI()
        self.navigationController?.navigationBar.isHidden = true
        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:UIScreen.main.bounds.height/896 * 60, right: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectCartIndex), name: NSNotification.Name(rawValue: "selectIndex"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureProfilePicture()
        fetchDealsData()
        fetchCategoryData()
        fetchDiscountData()
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
        
        view.addSubview(searchFoodLabel)
        searchFoodLabel.anchor(top: hiLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 30, width: view.frame.width - 90, height: 25)
        
        view.addSubview(searchTextField)
        searchTextField.anchor(top: searchFoodLabel.bottomAnchor, left: view.leftAnchor, paddingTop : 15, paddingLeft: 30, width: view.frame.width - 60, height: 45)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search your daily grocery food...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        view.addSubview(tblView)
        tblView.anchor(top: searchTextField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        tblView.separatorStyle = .none
        tblView.allowsSelection = false
        
    }
    
    func configureProfilePicture(){
        guard let user = Auth.auth().currentUser else {return}
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { (document, error) in
            if let error = error {
                print("profile picture error \(error.localizedDescription)")
                self.hiLabel.text = "Hey,"
                self.imageView.image = UIImage(named: "profile")
            }else if let document = document, document.exists {
                let data =  document.data()
                if let name = data?["name"] as? String, let url = data?["url"] as? String {
                    self.hiLabel.text = "Hey \(String(describing: name)),"
                    self.imageUrl = url
                self.dataManager.getImageFrom(url: self.imageUrl, imageView: self.imageView)
                }else{
                    self.imageView.image = UIImage(named: "profile")
                }
            }
        }
    }
    
    
    
    //fetching categories data(First tbl cell)
    func fetchCategoryData(){
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting category documents: \(err)")
            } else {
                self.category = []
                for document in querySnapshot!.documents {
                    let newCategory = Categories(data : document.data())
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
                print("Error getting discount documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data()["rank"] as! Int)")
                    let newDiscount = Discount(data: document.data() )
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
                print("Error getting deals documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data()["rank"] as! Int)")
                    let newDeals = Deals(data: document.data() )
                    self.deals.append(newDeals)
                }
                //sorting category cells according to rank
                self.tblView.reloadData()
                self.sortedDeals = self.deals.sorted(by: { $0.rank! < $1.rank! })
                print("arrdeal \(self.sortedDeals)")
            }
        }
    }
    
    
    
    //Mark :- action Method
    
    @objc func profileButtonTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountVC = storyboard.instantiateViewController(identifier: "AccountDetailViewController") as! AccountDetailViewController
        accountVC.modalPresentationStyle = .fullScreen
        self.present(accountVC, animated: false, completion: nil)
    }
    
    @objc func seeDetailView(){
        let categoryVC = CategoriesViewController()
        categoryVC.dataArray = sortedCategory
        self.navigationController?.pushViewController(categoryVC, animated: false)
    }
    
    @objc func selectCartIndex(){
        self.tabBarController?.selectedIndex = 2
    }
    
    //Mark :- perform action delegate method
    func pushViewController(controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func presentViewController(controller: UIViewController) {
        self.present(controller, animated: false)
    }
    
    //Mark :- searchTextField delegate method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: false, completion: nil)
    }

}

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CategoriesTableViewCell {
            
            cell.collectionViewData(array: sortedCategory)
            cell.seeAllButton.addTarget(self, action: #selector(seeDetailView), for: .touchUpInside)
            cell.delegate = self
            return cell
        }else if indexPath.row == 1, let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? DiscountTableViewCell {
            cell.delegate = self
            cell.collectionViewData(array: sortedDiscount)
            return cell
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as? PopularDealsTableViewCell{
            cell.collectionViewData(array: sortedDeals)
            
            return cell
        }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return UIScreen.main.bounds.height/896 * 448
        }else if indexPath.row == 1{
            return 180
        }else{
            return 300
        }
        
    }
    
}
