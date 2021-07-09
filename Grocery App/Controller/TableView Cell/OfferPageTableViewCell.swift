//
//  OfferPageTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 11/06/21.
//

import UIKit

class OfferPageTableViewCell: UITableViewCell {
    
    var dataManager = DataManager()

    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var orderNowLabel: UILabel!
    @IBOutlet weak var offerDescriptionLabel: UILabel!
    @IBOutlet weak var offerMainLabel: UILabel!
    @IBOutlet weak var offerImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        offerMainLabel.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.width / 414 * 30)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellUI(discount : Discount){
        orderNowLabel.text = "Order now"
        offerMainLabel.text = discount.offerTitle
        offerDescriptionLabel.text = discount.offerDescription
        dataManager.getImageFrom(url: discount.url, imageView: offerImageView)
    }

}
