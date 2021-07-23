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
    
    //Mark :- Properties
    var dataArray = [Categories]()
    
    let dataManager = DataManager()
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showHomeScreen), for: .touchUpInside)
        return button
    }()
    
    @objc func showHomeScreen(){
        navigationController?.popViewController(animated: false)
    }
    
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
    
    //Mark :- Lifecycle method

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mygreen")
        
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

        controller.productId = dataArray[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: false)
        
       }
}

extension CategoriesViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CategoryCollectionViewCell else {return UICollectionViewCell()}
        cell.cellLabel.text = "\(dataArray[indexPath.row].name!)"
        dataManager.getImageFrom(url: "\(dataArray[indexPath.row].url!)", imageView: cell.cellImage)
        return cell
    }
    
}

extension CategoriesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:UIScreen.main.bounds.width/414 * 110, height: UIScreen.main.bounds.height/896 * 135 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width/414 * 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:UIScreen.main.bounds.height/896 * 15, left: UIScreen.main.bounds.width/414*10, bottom: 0, right: UIScreen.main.bounds.width/414*10)
    }
    
    
}

