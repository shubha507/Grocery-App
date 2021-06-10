//
//  OrderStatus.swift
//  Grocery App
//
//  Created by Shubha Sachan on 06/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class OrderStatus {
    
    var completed : Bool?
    var createdAt : Timestamp?
    var description : String?
    var status : String?
    var updatedAt : Timestamp?
    var title : String?
    
    init(data : [String : Any]){
        self.completed = data["completed"] as? Bool ?? nil
        self.createdAt  = data["createdAt"] as? Timestamp ?? nil
        self.updatedAt = data["updatedAt"] as? Timestamp ?? nil
        self.status = data["status"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
    }
}


