//
//  CategoriesViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 02/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class CategoriesViewController : UIViewController {
    
    var dataArray = [Categories]()
    
    var dictDocumentID = [Int : String]()
    
    let dataManager = DataManager()
    
  //  var productArray = [Product]()
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showHomeScreen), for: .touchUpInside)
        return button
    }()
    
    @objc func showHomeScreen(){
        navigationController?.popViewController(animated: true)
    }
    
    private let array = ["Vegetables","Fruits","Meat","Egg","Vegetables","Fruits","Meat","Egg","Vegetables","Fruits","Meat","Egg","Vegetables","Fruits","Meat"]
    
    private let categoryLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Catagories"
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
    
    let cellCollectionVw: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
       let fc = UICollectionView(frame: .zero, collectionViewLayout: layout)
       fc.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
       fc.backgroundColor = .white
       fc.showsVerticalScrollIndicator = false
       fc.layer.cornerRadius = 30
       fc.bounces = false
       return fc
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mygreen")
        print("dataArray \(dataArray)")
        
        cellCollectionVw.delegate = self
        cellCollectionVw.dataSource = self
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 40)
        
        view.addSubview(categoryLabel)
        categoryLabel.centerX(inView: view)
        categoryLabel.anchor(top: view.topAnchor, paddingTop: 60)
        
        view.addSubview(backView)
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        backView.addSubview(cellCollectionVw)
        cellCollectionVw.anchor(top: backView.topAnchor, left: backView.leftAnchor, bottom: backView.bottomAnchor, right: backView.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        cellCollectionVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }

}

extension CategoriesViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let controller = ProductsViewController()
        controller.pageTitle = dataArray[indexPath.row].name!
       // print(" url \(dataArray[indexPath.row].url ?? "no url")")
        controller.productId = dictDocumentID[dataArray[indexPath.row].rank!]!
        self.navigationController?.pushViewController(controller, animated: true)
       }
}

extension CategoriesViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CategoryCollectionViewCell
        cell.cellLabel.text = "\(dataArray[indexPath.row].name!)"
      //  cell.cellImage.image = UIImage(named: "\(array[indexPath.row])")
        dataManager.getImageFrom(url: "\(dataArray[indexPath.row].url!)", imageView: cell.cellImage, defaultImage: "Vegetables")
        return cell
    }
    
}

extension CategoriesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:110, height: 135 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
    }
    
    
}

