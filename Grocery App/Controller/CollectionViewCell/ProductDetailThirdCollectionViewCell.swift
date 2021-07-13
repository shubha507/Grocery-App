//
//  ProductDetailThirdCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailThirdCollectionViewCell: UICollectionViewCell {
    
    var cellIndex : Int?
    
    var quantity : Double?
    
    var isQuantityViewOpen : Bool?
    
    var dataManager = DataManager()
    
    var delegate : passQuantityChangeData?
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var discountLabl: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var similarProductDiscountedPriceLabel: UILabel!
    @IBOutlet weak var similarProductImageView: UIImageView!
    
    @IBOutlet weak var similarProductPriceLabel: UILabel!
    @IBOutlet weak var similarProductNameLabel: UILabel!
    
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
        quantity = quantity! + 1
        quantityLabel.text = "\(Int(quantity!))"
        isQuantityViewOpen = true
        delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: isQuantityViewOpen)
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        if quantity! > 1 {
            quantity = quantity! - 1
            quantityLabel.text = "\(Int(quantity!))"
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
    
    func configureCellUI(product : Product?){
        quantity = product!.quantity ?? 0.0
        quantityLabel.text = "\(Int(product!.quantity ?? 0.0))"
        isQuantityViewOpen = product!.isQuantityViewOpen ?? nil
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
        if let discount = product?.discount, discount > 0 {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₹\(Int(product!.price ?? 0.0))")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            similarProductPriceLabel.attributedText = attributeString
            similarProductDiscountedPriceLabel.text = "₹\(Int(product!.price!-(product!.price!*(product!.discount!/100))))"
            discountLabl.text = "\(Int(product!.discount!))%off"
        }else{
            similarProductDiscountedPriceLabel.text = "₹\(Int(product!.price ?? 0.0))"
            similarProductPriceLabel.isHidden = true
            discountLabl.isHidden = true
        }
        
    }
}
