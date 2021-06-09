//
//  Products.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 31/05/21.
//

import UIKit
import FirebaseFirestoreSwift
struct Product{
    
    var active : Bool?
    var categoryId : String?
    var description : String?
    var price : Int?
    var name : String?
    var tags : [String]?
    var url : String?
    var id : String?
    var discount : Int?
    var createdAt : Date?
    var updatedAt : Date?
    var search_keys : [String]?
    init(active : Bool? , categoryId : String?, description : String?,price : Int?, name : String?,tags : [String]? , url : String?, id: String?, discount: Int?, createdAt: Date?, updatedAt: Date?, search_keys: [String]?){
        self.active = active
        self.categoryId = categoryId
        self.description = description
        self.price = price
        self.name = name
        self.tags = tags
        self.url = url
        self.id = id
        self.discount = discount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.search_keys = search_keys
    }
}

struct Product1: Codable{
    
    var active : Bool?
    var categoryId : String?
    var description : String?
    var price : Int?
    var name : String?
    var tags : [String]?
    var url : String?
    var id : String?
    @DocumentID var uid:String? = UUID().uuidString
   
    enum CodingKeys: String, CodingKey {
        case active
        case categoryId = "category_id"
        case description
        case price
        case name
        case tags
        case url
        case id
    }
}

