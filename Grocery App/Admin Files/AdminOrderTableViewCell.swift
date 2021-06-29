//
//  AdminOrderTableViewCell.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 06/06/21.
//

import UIKit

class AdminOrderTableViewCell: UITableViewCell {

   
    @IBOutlet weak var orderTableViewInnerView: UIView!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderAddressLabel: UILabel!
    @IBOutlet weak var orderItemsLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
       // tableProductImage.layer.cornerRadius = tableProductImage.frame.size.height/2
        
      // tableProductImage.layer.masksToBounds = false
     //  tableProductImage.clipsToBounds = true
      //  tableProductImage.layer.backgroundColor = UIColor.white.cgColor
        orderStatusLabel.layer.borderWidth = 2
        if orderStatusLabel.text != "delivered" {
        orderStatusLabel.layer.borderColor = UIColor.systemIndigo.cgColor
            orderStatusLabel.textColor = UIColor.systemIndigo
        }
        else {
            orderStatusLabel.layer.borderColor = UIColor.systemGreen.cgColor
            orderStatusLabel.textColor = UIColor.systemGreen
        }
        orderStatusLabel.layer.cornerRadius =  15.0
        orderTableViewInnerView.layer.cornerRadius = 5
        orderTableViewInnerView.layer.borderWidth = 0.0
        orderTableViewInnerView.layer.shadowColor = UIColor.black.cgColor
        orderTableViewInnerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        orderTableViewInnerView.layer.shadowRadius = 5.0
        orderTableViewInnerView.layer.shadowOpacity = 0.4
        orderTableViewInnerView.layer.masksToBounds = false
        
    }
}
