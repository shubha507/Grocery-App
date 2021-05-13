//
//  ProductDetailThirdCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailThirdCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var plusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
        plusView.layer.cornerRadius = 10
        plusView.layer.maskedCorners = [.layerMinXMinYCorner]
    }

}
