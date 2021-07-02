//
//  ProductDetailNameQuantityTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 11/05/21.
//

import UIKit

class ProductDetailFirstTableViewCell: UITableViewCell {
    
    var quantity : Double?
    var price : Double?
    
    private let addToCartButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "mygreen")
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor.systemGray.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        return button
    }()
    
    var delegate : passQuantityChangeData?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var decreaseQuantity: UIButton!
    
    @IBOutlet weak var perPeicePriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var increaseQuantity: UIButton!
    
    @IBOutlet weak var quantityStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.addSubview(addToCartButton)
        addToCartButton.anchor(top: perPeicePriceLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 30, paddingLeft: 108, paddingBottom: 24.5, paddingRight: 108)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonPressed), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func addToCartButtonPressed(){
        addToCartButton.isHidden = true
        quantityStackView.isHidden = false
        quantity = 1
        quantityLabel.text = "\(Int(quantity!)) kg"
    }
    
    
    @IBAction func decreaseQuantityPressed(_ sender: Any) {
        if quantity! > 1 {
            quantity = quantity! - 1
            quantityLabel.text = "\(Int(quantity!)) kg"
            delegate?.quantityChanged(cellIndex: nil, quant: quantity!, isQuantViewOpen: true)
        }else if quantity! == 1{
            self.quantity = quantity! - 1
            addToCartButton.isHidden = false
            quantityStackView.isHidden = true
            quantityLabel.text = "\(Int(quantity!)) kg"
            delegate?.quantityChanged(cellIndex: nil, quant: quantity!, isQuantViewOpen: false)
        }
    }
    
    @IBAction func increaseQuantityPressed(_ sender: Any) {
        quantity = quantity! + 1
        quantityLabel.text = "\(Int(quantity!)) kg"
        delegate?.quantityChanged(cellIndex: nil, quant: quantity!, isQuantViewOpen: true)
    }
    
    func configureCellUI(product : Product?){
        if let product = product {
        nameLabel.text = product.name
        perPeicePriceLabel.text = "₹\(product.price!)/kg"
        price = product.price!
        quantityLabel.text = "\(Int(product.quantity)) kg"
        quantity = product.quantity
            if product.isAddedToCart {
                addToCartButton.isHidden = true
                quantityStackView.isHidden = false
            }else{
                addToCartButton.isHidden = false
                quantityStackView.isHidden = true
            }
    }
        
    }
    
}
