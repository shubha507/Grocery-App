//
//  SecondCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 30/04/21.
//

import UIKit

class DiscountCollectionViewCell : UICollectionViewCell {
    
    let dataManager = DataManager()
    
     private let basketImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "fruitBasket"))
        iv.contentMode = .scaleToFill
        return iv
    }()
    
     private let discountLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "30% Discount"
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.textColor = UIColor(named: "mygreen")
        lbl.numberOfLines = 0
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
        lbl.textAlignment = .left
        return lbl
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "discountCellGreen")
        layer.cornerRadius = 30
        
        addSubview(basketImageView)
        basketImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,paddingTop: 15, paddingLeft: 10, paddingBottom: 15,width: 110)
        
        configureStack()
    }
    
    func configureStack(){
        let stack = UIStackView(arrangedSubviews: [discountLabel,discountDescriptionLabel,orderNowLabel])
        stack.axis = .vertical
        stack.spacing = 10
        
        addSubview(stack)

        stack.anchor(top: topAnchor,left: basketImageView.rightAnchor, paddingTop: 15,paddingLeft: 10)
        stack.setDimensions(height: 135, width: 200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(discountLbl : String?, discountDescriptionLbl : String?, url : String?){
        self.discountLabel.text = discountLbl
        self.discountDescriptionLabel.text = discountDescriptionLbl
        dataManager.getImageFrom(url: url, imageView: basketImageView)
    }
}
