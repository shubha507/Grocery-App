//
//  Products.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 31/05/21.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Product{
    
    var active : Bool?
    var categoryId : String?
    var description : String?
    var price : Double?
    var name : String?
    var tags : [String]?
    var url : String?
    var id : String?
    var discount : Double?
    var createdAt : Timestamp?
    var updatedAt : Timestamp?
    var search_keys : [String]?
    var count: Int?
   
    init(data: [String: Any] )
    {
        
        self.active = data["active"] as? Bool ?? true
        self.name = data["name"] as? String ?? ""
        self.categoryId = data["category_id"] as? String ?? ""
        self.tags = data["tags"] as? [String] ?? []
        self.description = data["description"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.url = data["url"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.discount = data["discount"] as? Double ?? 0.0
        self.createdAt = data["createdAt"] as? Timestamp ?? nil
        self.updatedAt = data["updatedAt"] as? Timestamp ?? nil
        self.search_keys = data["search_keys"] as? [String] ?? []
        self.count = data["count"] as? Int ?? 0

        
    }
}


