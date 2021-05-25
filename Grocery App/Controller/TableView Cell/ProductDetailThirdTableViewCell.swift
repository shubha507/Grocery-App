//
//  ProductDetailThirdTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailThirdTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var dataManager = DataManager()
    
    var similarProductArray = [Product]()
    
    
    @IBOutlet weak var ThirdCellCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ThirdCellCollectionView.delegate = self
        ThirdCellCollectionView.dataSource = self
        ThirdCellCollectionView.register(UINib(nibName: "ProductDetailThirdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailThirdCollectionViewCell")
           
        ThirdCellCollectionView.layer.cornerRadius = 30
        ThirdCellCollectionView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
  }
    
    func getSimilarProductArray(array : [Product]){
        self.similarProductArray = array
        ThirdCellCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // print("similarProductArray.count \(similarProductArray.count)")
        return similarProductArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailThirdCollectionViewCell", for: indexPath) as? ProductDetailThirdCollectionViewCell
        cell?.configureCellUI(product: similarProductArray[indexPath.row])
//        cell?.similarProductPriceLabel.text = "$\(similarProductArray[indexPath.row].price!)"
//        cell?.similarProductPerPeicePriceLabel.text = "\(similarProductArray[indexPath.row].price!)/kg"
//        cell?.similarProductNameLabel.text = similarProductArray[indexPath.row].name!
//        dataManager.getImageFrom(url: similarProductArray[indexPath.row].url, imageView: (cell?.similarProductImageView)!)
//        cell?.quantity = similarProductArray[indexPath.row].quantity
//        print("similarProductArray[indexPath.row].quantity \(similarProductArray[indexPath.row].isQuantityViewOpen)")
//        cell?.isQuantityViewOpen = similarProductArray[indexPath.row].isQuantityViewOpen
        
        return cell!
    }
    
}
