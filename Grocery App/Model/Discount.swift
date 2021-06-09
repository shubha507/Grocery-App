//
//  Discount.swift
//  Grocery App
//
//  Created by Shubha Sachan on 02/06/21.
//

import UIKit

class Discount {
    var createdAt : String?
    var discount : String?
    var url : String?
    var id : String?
    var rank : Int?
    var title : String?
    var offerTitle : String?
    var offerDescription : String?
    
    init(createdAt : String?, discount : String?, url : String?, id : String?, rank : Int?, title : String?,offerTitle : String?,offerDescription : String?){
        self.createdAt = createdAt
        self.discount = discount
        self.id = id
        self.rank = rank
        self.url = url
        self.title = title
        self.offerTitle = offerTitle
        self.offerDescription = offerDescription
    }
    
}

