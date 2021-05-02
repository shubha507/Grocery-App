//
//  TableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 29/04/21.
//

import UIKit

class FirstTableViewCell : UITableViewCell, UICollectionViewDelegate {
    
    let array = ["Vegetables","Fruits","Meat","Egg"]
    
    private let cellView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 30
        return cv
    }()
    
    private let categoryLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Categories"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textColor = .black
        return lbl
    }()
    
     let seeAllButton : UIButton = {
        let button = UIButton(type : .custom)
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named : "mygreen"), .font: UIFont.systemFont(ofSize: 17)]
        let attributedTitle = NSMutableAttributedString(string: "See all", attributes: atts)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
        
     let firstCellCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let fc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        fc.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        fc.backgroundColor = .white
        return fc
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        firstCellCollection.delegate = self
        firstCellCollection.dataSource = self
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI(){
        
        contentView.addSubview(cellView)
        cellView.setDimensions(height: 235, width: 360)
        cellView.anchor(top: topAnchor, left : leftAnchor, paddingTop: 17, paddingLeft: 15)
        backgroundColor = UIColor(named: "buttoncolor")
        
        cellView.addSubview(categoryLabel)
        categoryLabel.anchor(top: cellView.topAnchor, left: cellView.leftAnchor, paddingTop: 15, paddingLeft: 20)
        
        cellView.addSubview(seeAllButton)
        seeAllButton.anchor(top: cellView.topAnchor, right: cellView.rightAnchor, paddingTop: 15, paddingRight: 20)

        createLine()
        
        cellView.addSubview(firstCellCollection)
        firstCellCollection.anchor(top: categoryLabel.bottomAnchor, left: cellView.leftAnchor, bottom: cellView.bottomAnchor, right: cellView.rightAnchor, paddingTop: 23, paddingLeft: 0, paddingBottom: 25, paddingRight: 0)
        firstCellCollection.setDimensions(height: 135, width: cellView.frame.width)
        //firstCellCollection.frame(forAlignmentRect: <#T##CGRect#>)
   }
    
    
    func createLine(){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 35, y: 70))
        path.addLine(to: CGPoint(x: 355, y: 70))

        // Create a `CAShapeLayer` that uses that `UIBezierPath`:

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.opacity = 0.2

        // Add that `CAShapeLayer` to your view's layer:

        layer.addSublayer(shapeLayer)
    }

}

extension FirstTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! FirstCollectionViewCell
        cell.cellLabel.text = "\(array[indexPath.row])"
        cell.cellImage.image = UIImage(named: "\(array[indexPath.row])")
        return cell
    }
}

extension FirstTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:110, height: 135 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}
