//
//  FirstCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 29/04/21.
//

import UIKit

class CategoryCollectionViewCell : UICollectionViewCell {
    
    //Mark :- Properties
     let cellImage : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(named: "cellgreen")
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let cellLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    //Mark :- LifeCycle Method

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellImage)
        cellImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, width: 110, height: 110)
        
        addSubview(cellLabel)
        cellLabel.anchor(top: cellImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 110, height: 25)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
