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

class ProductsViewController : UIViewController, UICollectionViewDelegate{
    
    let dataManager = DataManager()
    
  //  var selectedDocumentid : String!
    
    var pageTitle : String?
    
   // var productArray = [Product]()
    
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
     //   print("productArray \(productArray)")
        
        
        
        
        self.dataManager.searchData(selectedId: productId) { (error) in
            print("self.dataManager.productArray \(self.dataManager.productArray)")
           // self.productArray = self.dataManager.productArray
           self.productCellCollectionVw.reloadData()
            self.configureView()
                    }
        print("productArray \(self.dataManager.productArray)")
        configureUI()
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
                self.noProductLbl.text = "No product available in \(self.pageTitle!) category"
}
}
    
    func configureUI(){
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 40)
        
        view.addSubview(productLabel)
        productLabel.centerX(inView: view)
        productLabel.anchor(top: view.topAnchor, paddingTop: 60)
        productLabel.text = "\(pageTitle!)"
        
        view.addSubview(backView)
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ProductDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell1", for: indexPath) as! ProductCollectionViewCell
       cell.addHorizontalView()
     //   cell.addVerticalView()
        if indexPath.row % 2 == 0{
            cell.addVerticalView()
            
        }
        cell.nameLabel.text = "\(dataManager.productArray[indexPath.row].name!)"
      //  cell.cellImage.image = UIImage(named: "\(productArray[indexPath.row])")
        dataManager.getImageFrom(url: "\(dataManager.productArray[indexPath.row].url!)", imageView: cell.cellImage, defaultImage: "Vegetables")
        cell.priceLabel.text = "$\(dataManager.productArray[indexPath.row].price!)"
        cell.descriptionLabel.text = "\(dataManager.productArray[indexPath.row].description!)"
        return cell
    }
    
}

extension ProductsViewController : UICollectionViewDelegateFlowLayout {
    
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

