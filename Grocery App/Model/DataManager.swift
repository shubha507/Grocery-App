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
   
    
    let activityIndicator = UIActivityIndicatorView()
    
    func getImageFrom(url: String?, imageView : UIImageView){
        
        activityIndicator.color = .gray
        imageView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerX(inView: imageView)
        activityIndicator.centerY(inView: imageView)
        activityIndicator.startAnimating()
        
        if url == "No url"{
            DispatchQueue.main.async {
                imageView.image = UIImage(named: "Noimage")
            self.activityIndicator.stopAnimating()
        }
        }else{
            guard let posterImageUrl = URL(string: url!) else {return}
        
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
              
                if let data = data , let response = response , ((response as? HTTPURLResponse)?.statusCode ?? 500 ) < 300 {
                DispatchQueue.main.async {
                    if let image = UIImage(data : data) {
                        print("image \(image)")
                        imageCache.setObject(image, forKey: posterImageUrl as AnyObject )
                        imageView.image = image
                       // print(imageCache.description)
                     print(response)
                    self.activityIndicator.stopAnimating()
                }
            }
                }else {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(named: "Noimage")
                    self.activityIndicator.stopAnimating()
                }
             }
            }.resume()
        }
        }
    
    func searchData(selectedId : String?,matchId : String? , callback: @escaping(_ error : Bool)-> Void){
         let db = Firestore.firestore()
        db.collection("products").whereField(matchId!, isEqualTo: selectedId).getDocuments() { [self] (querySnapshot, err) in
               if let err = err {
                    print("Error getting documents: \(err)")
               } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        let active = data["active"] as? Bool ?? nil
                        let name = data["name"] as? String ?? ""
                        let categoryId = data["category_id"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let tags = data["tags"] as? [String] ?? []
                        let price = data["price"] as? Int ?? 0
                        let url = data["url"] as? String ?? "No url"
                        let id = data["id"] as? String ?? ""
                        let searchKey = data["search_keys"] as? [String] ?? []
                        if active == nil || active == true {
                            let newProduct = Product(active: active, categoryId: categoryId, description: description, price: price, name: name, tags: tags, url: url,searchKey: searchKey, id : id)
                        self.productArray.append(newProduct)
                        }
                    }
               }
                        if productArray.count > 0{
                            callback(false)
                        }else{
                            callback(true)
                        }
                    
               
           
       }
        
    }
 
}


