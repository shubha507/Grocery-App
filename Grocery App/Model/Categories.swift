//
//  Categories.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/05/21.
//

import UIKit

struct Categories {
    
    var name : String?
    var rank : Int?
    var url : String?
    
    
    init(name : String?,rank : Int?, url : String?) {
        self.name = name
        self.rank = rank
        self.url = url
    }
}

struct Product{
    
    var active : Bool?
    var categoryId : String?
    var description : String?
    var price : Int?
    var name : String?
    var tags : [String]?
    var url : String?
    var searchKey : [String]?
    
    init(active : Bool? , categoryId : String?, description : String?,price : Int?, name : String?,tags : [String]?, url : String?, searchKey : [String]?){
        self.active = active
        self.categoryId = categoryId
        self.description = description
        self.price = price
        self.name = name
        self.tags = tags
        self.url = url
        self.searchKey = searchKey
    }
}

struct Discount {
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

struct Deals {
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


