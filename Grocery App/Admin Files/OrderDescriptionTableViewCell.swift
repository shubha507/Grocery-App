//
//  OrderDescriptionTableViewCell.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 07/06/21.
//

import UIKit

class OrderDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var productOrderImage: UIImageView!
    @IBOutlet weak var countProduct: UILabel!
    @IBOutlet weak var cartProductName: UILabel!
    @IBOutlet weak var cartDiscountPrice: UILabel!
    @IBOutlet weak var cartProductPrice: UILabel!
    @IBOutlet weak var cartProductDiscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //productOrderImage.layer.cornerRadius = 5
    }

   

}
