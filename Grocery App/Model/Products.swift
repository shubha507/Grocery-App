//
//  Products.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 31/05/21.
//

import UIKit
struct Product{
    
    var active : Bool?
    var categoryId : String?
    var description : String?
    var price : Int?
    var name : String?
    var tags : [String]?
    var url : String?
    var id : String?
    init(active : Bool? , categoryId : String?, description : String?,price : Int?, name : String?,tags : [String]? , url : String?, id: String?){
        self.active = active
        self.categoryId = categoryId
        self.description = description
        self.price = price
        self.name = name
        self.tags = tags
        self.url = url
        self.id = id
    }
}

