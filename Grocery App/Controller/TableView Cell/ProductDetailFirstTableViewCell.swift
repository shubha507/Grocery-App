//
//  ProductDetailFirstTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 11/05/21.
//

import UIKit

class ProductDetailFirstTableViewCell: UITableViewCell {
    
    var quantity : Int?
    var price : Int?

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var decreaseQuantity: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var perPeicePriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var increaseQuantity: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func decreaseQuantityPressed(_ sender: Any) {
        if quantity! > 1 {
            quantity! = quantity! - 1
            quantityLabel.text = "\(quantity!) kg"
            priceLabel.text = "$\(price! * quantity!)"
        }
    }
    
    @IBAction func increaseQuantityPressed(_ sender: Any) {
        quantity! = quantity! + 1
        quantityLabel.text = "\(quantity!) kg"
        priceLabel.text = "$\(price! * quantity!)"
    }
    
    
}
