//
//  TableViewProductTableViewCell.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 24/05/21.
//

import UIKit

class TableViewProductTableViewCell: UITableViewCell {

    @IBOutlet weak var tableProductDiscountPrice: UILabel!
    @IBOutlet weak var tableViewInnerView: UIView!
    @IBOutlet weak var tableProductImage: UIImageView!
    
    @IBOutlet weak var tableProductName: UILabel!
    
    @IBOutlet weak var tableProductDescription: UILabel!
    @IBOutlet weak var tableProductPrice: UILabel!
    @IBOutlet weak var tableEditButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
      //  tableProductImage.layer.cornerRadius = tableProductImage.frame.size.height/2
        
       tableProductImage.layer.masksToBounds = false
       tableProductImage.clipsToBounds = true
        tableProductImage.layer.backgroundColor = UIColor.white.cgColor
        tableViewInnerView.layer.cornerRadius = 5
        tableViewInnerView.layer.borderWidth = 0.0
        tableViewInnerView.layer.shadowColor = UIColor.black.cgColor
        tableViewInnerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableViewInnerView.layer.shadowRadius = 5.0
        tableViewInnerView.layer.shadowOpacity = 0.4
        tableViewInnerView.layer.masksToBounds = false
        
    }
    
   /*required init?(coder aDecoder: NSCoder) {
   // super.init(style: UITableViewCell.CellStyle, reuseIdentifier: String? )
        fatalError("init(coder:) has not been implemented")
    }*/
    
}
