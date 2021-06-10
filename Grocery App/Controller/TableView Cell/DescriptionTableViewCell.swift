//
//  DescriptionTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 09/06/21.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actualPriceLbl: UILabel!
    var dataManager = DataManager()
    
    @IBOutlet weak var totalOrderedProductQuantityPrice: UILabel!
    @IBOutlet weak var orderedProductPrice: UILabel!
    @IBOutlet weak var orderedProductName: UILabel!
    @IBOutlet weak var orderedProductImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actualPriceLbl.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellUI(order : Order , index : Int){
        self.orderedProductPrice.text = "₹\(Int((order.items?[index].price)! - (order.items?[index].totalDiscount)!))"
        self.orderedProductName.text = order.items?[index].name
        self.dataManager.getImageFrom(url: order.items?[index].url!, imageView: orderedProductImageView)
        self.totalOrderedProductQuantityPrice.text = "₹\(Int((order.items?[index].price)! * Double((order.items?[index].count)!)))  (\(Int((order.items?[index].count)!))X\(Int((order.items?[index].price)!)))"
        if (order.items?[index].totalDiscount)! != 0{
            actualPriceLbl.isHidden = false
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₹\(Int((order.items?[index].price)!))")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            actualPriceLbl.attributedText = attributeString
            actualPriceLbl.textColor = .darkGray
        }
    }
}
