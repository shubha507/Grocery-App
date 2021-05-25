//
//  CartTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 17/05/21.
//

import UIKit

class CartTableViewCell: UITableViewCell {
   
    var quantity = 1
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var pricePerPeiceLabel: UILabel!
    
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func plusButtonPressed(_ sender: Any) {
        quantity = quantity + 1
        productQuantityLabel.text = "\(quantity)"
    }
    @IBAction func minusButtonPressed(_ sender: Any) {
        if quantity > 1 {
            quantity = quantity - 1
            productQuantityLabel.text = "\(quantity)"
        }
    }
}
