//
//  CustomFooterView.swift
//  Grocery App
//
//  Created by Shubha Sachan on 10/06/21.
//

import UIKit

class CustomFooterView: UITableViewHeaderFooterView {
    
    let totalBillAmountLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "Total Bill Amount"
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .left
        return lbl
    }()
    
     let totalDiscountLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "Total Discount"
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .left
        return lbl
    }()
    
     let payableAmountLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "Payable Amount"
        lbl.font = UIFont.boldSystemFont(ofSize: 23)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let totalBillAmountValueLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .right
        return lbl
    }()
    
     let totalDiscountValueLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .right
        lbl.textColor = UIColor(named: "mygreen")
        return lbl
    }()
    
    let payableAmountValueLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 23)
        lbl.textAlignment = .right
        return lbl
    }()
     
    let view = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        configureContents()
    }

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

    func configureContents(){
        
        contentView.addSubview(view)
        view.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 3, paddingLeft: 20, paddingRight: 20, height: 1)
        view.backgroundColor = .systemGray4
        
        contentView.addSubview(totalBillAmountLbl)
        totalBillAmountLbl.anchor(top: view.bottomAnchor, left: contentView.leftAnchor, paddingTop: 20, paddingLeft: 10)
        
        contentView.addSubview(totalDiscountLbl)
        totalDiscountLbl.anchor(top: totalBillAmountLbl.bottomAnchor, left: contentView.leftAnchor, paddingTop: 20, paddingLeft: 10)
        
        contentView.addSubview(payableAmountLbl)
        payableAmountLbl.anchor(top: totalDiscountLbl.bottomAnchor, left: contentView.leftAnchor,bottom: contentView.bottomAnchor, paddingTop: 20, paddingLeft: 10,paddingBottom: 20)
        
        contentView.addSubview(totalBillAmountValueLbl)
        totalBillAmountValueLbl.anchor(top: view.bottomAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingRight: 10)
        
        contentView.addSubview(totalDiscountValueLbl)
        totalDiscountValueLbl.anchor(top: totalBillAmountValueLbl.bottomAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingRight: 10)
        
        contentView.addSubview(payableAmountValueLbl)
        payableAmountValueLbl.anchor(top: totalDiscountValueLbl.bottomAnchor,bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 20,paddingBottom: 20, paddingRight: 10)
        
    }
    
}
