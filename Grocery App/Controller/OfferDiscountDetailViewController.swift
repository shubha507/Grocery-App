//
//  OfferDiscountDetailViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan  on 29/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class OfferDiscountDetailViewController: UIViewController,filterSelected {
    
    
    var titl : String?
    var discount : Double?
    var discountProductArray = [Product]()
    var filterSelected = "Highest Price"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var discountDetailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        discountDetailTableView.delegate = self
        discountDetailTableView.dataSource = self
        titleLabel.text = self.titl
        
        discountDetailTableView.register(OfferDetailTableViewHeader.self,
               forHeaderFooterViewReuseIdentifier: "offerSectionHeader")
        
        fetchProducts(filter: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        discountDetailTableView.reloadData()
    }
    
    func selectedFilterName(item: String) {
        self.filterSelected = item
        print(" item  \(filterSelected)" )
        if filterSelected == "Highest Price" {
            fetchProducts(filter : true)
           // discountDetailTableView.reloadData()
        }else{
            fetchProducts(filter : false)
          //  discountDetailTableView.reloadData()
        }
    }
    
    func fetchProducts(filter : Bool){
        let db = Firestore.firestore()
        db.collection("products").whereField("discount", isGreaterThanOrEqualTo: self.discount).order(by: "discount", descending: filter).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                discountProductArray = []
                for document in querySnapshot!.documents {
                    let product = Product(data: document.data() )
                    if product.active! == true{
                    self.discountProductArray.append(product)
                }
              }
            }
            discountDetailTableView.reloadData()
           
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension OfferDiscountDetailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(identifier: "ProductDetailViewController") as! ProductDetailViewController
        // let productDetailVC = ProductDetailViewController()
        productDetailVC.id  = discountProductArray[indexPath.row].id
        productDetailVC.product = discountProductArray[indexPath.row]
        productDetailVC.modalPresentationStyle = .fullScreen
        productDetailVC.productArray = discountProductArray
        self.present(productDetailVC, animated: true, completion: nil)
    }
}

extension OfferDiscountDetailViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                   "offerSectionHeader") as! OfferDetailTableViewHeader
        view.delegate = self
       return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discountProductArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDiscountDetailTableViewCell", for: indexPath) as? OfferDiscountDetailTableViewCell else {return UITableViewCell() }
        cell.configureCellUI(product: discountProductArray[indexPath.row])
        
     return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    
    
}

