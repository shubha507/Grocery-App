//
//  OrderStatusDesignTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 31/05/21.
//

import UIKit

class OrderStatusDesignTableViewCell: UITableViewCell {

    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusView.layer.cornerRadius = statusView.frame.width/2
        statusView.layer.borderWidth = 1
        statusView.layer.borderColor = UIColor.systemGray3.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
