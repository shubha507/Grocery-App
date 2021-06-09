//
//  ProductDetailFourthTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailFourthTableViewCell: UITableViewCell {
    
    var product: Product?
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        if !product!.isAddedToCart && product!.quantity > 0 {
            AppSharedDataManager.shared.productAddedToCart.append(product!)
            product?.isAddedToCart = true
            NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
        }
    }
       
    
}
