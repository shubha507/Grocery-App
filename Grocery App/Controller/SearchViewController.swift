//
//  SearchViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan  on 14/07/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SearchViewController: UIViewController,passQuantityChangeData, UITextFieldDelegate {
    
    var searchedProduct = [Product]()
    var dataManager = DataManager()

    @IBOutlet weak var numberOfItemInCartLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var numberOfItemInCartView: UIView!
    
    
    let searchCollectionView: UICollectionView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfItemInCartView.isHidden = true
        view.addSubview(searchCollectionView)
        searchCollectionView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.backgroundColor = UIColor(named: "mygreen")?.cgColor
        numberOfItemInCartView.layer.cornerRadius = 12.5
        numberOfItemInCartView.layer.borderWidth = 3
        numberOfItemInCartView.layer.borderColor = UIColor.systemRed.cgColor
        contentView.layer.cornerRadius = 30
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        searchBar.searchTextField.delegate = self
        searchBar.searchTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        searchBar.searchTextField.autocapitalizationType = .none
        NotificationCenter.default.addObserver(self, selector: #selector(numberOfProductAddedToCart), name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cartButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectIndex"), object: nil)
    }
    
    @objc func numberOfProductAddedToCart(){
        if AppSharedDataManager.shared.productAddedToCart.count == 0{
            numberOfItemInCartView.isHidden = true
        }else{
            numberOfItemInCartView.isHidden = false
            numberOfItemInCartLbl.text = "\(AppSharedDataManager.shared.productAddedToCart.count)"
        }
    }
    
    @objc func textFieldEditingDidChange(_ textField: UITextField){
            if let text = textField.text {
                if text.count > 0 {
                    print("text \(text)")
                    self.productsMatchingWithSearch(searchedText: text)
                }else{
                    searchedProduct = []
                    textField.endEditing(true)
                }
            }
        searchCollectionView.reloadData()
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func productsMatchingWithSearch(searchedText : String?){
        searchedProduct.removeAll()
        let db = Firestore.firestore()
        db.collection("products").whereField("search_keys", arrayContains: searchedText!).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let newProduct = Product(data : document.data())
                    if newProduct.active == true {
                        self.searchedProduct.append(newProduct)
                        self.searchCollectionView.reloadData()
                    }
                }
            }
        }
        db.collection("products").whereField("tags", arrayContains: searchedText!).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let newProduct = Product(data : document.data())
                    if newProduct.active == true {
                        self.searchedProduct.append(newProduct)
                        self.searchCollectionView.reloadData()
                    }
                }
            }
        }
    }

    
    func quantityChanged(cellIndex: Int?, quant: Double?, isQuantViewOpen: Bool?) {
        searchedProduct[cellIndex!].isQuantityViewOpen = isQuantViewOpen!
        searchedProduct[cellIndex!].quantity = quant!
        if quant! > 0 && searchedProduct[cellIndex!].isAddedToCart == false{
            AppSharedDataManager.shared.productAddedToCart.append(searchedProduct[cellIndex!])
            searchedProduct[cellIndex!].isAddedToCart = true
            NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
        }else if quant! == 0 && searchedProduct[cellIndex!].isAddedToCart == true {
            var index = 0
            for products in AppSharedDataManager.shared.productAddedToCart {
                if products.id == searchedProduct[cellIndex!].id {
                    AppSharedDataManager.shared.productAddedToCart.remove(at: index)
                    searchedProduct[cellIndex!].isAddedToCart = false
                    NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
                    return
                }else{
                    index = index + 1
                }
            }
        }else if quant! > 0 && searchedProduct[cellIndex!].isAddedToCart == true {
            for products in AppSharedDataManager.shared.productAddedToCart {
                if products.id == searchedProduct[cellIndex!].id {
                    products.quantity = quant!
          }
        }
      }
    }
}

extension SearchViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchedProduct.count > 0{
            return self.searchedProduct.count
        }else{
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell1", for: indexPath) as? ProductCollectionViewCell else {return UICollectionViewCell()}
        cell.delegate = self
        cell.cellNumber = indexPath.row
        cell.addHorizontalView()
        if indexPath.row % 2 == 0{
            cell.addVerticalView()
            
        }
        cell.configureCellUI(product: searchedProduct[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(identifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetailVC.id  = searchedProduct[indexPath.row].id!
        productDetailVC.product = searchedProduct[indexPath.row]
        productDetailVC.modalPresentationStyle = .fullScreen
        productDetailVC.tags = searchedProduct[indexPath.row].tags
        self.present(productDetailVC, animated: false, completion: nil)
    }
    
}

extension SearchViewController : UICollectionViewDelegateFlowLayout {
    
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
