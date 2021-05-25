//
//  Categories.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/05/21.
//

import UIKit

class Categories {
    
    var name : String?
    var rank : Int?
    var url : String?
    var id : String?
    
    
    init(name : String?,rank : Int?, url : String?, id : String?) {
        self.name = name
        self.rank = rank
        self.url = url
        self.id = id
    }
}

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
}

class Discount {
    var createdAt : String?
    var discount : String?
    var url : String?
    var id : String?
    var name : String?
    var rank : Int?
    
    init(createdAt : String?, discount : String?, url : String?, id : String?, name : String?, rank : Int?){
        self.createdAt = createdAt
        self.discount = discount
        self.id = id
        self.rank = rank
        self.name = name
        self.url = url
    }
    
}

class Deals {
    var createdAt : String?
    var discount : String?
    var url : String?
    var id : String?
    var name : String?
    var rank : Int?
    
    init(createdAt : String?, discount : String?, url : String?, id : String?, name : String?, rank : Int?){
        self.createdAt = createdAt
        self.discount = discount
        self.id = id
        self.rank = rank
        self.name = name
        self.url = url
    }
    
}




