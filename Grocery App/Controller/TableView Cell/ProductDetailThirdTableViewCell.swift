//
//  ProductDetailThirdTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailThirdTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, passQuantityChangeData {
    
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
    
    func quantityChanged(cellIndex: Int?, quant: Int?, isQuantViewOpen: Bool?) {
        similarProductArray[cellIndex!].quantity = quant!
        similarProductArray[cellIndex!].isQuantityViewOpen = isQuantViewOpen!
        if quant! > 0 && similarProductArray[cellIndex!].isAddedToCart == false{
            CartManager.shared.productAddedToCart.append(similarProductArray[cellIndex!])
            similarProductArray[cellIndex!].isAddedToCart = true
            NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
        }else if quant! == 0 && similarProductArray[cellIndex!].isAddedToCart == true {
            var index = 0
            for products in CartManager.shared.productAddedToCart {
                if products.id == similarProductArray[cellIndex!].id {
                    CartManager.shared.productAddedToCart.remove(at: index)
                    similarProductArray[cellIndex!].isAddedToCart = false
                    NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
                    return
                }else{
                    index = index + 1
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // print("similarProductArray.count \(similarProductArray.count)")
        return similarProductArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailThirdCollectionViewCell", for: indexPath) as? ProductDetailThirdCollectionViewCell
        cell?.configureCellUI(product: similarProductArray[indexPath.row])
        cell?.cellIndex = indexPath.row
        cell?.delegate = self
        return cell!
    }
    
}
