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
        if let product = product, let url = product.url {
        self.dataManager.getImageFrom(url: url, imageView: posterImageView)
        }
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
    
    //Mark :- delegate methods
    
    func quantityChanged(cellIndex: Int?, quant: Double?, isQuantViewOpen: Bool?) {
        guard let quant = quant, let isQuantViewOpen = isQuantViewOpen, let product = self.product else {return}
        product.quantity = quant
        product.isQuantityViewOpen = isQuantViewOpen
        if quant > 0 && product.isAddedToCart == false{
            AppSharedDataManager.shared.productAddedToCart.append(product)
            product.isAddedToCart = true
            NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
        }else if quant == 0 && product.isAddedToCart == true {
            var index = 0
            for products in AppSharedDataManager.shared.productAddedToCart {
                if products.id == product.id {
                    AppSharedDataManager.shared.productAddedToCart.remove(at: index)
                    product.isAddedToCart = false
                    NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
                    return
                }else{
                    index = index + 1
                }
            }
        }else if quant > 0 && product.isAddedToCart == true {
            for products in AppSharedDataManager.shared.productAddedToCart {
                if products.id == product.id {
                    products.quantity = quant
                }
        }
      }
    }
    
    func whichViewSelected(isDetailButtonSelected: Bool?, isReviewButtonSelected: Bool?) {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailFirstTableViewCell") as? ProductDetailFirstTableViewCell, let product = self.product {
            cell.delegate = self
            cell.configureCellUI(product: product)
            return cell
            }
        }else if indexPath.row == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailSecondTableViewCell") as? ProductDetailSecondTableViewCell {
            cell.delegate = self
            cell.productDescriptionLabel.text = self.product?.description!
            cell.configureUI(isDetailButtonSelected : isDetailButtonSelected , isReviewButtonSelected : isReviewButtonSelected )
            return cell
            }
        }else if indexPath.row == 2{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailThirdTableViewCell") as? ProductDetailThirdTableViewCell{
            cell.getSimilarProductArray(array: self.similarProductArray)
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
        }
        return 0
    }
    
}
