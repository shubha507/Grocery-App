//
//  Product.swift
//  Grocery App
//
//  Created by Shubha Sachan on 02/06/21.
//

import UIKit

class Product{
    
    var active : Bool?
    var categoryId : String?
    var description : String?
    var price : Int?
    var name : String?
    var tags : [String]?
    var url : String?
    var searchKey : [String]?
    var id : String?
    
    init(active : Bool? , categoryId : String?, description : String?,price : Int?, name : String?,tags : [String]?, url : String?, searchKey : [String]?, id : String){
        self.active = active
        self.categoryId = categoryId
        self.description = description
        self.price = price
        self.name = name
        self.tags = tags
        self.url = url
        self.searchKey = searchKey
        self.id = id
    }
    
    var quantity = 0
    var isQuantityViewOpen = false
    var isAddedToCart = false
}

