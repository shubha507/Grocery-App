//
//  Deals.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/06/21.
//

import UIKit

class Deals {
    var createdAt : String?
    var discount : String?
    var url : String?
    var id : String?
    var name : String?
    var rank : Int?
    
    init(data : [String : Any]){
        self.name = data["name"] as? String ?? ""
        self.rank = data["rank"] as? Int ?? 0
        self.url = data["url"] as? String ?? "No url"
        self.id = data["id"] as? String ?? ""
        self.discount = data["discount"] as? String ?? ""
        self.createdAt = data["created_at"] as? String ?? ""
    }
    
}
