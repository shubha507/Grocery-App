//
//  ProductDetailThirdCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailThirdCollectionViewCell: UICollectionViewCell {

    var quantity = 0
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    @IBOutlet weak var plusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
        plusButton.layer.cornerRadius = 10
        plusButton.layer.maskedCorners = [.layerMinXMinYCorner]
        minusButton.isHidden = true
        quantityLabel.isHidden = true
        
    }
    @IBAction func plusButtonPressed(_ sender: Any) {
        plusButton.layer.cornerRadius = 0
        quantityLabel.isHidden = false
        minusButton.isHidden = false
        minusButton.layer.cornerRadius = 10
        minusButton.layer.maskedCorners = [.layerMinXMinYCorner]
        quantity = quantity + 1
        quantityLabel.text = "\(quantity)"
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        if quantity > 1 {
            quantity = quantity - 1
            quantityLabel.text = "\(quantity)"
        }else{
            quantityLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.layer.cornerRadius = 10
            plusButton.layer.maskedCorners = [.layerMinXMinYCorner]
        }
    }
    
    
}
