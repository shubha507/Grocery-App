//
//  ProductDetailThirdTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 12/05/21.
//

import UIKit

class ProductDetailThirdTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var ThirdCellCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ThirdCellCollectionView.delegate = self
        ThirdCellCollectionView.dataSource = self
        ThirdCellCollectionView.register(UINib(nibName: "ProductDetailThirdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailThirdCollectionViewCell")
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailThirdCollectionViewCell", for: indexPath) as? ProductDetailThirdCollectionViewCell
        return cell!
    }
    
}
