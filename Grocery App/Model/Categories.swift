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
    
    
    init(data : [String : Any]){
        self.name = data["name"] as? String ?? ""
        self.rank = data["rank"] as? Int ?? 0
        self.url = data["url"] as? String ?? "No url"
        self.id = data["id"]  as? String ?? ""
    }
}


