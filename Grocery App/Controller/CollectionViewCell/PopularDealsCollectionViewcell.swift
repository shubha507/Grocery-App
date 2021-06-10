//
//  PopularDealsCollectionViewcell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 07/05/21.
//

import UIKit

class PopularDealsCollectionViewCell : UICollectionViewCell {
    
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
    
    let discountLabel : UILabel = {
        let dIV = UILabel()
        dIV.backgroundColor = .clear
        dIV.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 50))
        dIV.numberOfLines = 0
        dIV.textColor = .white
        dIV.textAlignment = .center
        return dIV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellImage)
        cellImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, width: 160, height: 160)
        
        
        contentView.addSubview(cellLabel)
        cellLabel.anchor(top: cellImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 25)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
