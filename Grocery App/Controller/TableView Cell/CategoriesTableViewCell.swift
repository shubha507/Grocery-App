//
//  TableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 29/04/21.
//

import UIKit

//created to go directly from categoriestableviewcell to productViewController as we can not go from cell to controller

class CategoriesTableViewCell : UITableViewCell, UICollectionViewDelegate {
    
    var delegate : PerformAction?
    
    let dataManager = DataManager()
    
    var array1 = [Categories]()
    
    var array = ["Vegetables","Fruits","Meat","Egg"]
    
    private let cellView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 15
        return cv
    }()
    
     let categoryLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Category"
        lbl.font = UIFont(name: "PTSans-Bold", size: 22)
        lbl.textColor = .black
        return lbl
    }()
    
     let seeAllButton : UIButton = {
        let button = UIButton(type : .custom)
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named : "mygreen"), .font: UIFont.systemFont(ofSize: 22)]
        let attributedTitle = NSMutableAttributedString(string: "See all", attributes: atts)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
        
     let categoriesCellCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let fc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        fc.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        fc.backgroundColor = .white
        fc.showsHorizontalScrollIndicator = false
        fc.bounces = false
        fc.allowsMultipleSelection = false
        fc.allowsSelection = true
        fc.isScrollEnabled = false
        fc.layer.cornerRadius = 15
        return fc
    }()
    
    //created function to pass data from tableview to collectionview
    func collectionViewData(array : [Categories]){
        self.array1 = array
        categoriesCellCollection.reloadData()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        categoriesCellCollection.delegate = self
        categoriesCellCollection.dataSource = self
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI(){
        
        contentView.addSubview(cellView)
        cellView.setDimensions(height: UIScreen.main.bounds.height/896 * 433, width: 30)
        cellView.anchor(top: topAnchor, left : leftAnchor,right: rightAnchor, paddingTop: 15, paddingLeft: 15,paddingRight: 15)
        backgroundColor = UIColor(named: "buttoncolor")
        
        cellView.addSubview(categoryLabel)
        categoryLabel.anchor(top: cellView.topAnchor, left: cellView.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        cellView.addSubview(seeAllButton)
        seeAllButton.anchor(top: cellView.topAnchor, right: cellView.rightAnchor, paddingTop: 15, paddingRight: 20)
        
        cellView.addSubview(categoriesCellCollection)
        categoriesCellCollection.anchor(top: categoryLabel.bottomAnchor, left: cellView.leftAnchor, right: cellView.rightAnchor, paddingTop: 25, paddingLeft: 0, paddingRight: 0)
        categoriesCellCollection.setDimensions(height: UIScreen.main.bounds.height/896 * 360, width: cellView.frame.width)
   }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ProductsViewController()
        if let name = array1[indexPath.row].name , let id = array1[indexPath.row].id {
        controller.pageTitle = array1[indexPath.row].name
        controller.productId = array1[indexPath.row].id
        }
        delegate?.pushViewController(controller: controller)
    }

}

extension CategoriesTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array1.count/2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CategoryCollectionViewCell else {return UICollectionViewCell()}
        if let name = array1[indexPath.row].name , let url = array1[indexPath.row].url {
        cell.cellLabel.text = "\(name)"
        dataManager.getImageFrom(url: "\(url)", imageView: cell.cellImage)
        }
        return cell
    }
}

extension CategoriesTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:UIScreen.main.bounds.width/414 * 95, height: UIScreen.main.bounds.height/896 * 155 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width/414 * 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width/414*25, bottom: 0, right: UIScreen.main.bounds.width/414*20)
    }
}
