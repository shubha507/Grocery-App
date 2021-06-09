//
//  ProductDetailViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 10/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class ProductDetailViewController : UIViewController, UITableViewDelegate,passQuantityChangeData,PassDetailOrReviewSelected {
    
    
    var id : String?
    
    var isDetailButtonSelected = true
    var isReviewButtonSelected = false
    
    var product : Product?
    
    var productArray = [Product]()
    
    let dataManager = DataManager()
    
    private var similarProductArray = [Product]()
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var tblVw: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataManager.getImageFrom(url: product?.url!, imageView: posterImageView)
        self.configureCells()
        self.getSimilarProduct()
    }
    
func getSimilarProduct(){
    for products in productArray {
        if products.id != self.id {
            similarProductArray.append(products)
        }
    }

    }
    
    
    func configureCells(){
        tblVw.register(UINib(nibName: "ProductDetailFirstTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailFirstTableViewCell")
        tblVw.register(UINib(nibName: "ProductDetailSecondTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailSecondTableViewCell")
        tblVw.register(UINib(nibName: "ProductDetailThirdTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailThirdTableViewCell")
        tblVw.register(UINib(nibName: "ProductDetailFourthTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailFourthTableViewCell")
    }
    
    func quantityChanged(cellIndex: Int?, quant: Double?, isQuantViewOpen: Bool?) {
        product?.quantity = quant!
        product?.isQuantityViewOpen = isQuantViewOpen!
        print("isQuantViewOpen \(isQuantViewOpen)")
        tblVw.reloadData()
    }
    
    func whichViewSelected(isDetailButtonSelected: Bool?, isReviewButtonSelected: Bool?) {
        print("selected \(isDetailButtonSelected) \(isReviewButtonSelected)")
        self.isDetailButtonSelected = isDetailButtonSelected!
        self.isReviewButtonSelected = isReviewButtonSelected!
        tblVw.reloadData()
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProductDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 , let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailFirstTableViewCell") as? ProductDetailFirstTableViewCell {
            cell.delegate = self
            cell.configureCellUI(product: self.product)
        return cell
        }else if indexPath.row == 1,let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailSecondTableViewCell") as? ProductDetailSecondTableViewCell{
            
            cell.delegate = self
            cell.productDescriptionLabel.text = self.product?.description!
            cell.configureUI(isDetailButtonSelected : isDetailButtonSelected , isReviewButtonSelected : isReviewButtonSelected )
            return cell
        }else if indexPath.row == 2,let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailThirdTableViewCell") as? ProductDetailThirdTableViewCell{
            cell.getSimilarProductArray(array: self.similarProductArray)
        return cell
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailFourthTableViewCell") as? ProductDetailFourthTableViewCell{
                if let product = self.product,let price = product.price {
            cell.priceLabel.text = "₹\(price * (product.quantity ))"
                }
            cell.product = product
            return cell
        }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
           return UITableView.automaticDimension
        }else if indexPath.row == 1{
            if isDetailButtonSelected && !isReviewButtonSelected{
            return UITableView.automaticDimension
            }else if !isDetailButtonSelected && isReviewButtonSelected {
            return 420
            }
            return UITableView.automaticDimension
        }else if indexPath.row == 2{
            if similarProductArray.count == 0 {
                return 0
            }else{
                return 360
            }
        }else {
            return 120
        }
    }
    
}
