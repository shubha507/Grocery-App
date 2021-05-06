//
//  SecondTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 29/04/21.
//

import UIKit

class SecondTableViewCell : UITableViewCell, UICollectionViewDelegate {
    
    let secondCellCollection : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
        let fc = UICollectionView(frame: .zero, collectionViewLayout: layout)
       fc.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell1")
       fc.backgroundColor = UIColor(named: "buttoncolor")
       fc.showsHorizontalScrollIndicator = false
       fc.bounces = false
       return fc
   }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        secondCellCollection.delegate = self
        secondCellCollection.dataSource = self
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI(){
        contentView.addSubview(secondCellCollection)
        secondCellCollection.anchor(top: topAnchor, left: leftAnchor, bottom:  bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 200)
        
    }
}

extension SecondTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell1", for: indexPath) as! SecondCollectionViewCell
        return cell

    }
    
    
}

extension SecondTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:frame.width - 80, height: 165 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 0)
    }
}
