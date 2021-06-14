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
    
    @IBOutlet weak var addToCartButton: UIButton!
    //Mark :- Lifecycle method

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addToCartButton.layer.shadowColor = UIColor.darkGray.cgColor
        addToCartButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        addToCartButton.layer.shadowOpacity = 0.5
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
