//
//  ProductDetailSecondTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailSecondTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    let productReviewTableView : UITableView = {
        let pRTV = UITableView()
        pRTV.backgroundColor = UIColor(named: "mygreen")
        pRTV.register(UINib(nibName: "ProductReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "Reviewcell")
        pRTV.showsVerticalScrollIndicator = false
        pRTV.bounces = false
        
        return pRTV
    }()
    
    let productDescriptionLabel : UILabel = {
        let pDL = UILabel()
   //     pDL.text = "Lorem ipsum dolor sitamet, consectetur adipiscing elit, in seddo eiusmod tempor incididunt utlabore etdolore magna aliqua. Utenim adminim veniam, nostrud exercitation ullamco laboris nisiut aliquip exea commodo consequat Duisaute iruredolor in reprehenderit in voluptate velitesse dolore eufugiat."
        pDL.textColor = .white
        pDL.font = UIFont.systemFont(ofSize: 21)
        pDL.numberOfLines = 0
        pDL.textAlignment = .justified
        return pDL
    }()

 @IBOutlet weak var detailsButton: UIButton!
    
 @IBOutlet weak var reviewsButton: UIButton!
    
 @IBOutlet weak var reviewsNumberLabel: UILabel!
    
 @IBOutlet weak var belowDetailsView: UIView!
    
 @IBOutlet weak var belowReviewView: UIView!
    
 @IBOutlet weak var curvedView: UIView!
    
    
 override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailsButton.tintColor = .black
    belowDetailsView.layer.cornerRadius = 25
    belowReviewView.layer.cornerRadius = 25
       belowReviewView.isHidden = true
        reviewsButton.tintColor = .gray
    
    curvedView.layer.cornerRadius = 30
    curvedView.layer.masksToBounds = true
    
        curvedView.addSubview(productDescriptionLabel)
    productDescriptionLabel.anchor(top: curvedView.topAnchor, left: curvedView.leftAnchor,bottom: curvedView.bottomAnchor, right: curvedView.rightAnchor, paddingTop: 25, paddingLeft: 15,paddingBottom: 25, paddingRight: 15)
    
    curvedView.addSubview(productReviewTableView)
    productReviewTableView.anchor(top: curvedView.topAnchor, left: curvedView.leftAnchor, bottom: curvedView.bottomAnchor, right: curvedView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingBottom: 25, paddingRight: 15)
    
    productReviewTableView.delegate = self
    productReviewTableView.dataSource = self
    
    productReviewTableView.isHidden = true
    productReviewTableView.separatorStyle = .none
    }
    
 @IBAction func DetailsButtonPressed(_ sender: Any) {
        detailsButton.tintColor = .black
        reviewsButton.tintColor = .gray
        belowDetailsView.isHidden = false
        belowReviewView.isHidden = true
    productDescriptionLabel.isHidden = false
    productReviewTableView.isHidden = true
        
    }
    
 @IBAction func reviewButtonPressed(_ sender: Any) {
        detailsButton.tintColor = .gray
        reviewsButton.tintColor = .black
        belowReviewView.isHidden = false
        belowDetailsView.isHidden = true
    productDescriptionLabel.isHidden = true
    productReviewTableView.isHidden = false
    productReviewTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reviewcell") as! ProductReviewTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
  }
