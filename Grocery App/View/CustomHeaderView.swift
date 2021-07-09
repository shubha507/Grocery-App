//
//  CustomHeaderView.swift
//  Grocery App
//
//  Created by Shubha Sachan on 10/06/21.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    let title = UILabel()

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            contentView.backgroundColor = .white
            configureContents()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        func configureContents() {
            contentView.addSubview(title)
            title.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 40)
            title.font = UIFont.boldSystemFont(ofSize: 20)
            
            
}
}
