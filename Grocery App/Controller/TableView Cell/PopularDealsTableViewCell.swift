//
//  PopularDealsTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 07/05/21.
//

import UIKit

class PopularDealsTableViewCell : UITableViewCell, UICollectionViewDelegate {
    
    var array1 = [Deals]()
    
    var dataManager = DataManager()
    
    private let cellView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 30
        return cv
    }()
    
     let popularDealsLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Popular Deals"
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
    
        
     let popularDealsCellCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let fc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        fc.register(PopularDealsCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell1")
        fc.backgroundColor = .white
        fc.showsHorizontalScrollIndicator = false
        fc.bounces = false
        fc.allowsMultipleSelection = false
        return fc
    }()
    
    //created function to pass data from tableview to collectionview
    func collectionViewData(array : [Deals]){
        self.array1 = array
        popularDealsCellCollection.reloadData()
       // print(self.array1)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        popularDealsCellCollection.delegate = self
        popularDealsCellCollection.dataSource = self
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI(){
        
        contentView.addSubview(cellView)
        cellView.setDimensions(height: 285, width: 360)
        cellView.anchor(top: topAnchor, left : leftAnchor,right: rightAnchor, paddingTop: 17, paddingLeft: 15,paddingRight: 15)
        backgroundColor = UIColor(named: "buttoncolor")
        
        cellView.addSubview(popularDealsLabel)
        popularDealsLabel.anchor(top: cellView.topAnchor, left: cellView.leftAnchor, paddingTop: 17, paddingLeft: 20)
        
        cellView.addSubview(seeAllButton)
        seeAllButton.anchor(top: cellView.topAnchor, right: cellView.rightAnchor, paddingTop: 15, paddingRight: 20)

        createLine()
        
        cellView.addSubview(popularDealsCellCollection)
        popularDealsCellCollection.anchor(top: popularDealsLabel.bottomAnchor, left: cellView.leftAnchor, right: cellView.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingRight: 0)
        popularDealsCellCollection.setDimensions(height: 220, width: cellView.frame.width)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(array1[indexPath.row].rank!)
    }

}

extension PopularDealsTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell1", for: indexPath) as! PopularDealsCollectionViewCell
        cell.cellLabel.text = "\(array1[indexPath.row].name!)"
 //       print(array1[indexPath.row].name)
       // cell.cellImage.image = UIImage(named: "\(array[indexPath.row])")
        dataManager.getImageFrom(url: "\(array1[indexPath.row].url!)", imageView: cell.cellImage, defaultImage: "placeholder")
        return cell
    }
}

extension PopularDealsTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:160, height: 190 )
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
