//
//  OrderStatusCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 31/05/21.
//

import UIKit

class OrderStatusCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = 10
    }
    
    
}
