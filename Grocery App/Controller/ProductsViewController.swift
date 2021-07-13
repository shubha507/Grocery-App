//
//  ProductsViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 05/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class ProductsViewController : UIViewController,UICollectionViewDelegate, passQuantityChangeData{
    
    
    
    let dataManager = DataManager()
    
    var pageTitle : String?
    
    var productId : String?
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showCategoryScreen), for: .touchUpInside)
        return button
    }()

    @objc func showCategoryScreen(){
        self.navigationController?.popViewController(animated: true)
    }
    
    let productCellCollectionVw: UICollectionView = {
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
    
    
    private let productLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 25)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let noProductImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "no-product"))
        iv.backgroundColor = UIColor(red: 163/255, green: 194/255, blue: 194/255, alpha: 1)
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    
    private let backView : UIView = {
        let uv = UIView()
        uv.backgroundColor = UIColor(named: "buttoncolor")
        uv.layer.cornerRadius = 30
        return uv
    }()
    
    private let noProductView : UIView = {
        let uv = UIView()
        uv.backgroundColor = UIColor(red: 163/255, green: 194/255, blue: 194/255, alpha: 1)
        uv.layer.cornerRadius = 30
        return uv
    }()
    
    private let oopsLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 35)
        lbl.textColor = .red
        lbl.text = "Oops!"
        lbl.textAlignment = .center
    return lbl
    }()
    
    private let noProductLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 25)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
    return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mygreen")
        productCellCollectionVw.delegate = self
        productCellCollectionVw.dataSource = self
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("quantityChangedInCart"), object: nil)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dataManager.searchData(selectedId: productId, matchId: "category_id") { (error) in
           self.productCellCollectionVw.reloadData()
            self.productCellCollectionVw.layoutIfNeeded()
            self.configureView()
                    }
    }
    
    //Mark :- Helper Function
    
    @objc func reloadData(){
        self.productCellCollectionVw.reloadData()
    }
    
    func configureView(){
        if self.dataManager.productArray.count > 0{
            self.backView.backgroundColor = UIColor(named: "buttoncolor")
            self.backView.addSubview(self.productCellCollectionVw)
            self.productCellCollectionVw.anchor(top: self.backView.topAnchor, left: self.backView.leftAnchor, bottom: self.backView.bottomAnchor, right: self.backView.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
            self.productCellCollectionVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        }else{
            self.backView.backgroundColor = UIColor(red: 163/255, green: 194/255, blue: 194/255, alpha: 1)
            self.backView.addSubview(self.noProductView)
            self.noProductView.anchor(top: self.backView.topAnchor, left: self.backView.leftAnchor, bottom: self.backView.bottomAnchor, right: self.backView.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
            self.noProductView.addSubview(self.noProductImageView)
            self.noProductImageView.anchor(top: self.noProductView.topAnchor, left: self.noProductView.leftAnchor, right: self.noProductView.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20, width: self.noProductView.frame.width - 40, height: 250)
            self.noProductView.addSubview(self.oopsLbl)
            self.oopsLbl.anchor(top: self.noProductImageView.bottomAnchor, left: self.noProductView.leftAnchor, right: self.noProductView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, width: self.noProductView.frame.width - 40, height: 40)
            self.noProductView.addSubview(self.noProductLbl)
            self.noProductLbl.anchor(top: self.oopsLbl.bottomAnchor, left: self.noProductView.leftAnchor, right: self.noProductView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, width: self.noProductView.frame.width - 40, height: 60)
            if let title = self.pageTitle {
            self.noProductLbl.text = "No product available in \(title) category"
            }
        }
    }
    
    func configureUI(){
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 40)
        
        view.addSubview(productLabel)
        productLabel.centerX(inView: view)
        productLabel.anchor(top: view.topAnchor, paddingTop: 60)
        productLabel.text = "\(pageTitle ?? "")"
        
        view.addSubview(backView)
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
    }
    
    //Mark :- passQuantitychange delegate method
    
    func quantityChanged(cellIndex: Int?, quant: Double?, isQuantViewOpen: Bool?) {
        guard let cellIndex = cellIndex, let quant = quant, let isQuantViewOpen = isQuantViewOpen else {return}
        dataManager.productArray[cellIndex].isQuantityViewOpen = isQuantViewOpen
        dataManager.productArray[cellIndex].quantity = quant
        print(quant)
        if quant > 0 && dataManager.productArray[cellIndex].isAddedToCart == false{
            AppSharedDataManager.shared.productAddedToCart.append(dataManager.productArray[cellIndex])
            dataManager.productArray[cellIndex].isAddedToCart = true
            NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
        }else if quant == 0 && dataManager.productArray[cellIndex].isAddedToCart == true {
            var index = 0
            for products in AppSharedDataManager.shared.productAddedToCart {
                if products.id == dataManager.productArray[cellIndex].id {
                    AppSharedDataManager.shared.productAddedToCart.remove(at: index)
                    dataManager.productArray[cellIndex].isAddedToCart = false
                    NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
                    return
                }else{
                    index = index + 1
                }
            }
            
        }else if quant > 0 && dataManager.productArray[cellIndex].isAddedToCart == true {
            for products in AppSharedDataManager.shared.productAddedToCart {
                if products.id == dataManager.productArray[cellIndex].id {
                    products.quantity = quant
                }
        }
      }
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(identifier: "ProductDetailViewController") as! ProductDetailViewController
        // let productDetailVC = ProductDetailViewController()
        productDetailVC.id  = dataManager.productArray[indexPath.row].id
        productDetailVC.product = dataManager.productArray[indexPath.row]
        productDetailVC.modalPresentationStyle = .fullScreen
        productDetailVC.productArray = dataManager.productArray
        self.present(productDetailVC, animated: true, completion: nil)
    }

}

extension ProductsViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataManager.productArray.count > 0{
            return self.dataManager.productArray.count
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
        cell.configureCellUI(product: dataManager.productArray[indexPath.row])
        
        return cell
    }
    
}

extension ProductsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: 300  )
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

