//
//  ProductDetailThirdCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailThirdCollectionViewCell: UICollectionViewCell {
    
    //Mark :- Properties
    var cellIndex : Int?
    var quantity : Int?
    var isQuantityViewOpen : Bool?
    var dataManager = DataManager()
    var delegate : passQuantityChangeData?
    
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var similarProductPerPeicePriceLabel: UILabel!
    @IBOutlet weak var similarProductImageView: UIImageView!
    @IBOutlet weak var similarProductPriceLabel: UILabel!
    @IBOutlet weak var similarProductNameLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    //Mark :- Lifecycle Method

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
        plusButton.layer.cornerRadius = 10
        plusButton.layer.maskedCorners = [.layerMinXMinYCorner]
        minusButton.isHidden = true
        quantityLabel.isHidden = true
        }
    
    //Mark :- Helper Function

    func configureCellUI(product : Product?){
        quantity = product!.quantity ?? 0
        quantityLabel.text = "\(product!.quantity ?? 0)"
        isQuantityViewOpen = product!.isQuantityViewOpen ?? nil
        similarProductPriceLabel.text = "\(product!.price ?? 0)"
        similarProductPerPeicePriceLabel.text = "\(product!.price ?? 0)/kg"
        similarProductNameLabel.text = product!.name ?? ""
        dataManager.getImageFrom(url: product!.url, imageView: similarProductImageView)
        if isQuantityViewOpen! {
            plusButton.layer.cornerRadius = 0
            minusButton.isHidden = false
            quantityLabel.isHidden = false
            minusButton.layer.cornerRadius = 10
            minusButton.layer.maskedCorners = [.layerMinXMinYCorner]
        }else{
            minusButton.isHidden = true
            quantityLabel.isHidden = true
        }
        
    }
    
    //Mark :- Action

    @IBAction func plusButtonPressed(_ sender: Any) {
        plusButton.layer.cornerRadius = 0
        quantityLabel.isHidden = false
        minusButton.isHidden = false
        minusButton.layer.cornerRadius = 10
        minusButton.layer.maskedCorners = [.layerMinXMinYCorner]
        quantity = quantity! + 1
        quantityLabel.text = "\(quantity!)"
        isQuantityViewOpen = true
        delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: isQuantityViewOpen)
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        if quantity! > 1 {
            quantity = quantity! - 1
            quantityLabel.text = "\(quantity!)"
            isQuantityViewOpen = true
            delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: isQuantityViewOpen)
        }else{
            quantity = 0
            quantityLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.layer.cornerRadius = 10
            plusButton.layer.maskedCorners = [.layerMinXMinYCorner]
            isQuantityViewOpen = false
            delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: isQuantityViewOpen)
        }
    }
}
