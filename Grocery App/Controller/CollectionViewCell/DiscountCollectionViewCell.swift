//
//  SecondCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 30/04/21.
//

import UIKit

class DiscountCollectionViewCell : UICollectionViewCell {
    
    //Mark :- Properties
    let dataManager = DataManager()
    
     private let basketImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "fruitBasket"))
        iv.contentMode = .scaleToFill
        return iv
    }()
    
     private let discountLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "30% Discount"
        lbl.font = UIFont.boldSystemFont(ofSize: 23)
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

    //Mark :- Lifecycle Method

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "discountCellGreen")
        layer.cornerRadius = 30
        
        contentView.addSubview(basketImageView)
        basketImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,paddingTop: 15, paddingLeft: 10, paddingBottom: 15,width: 110)
        
        configureLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark :- Helper Function

    func configureLabels(){
        contentView.addSubview(discountLabel)
        discountLabel.anchor(top: contentView.topAnchor, left: basketImageView.rightAnchor, right: contentView.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingRight: 5)
        
        contentView.addSubview(discountDescriptionLabel)
        discountDescriptionLabel.anchor(top: discountLabel.bottomAnchor, left: basketImageView.rightAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 5)
        discountDescriptionLabel.sizeToFit()
        
        contentView.addSubview(orderNowLabel)
        orderNowLabel.anchor(top: discountDescriptionLabel.bottomAnchor, left: basketImageView.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 25, paddingRight: 5)
    }
    
    func configureUI(discountLbl : String?, discountDescriptionLbl : String?, url : String?){
        self.discountLabel.text = discountLbl
        self.discountDescriptionLabel.text = discountDescriptionLbl
        dataManager.getImageFrom(url: url, imageView: basketImageView)
    }
}
