//
//  ProductDetailSecondTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsButton: UIButton!
    
    @IBOutlet weak var reviewsButton: UIButton!
    
    @IBOutlet weak var reviewsNumberLabel: UILabel!
    
    @IBOutlet weak var belowDetailsView: UIView!
    
    @IBOutlet weak var belowReviewView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailsButton.tintColor = .black
        belowDetailsView.layer.cornerRadius = 25
        belowReviewView.isHidden = true
        reviewsButton.tintColor = .gray
    }

    @IBAction func DetailsButtonPressed(_ sender: Any) {
        detailsButton.tintColor = .black
        reviewsButton.tintColor = .gray
        belowDetailsView.isHidden = false
        belowReviewView.isHidden = true
        
    }
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        detailsButton.tintColor = .gray
        reviewsButton.tintColor = .black
        belowReviewView.isHidden = false
        belowDetailsView.isHidden = true
        
    }
    
}
