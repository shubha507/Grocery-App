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
    
    var productArray = [Product]()
    
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
        print("productArray \(productArray)")
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 40)
        
        view.addSubview(productLabel)
        productLabel.centerX(inView: view)
        productLabel.anchor(top: view.topAnchor, paddingTop: 60)
        productLabel.text = "\(pageTitle!)"
        
        view.addSubview(backView)
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        if productArray.count > 0{
        backView.addSubview(productCellCollectionVw)
        productCellCollectionVw.anchor(top: backView.topAnchor, left: backView.leftAnchor, bottom: backView.bottomAnchor, right: backView.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        productCellCollectionVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        }else{
            backView.addSubview(noProductView)
            noProductView.anchor(top: backView.topAnchor, left: backView.leftAnchor, bottom: backView.bottomAnchor, right: backView.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
            noProductView.addSubview(noProductImageView)
            noProductImageView.anchor(top: noProductView.topAnchor, left: noProductView.leftAnchor, right: noProductView.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20, width: noProductView.frame.width - 40, height: 250)
            noProductView.addSubview(oopsLbl)
            oopsLbl.anchor(top: noProductImageView.bottomAnchor, left: noProductView.leftAnchor, right: noProductView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, width: noProductView.frame.width - 40, height: 40)
            noProductView.addSubview(noProductLbl)
            noProductLbl.anchor(top: oopsLbl.bottomAnchor, left: noProductView.leftAnchor, right: noProductView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, width: noProductView.frame.width - 40, height: 60)
            noProductLbl.text = "No product available in \(self.pageTitle!) category"
        }
        
    }
    
}

extension ProductsViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.productArray.count > 0{
            return self.productArray.count
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
        cell.nameLabel.text = "\(productArray[indexPath.row].name!)"
      //  cell.cellImage.image = UIImage(named: "\(productArray[indexPath.row])")
        dataManager.getImageFrom(url: "\(productArray[indexPath.row].url!)", imageView: cell.cellImage, defaultImage: "Vegetables")
        cell.priceLabel.text = "$\(productArray[indexPath.row].price!)"
        cell.descriptionLabel.text = "\(productArray[indexPath.row].description!)"
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

