//
//  OfferDetailTableViewHeader.swift
//  Grocery App
//
//  Created by Shubha Sachan  on 30/06/21.
//

import UIKit
import DropDown

class OfferDetailTableViewHeader: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    let sectionTitle = UILabel()
    let filterTextField = UITextField()
    let dropdownButton = UIButton()
    let dropdownAnchorView = UIView()
    
    let dropDown = DropDown()
    var delegate : filterSelected?
     
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        dropDown.anchorView = dropdownAnchorView
        dropDown.dataSource = [ "Lowest Price", "Highest Price"]
        configureContents()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            filterTextField.text = item
            delegate?.selectedFilterName(item: item)
        }
    }

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

    func configureContents(){
    contentView.addSubview(sectionTitle)
        sectionTitle.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,bottom: contentView.bottomAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20)
        sectionTitle.font = UIFont.boldSystemFont(ofSize: 20)
        sectionTitle.text = "Filter By"
        sectionTitle.textColor = .systemGray4
        
        contentView.addSubview(filterTextField)
        filterTextField.anchor(top: contentView.topAnchor, left: sectionTitle.rightAnchor,bottom: contentView.bottomAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 20,width : 110)
        filterTextField.text = "Lowest Price"
        filterTextField.isUserInteractionEnabled = false
        
        contentView.addSubview(dropdownButton)
        dropdownButton.anchor(top: contentView.topAnchor, left: filterTextField.rightAnchor, paddingTop: 30, paddingLeft: 0,width: 20, height: 20)
        dropdownButton.setImage(UIImage(systemName: "chevron.down.square.fill" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .large)), for: .normal)
        dropdownButton.tintColor = UIColor(named: "mygreen")
        dropdownButton.addTarget(self, action: #selector(showDropdown), for: .touchUpInside)
        
        contentView.addSubview(dropdownAnchorView)
        dropdownAnchorView.anchor(top: filterTextField.bottomAnchor, left: contentView.leftAnchor, paddingTop: 0, paddingLeft: 100, width: 110)
    }
    
    @objc func showDropdown(){
        filterTextField.text = ""
        dropDown.show()
    }
}
