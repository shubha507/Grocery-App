//
//  CartTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 17/05/21.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    var cellIndex : Int?
    
    var dataManager = DataManager()
    
    var delegate : passQuantityChangeData?
   
    var quantity : Double?
    
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
    
    //Mark :- Helper function

    //Mark :- Action

    @IBAction func plusButtonPressed(_ sender: Any) {
        quantity = quantity! + 1
        productQuantityLabel.text = "\(Int(quantity!))"
        delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: nil)
    }
    
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        
        if quantity! > 1 {
            quantity = quantity! - 1
            productQuantityLabel.text = "\(Int(quantity!))"
            delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: nil)
        }else{
            quantity = 0
            delegate?.quantityChanged(cellIndex: cellIndex, quant: quantity!, isQuantViewOpen: nil)
        }
    }
    
    func configureCellUI(product : Product){
        productNameLabel.text = "\(product.name!)"
        quantity = product.quantity
        productQuantityLabel.text = "\(Int(product.quantity))"
        pricePerPeiceLabel.text = "₹\(product.price!)"
        priceLabel.text = "₹\(product.price! * product.quantity)"
        dataManager.getImageFrom(url: product.url!, imageView: productImageView)
        
    }
}
