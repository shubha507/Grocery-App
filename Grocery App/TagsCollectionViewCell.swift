//
//  TagsCollectionViewCell.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 12/05/21.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    
     func width(text:String?, font: UIFont, height:CGFloat) -> CGFloat {
        var currentWidth: CGFloat!
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.text = text
        label.font = font
        label.numberOfLines = 1
        label.sizeToFit()
        
        currentWidth = label.frame.width
        label.removeFromSuperview()
        return currentWidth
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.width = ceil(size.width)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
