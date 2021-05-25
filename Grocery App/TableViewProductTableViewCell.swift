//
//  TableViewProductTableViewCell.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 24/05/21.
//

import UIKit

class TableViewProductTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewInnerView: UIView!
    @IBOutlet weak var tableProductImage: UIImageView!
    
    @IBOutlet weak var tableProductName: UILabel!
    
    @IBOutlet weak var tableProductDescription: UILabel!
    @IBOutlet weak var tableProductPrice: UILabel!
    @IBOutlet weak var tableEditButton: UIButton!
}
