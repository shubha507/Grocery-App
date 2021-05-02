//
//  SecondCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 30/04/21.
//

import UIKit

class SecondCollectionViewCell : UICollectionViewCell {
    
    private let basketImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "fruitBasket"))
        return iv
    }()
    
    private let discountLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "30% Discount"
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textColor = UIColor(named: "mygreen")
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let discountDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Order any food from app and get the discount"
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let orderNowLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Order Now"
        lbl.textColor = UIColor(named: "mygreen")
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textAlignment = .center
        return lbl
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "discountCellGreen")
        layer.cornerRadius = 30
        
        addSubview(basketImageView)
        basketImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,paddingTop: 15, paddingLeft: 15, paddingBottom: 15)
        basketImageView.setDimensions(height: 50, width: 80)
        
        configureStack()
    }
    
    func configureStack(){
        let stack = UIStackView(arrangedSubviews: [discountLabel,discountDescriptionLabel,orderNowLabel])
        stack.axis = .vertical
        stack.spacing = 10
        
        addSubview(stack)

        stack.anchor(top: topAnchor,left: basketImageView.rightAnchor, paddingTop: 15,paddingLeft: 15)
        stack.setDimensions(height: 120, width: 185)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
