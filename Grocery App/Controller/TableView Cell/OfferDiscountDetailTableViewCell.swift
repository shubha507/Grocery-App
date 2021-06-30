//
//  OfferDiscountDetailTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan  on 29/06/21.
//

import UIKit

class OfferDiscountDetailTableViewCell: UITableViewCell {
    
    var dataManager = DataManager()

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceBeforeDiscountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowColor = UIColor.systemGray.cgColor
        cellView.layer.shadowOffset = CGSize(width: 5, height: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellUI(product : Product){
        nameLabel.text = product.name
        discountLabel.text = "-\(Int(product.discount!))%"
        dataManager.getImageFrom(url: product.url!, imageView: productImageView)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₹\(Int(product.price!))")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        priceBeforeDiscountLabel.attributedText = attributeString
        priceLabel.text = "₹\(Int(product.price!-(product.price!*product.discount!/100)))"
    }
}
