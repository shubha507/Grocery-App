//
//  Product.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/06/21.
//

import UIKit

class Product{
    
    var active : Bool?
    var categoryId : String?
    var description : String?
    var price : Double?
    var name : String?
    var tags : [String]?
    var url : String?
    var searchKey : [String]?
    var id : String?
    var discount : Double?
    var count : Int?
    var totalDiscount : Double?
    var keys : [String]?
    var total : Double?
    
    
    
    init(data : [String : Any]){
        self.active = data["active"]as? Bool ?? nil
        self.name = data["name"] as? String ?? ""
        self.categoryId =  data["category_id"] as? String ?? ""
        self.description = data["description"]as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.url = data["url"] as? String ?? "No url"
        self.id = data["id"] as? String ?? ""
        self.discount = data["discount"] as? Double ?? 0.0
        if let tags = data["tags"] {
        self.tags = tags as? [String] ?? []
        }
        if let searchKey = data["search_keys"]{
        self.searchKey = searchKey as? [String] ?? []
        }
        if let keys = data["keys"]{
        self.keys = keys as? [String] ?? []
        }
        if let total = data["total"],let totalDiscount = data["totalDiscount"]{
            self.total = total as? Double ?? 0.0
            self.totalDiscount = totalDiscount as? Double ?? 0.0
        }
        self.count = data["count"] as? Int ?? 0
    }
    
    
    var quantity = 0.0
    var isQuantityViewOpen = false
    var isAddedToCart = false
}
