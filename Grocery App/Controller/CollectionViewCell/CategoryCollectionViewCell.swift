//
//  FirstCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 29/04/21.
//

import UIKit

class CategoryCollectionViewCell : UICollectionViewCell {
    
    //Mark :- Properties
    
    let dataManger = DataManager()
    
     let cellImage : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(named: "cellgreen")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let cellLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellImage)
          
        addSubview(cellImage)
        cellImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, width: 95, height : 120)
        
        contentView.addSubview(cellLabel)
        cellLabel.anchor(top: cellImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 95, height: 25)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureCellUI(categoty : Categories?){
        cellLabel.text = categoty?.name
        dataManger.getImageFrom(url: categoty?.url, imageView: cellImage)
    }
    
}
