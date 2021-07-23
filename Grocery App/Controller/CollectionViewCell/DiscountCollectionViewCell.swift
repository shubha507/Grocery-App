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
        lbl.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.width / 414 * 23)
        lbl.textColor = UIColor(named: "mygreen")
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
     private let discountDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize:UIScreen.main.bounds.width / 414 * 17)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let orderNowLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Order Now"
        lbl.textColor = UIColor(named: "mygreen")
        lbl.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.width / 414 * 19)
        lbl.textAlignment = .center
        return lbl
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "discountCellGreen")
        layer.cornerRadius = 15
        
        contentView.addSubview(basketImageView)
        basketImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,paddingTop: 15, paddingLeft: 10, paddingBottom: 10,width: 110)
        
        contentView.addSubview(discountLabel)
        discountLabel.anchor(top: topAnchor, left: basketImageView.rightAnchor, right: rightAnchor, paddingTop: 25, paddingLeft: 10, paddingRight: 10)
        
        contentView.addSubview(discountDescriptionLabel)
        discountDescriptionLabel.anchor(top: discountLabel.bottomAnchor, left: basketImageView.rightAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        contentView.addSubview(orderNowLabel)
        orderNowLabel.anchor(top: discountDescriptionLabel.bottomAnchor, left: basketImageView.rightAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        orderNowLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 5)
        
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
