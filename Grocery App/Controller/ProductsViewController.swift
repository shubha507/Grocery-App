//
//  ProductsViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 05/05/21.
//

import UIKit

class ProductsViewController : UIViewController, UICollectionViewDelegate{
    
    var selectedDocumentid : String!
    
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
        lbl.text = "Product"
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 25)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let backView : UIView = {
        let uv = UIView()
        uv.backgroundColor = UIColor(named: "buttoncolor")
        uv.layer.cornerRadius = 30
        return uv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mygreen")
        productCellCollectionVw.delegate = self
        productCellCollectionVw.dataSource = self
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 40)
        
        view.addSubview(productLabel)
        productLabel.centerX(inView: view)
        productLabel.anchor(top: view.topAnchor, paddingTop: 60)
        
        view.addSubview(backView)
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        backView.addSubview(productCellCollectionVw)
        productCellCollectionVw.anchor(top: backView.topAnchor, left: backView.leftAnchor, bottom: backView.bottomAnchor, right: backView.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        productCellCollectionVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
    }
    
}

extension ProductsViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell1", for: indexPath) as! ProductCollectionViewCell
      //  cell.cellLabel.text = "\(dataArray[indexPath.row].name!)"
      //  cell.cellImage.image = UIImage(named: "\(array[indexPath.row])")
      //  dataManager.getImageFrom(url: "\(dataArray[indexPath.row].url!)", imageView: cell.cellImage)
        return cell
    }
    
}

extension ProductsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-0.2, height: 300 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

