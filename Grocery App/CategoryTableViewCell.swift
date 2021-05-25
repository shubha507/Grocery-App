//
//  CategoryTableViewCell.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 24/05/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

   
    @IBOutlet weak var categoryTableViewInnerView: UIView!
    @IBOutlet weak var tableViewCategoryImage: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryPriceLabel: UILabel!
    @IBOutlet weak var editCategoryTableView: UIButton!
}
