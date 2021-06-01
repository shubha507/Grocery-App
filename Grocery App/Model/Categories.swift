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
    var id : String?
    
    init(name : String?,rank : Int?, url : String?, id: String?) {
        self.name = name
        self.rank = rank
        self.url = url
        self.id = id
    }
}

/*struct Product{
    
    var active : Bool?
    var categoryId : String?
    var description : String?
    var price : Int?
    var name : String?
    var tags : [String]?
    var url : String?
    init(active : Bool? , categoryId : String?, description : String?,price : Int?, name : String?,tags : [String]? , url : String?){
        self.active = active
        self.categoryId = categoryId
        self.description = description
        self.price = price
        self.name = name
        self.tags = tags
        self.url = url
    }
}*/

