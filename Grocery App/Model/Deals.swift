//
//  Deals.swift
//  Grocery App
//
//  Created by Shubha Sachan on 02/06/21.
//

import UIKit

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
