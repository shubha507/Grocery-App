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
        contentView.backgroundColor = UIColor(named: "buttoncolor")
        configureContents()
    }

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

    func configureContents(){
        
        contentView.addSubview(view)
        view.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom : contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 20, paddingRight: 0)
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        
        view.addSubview(totalBillAmountLbl)
        totalBillAmountLbl.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 10)
        
        view.addSubview(totalDiscountLbl)
        totalDiscountLbl.anchor(top: totalBillAmountLbl.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        view.addSubview(payableAmountLbl)
        payableAmountLbl.anchor(top: totalDiscountLbl.bottomAnchor, left: view.leftAnchor,bottom: view.bottomAnchor, paddingTop: 10, paddingLeft: 10,paddingBottom: 10)
        
        view.addSubview(totalBillAmountValueLbl)
        totalBillAmountValueLbl.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 10)
        
        view.addSubview(totalDiscountValueLbl)
        totalDiscountValueLbl.anchor(top: totalBillAmountValueLbl.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 10)
        
        view.addSubview(payableAmountValueLbl)
        payableAmountValueLbl.anchor(top: totalDiscountValueLbl.bottomAnchor,bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10,paddingBottom: 10, paddingRight: 10)
        
    }
    
}
