//
//  CartTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 17/05/21.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    //Mark :- Properties
    var cellIndex : Int?
    var dataManager = DataManager()
    var delegate : passQuantityChangeData?
    var quantity : Int?
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var pricePerPeiceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //Mark :- Lifecycle Method

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Mark :- Helper function

    func configureCellUI(product : Product){
        productNameLabel.text = "\(product.name!)"
        if product.quantity == 0 {
            quantity! = 1
            delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: nil)
        }else{
        quantity = product.quantity
        }
        productQuantityLabel.text = "\(quantity! ?? 0)"
        pricePerPeiceLabel.text = "₹\(product.price!)"
        priceLabel.text = "₹\(product.price! * (quantity ?? 0))"
        dataManager.getImageFrom(url: product.url!, imageView: productImageView)
        
    }

    //Mark :- Action

    @IBAction func plusButtonPressed(_ sender: Any) {
        quantity = quantity! + 1
        productQuantityLabel.text = "\(quantity!)"
        delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: nil)
    }
    
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        
        if quantity! > 1 {
            quantity = quantity! - 1
            productQuantityLabel.text = "\(quantity!)"
            delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: nil)
        }else{
            quantity = 0
            delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: nil)
        }
    }
    
}
