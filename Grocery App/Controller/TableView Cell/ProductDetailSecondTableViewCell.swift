//
//  ProductDetailSecondTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

protocol PassDetailOrReviewSelected {
    func whichViewSelected(isDetailButtonSelected : Bool? , isReviewButtonSelected : Bool?)
}

class ProductDetailSecondTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    //Mark :- Properties

    var delegate : PassDetailOrReviewSelected?
    
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
    
    //Mark :- Lifecycle method

 override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    belowDetailsView.layer.cornerRadius = 25
    belowReviewView.layer.cornerRadius = 25
    
    curvedView.layer.cornerRadius = 30
    curvedView.layer.masksToBounds = true
    
        curvedView.addSubview(productDescriptionLabel)
    productDescriptionLabel.anchor(top: curvedView.topAnchor, left: curvedView.leftAnchor,bottom: curvedView.bottomAnchor, right: curvedView.rightAnchor, paddingTop: 25, paddingLeft: 15,paddingBottom: 25, paddingRight: 15)
    
    curvedView.addSubview(productReviewTableView)
    productReviewTableView.anchor(top: curvedView.topAnchor, left: curvedView.leftAnchor, bottom: curvedView.bottomAnchor, right: curvedView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingBottom: 25, paddingRight: 15)
    
    productReviewTableView.delegate = self
    productReviewTableView.dataSource = self
    
    productReviewTableView.separatorStyle = .none
    }
    
    
    //Mark :- Helper Function
    func configureUI(isDetailButtonSelected : Bool? , isReviewButtonSelected : Bool?) {
        if isDetailButtonSelected! {
            detailsButton.tintColor = .black
            reviewsButton.tintColor = .gray
            belowDetailsView.isHidden = false
            belowReviewView.isHidden = true
        productDescriptionLabel.isHidden = false
        productReviewTableView.isHidden = true
            print("detail button selected")
        }else if isReviewButtonSelected! {
            detailsButton.tintColor = .gray
            reviewsButton.tintColor = .black
            belowReviewView.isHidden = false
            belowDetailsView.isHidden = true
        productDescriptionLabel.isHidden = true
        productReviewTableView.isHidden = false
        productReviewTableView.reloadData()
            print("Review button selected")
        }
    }

    //Mark :- Action
 @IBAction func DetailsButtonPressed(_ sender: Any) {
    delegate?.whichViewSelected(isDetailButtonSelected: true, isReviewButtonSelected: false)
    }
    
 @IBAction func reviewButtonPressed(_ sender: Any) {
    delegate?.whichViewSelected(isDetailButtonSelected: false, isReviewButtonSelected: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Reviewcell") as? ProductReviewTableViewCell else {return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
  }
