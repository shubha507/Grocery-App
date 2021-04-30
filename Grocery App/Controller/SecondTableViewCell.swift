//
//  SecondTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 29/04/21.
//

import UIKit

class SecondTableViewCell : UITableViewCell {
    
    private let cellView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 30
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI(){
        
        addSubview(cellView)
        cellView.setDimensions(height: 185, width: 360)
        cellView.anchor(top: topAnchor, left : leftAnchor, paddingTop: 17, paddingLeft: 15)
        backgroundColor = UIColor(named: "buttoncolor")
    }
}
