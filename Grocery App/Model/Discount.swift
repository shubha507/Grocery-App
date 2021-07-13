//
//  Discount.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/06/21.
//

import UIKit

class Discount {
    var createdAt : String?
    var discount : Double?
    var url : String?
    var id : String?
    var rank : Int?
    var title : String?
    var offerTitle : String?
    var offerDescription : String?
    
    init(data : [String : Any]){
        self.rank = data["rank"] as? Int ?? 0
        self.url = data["url"] as? String ?? "No url"
        self.id = data["id"] as? String ?? ""
        self.discount = data["discount"] as? Double ?? 0.0
        self.createdAt = data["created_at"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.offerTitle = data["offerTitle"] as? String ?? ""
        self.offerDescription = data["offerDescription"] as? String ?? ""
    }
    
    
}
