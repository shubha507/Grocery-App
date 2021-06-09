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
            guard let url = url , let posterImageUrl = URL(string: url) else {return}
            
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
                            
                            imageCache.setObject(image, forKey: posterImageUrl as AnyObject )
                            imageView.image = image
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
    
    
    func searchData(selectedId : String?, matchId : String? , callback: @escaping(_ error : Bool)-> Void){
        let db = Firestore.firestore()
        db.collection("products").whereField(matchId!, isEqualTo: selectedId).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let newProduct = Product(data : document.data())
                    if newProduct.active == true {
                        
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
    
    func requestOTPAgain(number : String?){
        guard let number = number else {return}
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
           print("verifying")
           if let error = error {
             print(error.localizedDescription)
             return
           }else{
             guard let verificationID = verificationID else { return }
             UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
             }
         }
    }
    
    func getData(productArray : [Product])->[[String : Any]]{
        var array : [[String : Any]] = []
        for product in productArray {
            if let price = product.price , let discount = product.discount{
            let totalDiscount = price * (discount/100)
                let dict : [String : Any] = [
            "active" : product.active,
            "categoryId" : product.categoryId,
            "count" : product.quantity,
            "description" : product.description,
            "discount" : discount,
            "id" : product.id,
            "keys" : product.searchKey,
            "name" : product.name,
            "price" : product.price,
            "tags" : product.tags,
            "total" : price,
            "url" : product.url,
            "totalDiscount" : totalDiscount
            
            ]
            array.append(dict)
            }
            
        }
      return array
    }
    
}


