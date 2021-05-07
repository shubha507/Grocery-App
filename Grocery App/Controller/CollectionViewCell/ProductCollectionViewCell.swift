//
//  ProductCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 05/05/21.
//

import UIKit

class ProductCollectionViewCell : UICollectionViewCell {
    
    let cellImage : UIImageView = {
       let iv = UIImageView()
      // iv.backgroundColor = UIColor(named: "cellgreen")
        iv.backgroundColor = .white
        iv.contentMode = .scaleToFill
       return iv
   }()
    
    let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 25)
        lbl.text = "Apple (1kg)"
        lbl.textColor = .black
        lbl.textAlignment = .left
        return lbl
    }()
    
    let descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.text = "$17.00/kg"
        lbl.textColor = .lightGray
        lbl.textAlignment = .left
        return lbl
    }()
    
    let priceLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.text = "$17.00/kg"
        lbl.textColor = UIColor(named: "mygreen")
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let cellBorderView : UIView = {
        let vw = UIView()
        vw.backgroundColor = .lightGray
        return vw
    }()
    
    private let cellHorizntalBorderView : UIView = {
        let vw = UIView()
        vw.backgroundColor = .lightGray
        return vw
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
       // layer.borderWidth = 0.5
       // layer.borderColor = UIColor.gray.cgColor
        
        addSubview(cellImage)
        cellImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, width: 100, height: 170)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: cellImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop:10, paddingLeft: 10,paddingRight: 10, width: frame.width, height: 30)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, width: frame.width, height: 40)
        
        addSubview(priceLabel)
        priceLabel.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 10, width: frame.width, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addVerticalView(){
        contentView.addSubview(cellBorderView)
        cellBorderView.anchor(top: topAnchor, right: rightAnchor, paddingTop: 0, paddingRight: 0, width: 0.5, height: 300)
    }
    
    func addHorizontalView(){
        contentView.addSubview(cellHorizntalBorderView)
        cellHorizntalBorderView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: frame.width, height: 0.5)
    }

    
}
