//
//  DataManager.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

let imageCache = NSCache<AnyObject,AnyObject>()

class DataManager {
    
    var productArray = [Product]()
    var category = [Categories]()
    var sortedCategory = [Categories]()
    var dict = [Int : String]()
    var discount = [Discount]()
    var sortedDiscount = [Discount]()
    var deals = [Deals]()
    var sortedDeals = [Deals]()
    
    
    let activityIndicator = UIActivityIndicatorView()
    
    func getImageFrom(url: String?, imageView : UIImageView, defaultImage : String?){
        
        activityIndicator.color = .blue
        imageView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerX(inView: imageView)
        activityIndicator.centerY(inView: imageView)
        
        
        guard let posterUrl = url else {return}
        guard let posterImageUrl = URL(string: posterUrl) else {return}
        
        imageView.image = nil
        
        if let imageSavedCache = imageCache.object(forKey: posterImageUrl as AnyObject) as? UIImage {
            imageView.image = imageSavedCache
            activityIndicator.stopAnimating()
            return
        }
        
            URLSession.shared.dataTask(with: posterImageUrl) { (data, response, error) in
                if let error = error {
                    print("DataTask error: \(error.localizedDescription)")
                    DispatchQueue.main.async(execute: {
                                       self.activityIndicator.stopAnimating()
                                   })
                    return
                }
                guard let data = data else{
                    print("Empty data")
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data : data) {
                        print("image \(image)")
                        imageCache.setObject(image, forKey: posterImageUrl as AnyObject )
                        imageView.image = image
                       // print(imageCache.description)
                    self.activityIndicator.stopAnimating()
                }
            }
    
            }.resume()
        }
 
    
    func searchData(selectedId : String?, title : String? , controller : UIViewController? ){
        self.productArray = []
        let db = Firestore.firestore()
        db.collection("products").whereField("category_id", isEqualTo: selectedId).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let active = data["active"] as? Bool ?? false
                    let name = data["name"] as? String ?? ""
                    let categoryId = data["category_id"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let tags = data["tags"] as? [String] ?? []
                    let price = data["price"] as? Int ?? 0
                    let url = data["url"] as? String ?? ""
                    let searchKey = data["search_keys"] as? [String] ?? []
                    if active == true {
                    let newProduct = Product(active: active, categoryId: categoryId, description: description, price: price, name: name, tags: tags, url: url,searchKey: searchKey)
                    self.productArray.append(newProduct)
                    }
                }
              //  self.cellCollectionVw.reloadData()
              //  print("productArray \(self.productArray.count) ")
                    let cntroller = ProductsViewController()
                   //  controller.selectedDocumentid = dictDocumentID[dataArray[indexPath.row].rank!]!
                    cntroller.pageTitle = title
                    cntroller.productArray = self.productArray
                controller?.navigationController?.pushViewController(cntroller, animated: true)
               print("array\(self.productArray)")
            }
    }
    }
    
    func fetchCategoryData(){
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.category = []
            for document in querySnapshot!.documents {
               // print("\(document.documentID) => \(document.data()["rank"] as! Int)")
             let data = document.data()
             let name = data["name"] as? String ?? " "
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? " "
             let newCategory = Categories(name: name, rank: rank, url: url)
             self.category.append(newCategory)
            self.dict.updateValue(document.documentID, forKey: rank)
            }
            print("category \(self.category)")
            //sorting category cells according to rank
            self.sortedCategory = self.category.sorted(by: { $0.rank! < $1.rank! })
           // print(self.dict)
        }
    }
}
    
    func fetchDiscountData(){
        let db = Firestore.firestore()
        db.collection("discounts").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.discount = []
            for document in querySnapshot!.documents {
               print("\(document.documentID) => \(document.data()["rank"] as! Int)")
             let data = document.data()
             let name = data["name"] as? String ?? " "
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? " "
             let id = data["id"] as? String ?? " "
             let discount = data["discount"] as? String ?? " "
             let createdAt = data["created_at"] as? String ?? " "
             let newDiscount = Discount(createdAt: createdAt, discount: discount, url: url, id: id, name: name, rank: rank )
             self.discount.append(newDiscount)
            // self.dict.updateValue(document.documentID, forKey: rank)
            }
            //sorting category cells according to rank
            self.sortedDiscount = self.discount.sorted(by: { $0.rank! < $1.rank! })
           // print("arr \(self.sortedDiscount.count)")
        }
    }
}
    
    func fetchDealsData(){
        let db = Firestore.firestore()
        db.collection("deals").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.deals = []
            for document in querySnapshot!.documents {
               print("\(document.documentID) => \(document.data()["rank"] as! Int)")
             let data = document.data()
             let name = data["name"] as? String ?? " "
             let rank = data["rank"] as? Int ?? 0
             let url = data["url"] as? String ?? " "
             let id = data["id"] as? String ?? " "
             let discount = data["discount"] as? String ?? " "
             let createdAt = data["created_at"] as? String ?? " "
             let newDeals = Deals(createdAt: createdAt, discount: discount, url: url, id: id, name: name, rank: rank )
             self.deals.append(newDeals)
            // self.dict.updateValue(document.documentID, forKey: rank)
            }
            //sorting category cells according to rank
            self.sortedDeals = self.deals.sorted(by: { $0.rank! < $1.rank! })
            print("arrdeal \(self.sortedDeals)")
        }
    }
}
}


