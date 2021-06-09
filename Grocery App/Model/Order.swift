//
//  Order.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 06/06/21.
//
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class Order {
    
    var createdAt: Timestamp?
    var name : String?
    var deliveryAddress : String?
    var items : [Product]?
    var currentStatus : String?
    var id: String?
    var payableAmount : Float?
    var updatedAt: Timestamp?
    var allStatus: [Status]?
   // var id : String?
    
    
    init(data: [String: Any] )
    {
        self.name = data["name"] as? String ?? ""
        self.createdAt = data["createdAt"] as? Timestamp ?? nil
        self.updatedAt = data["updatedAt"] as? Timestamp ?? nil
        self.deliveryAddress = data["deliveryAddress"] as? String ?? ""
        self.currentStatus = data["currentStatus"] as? String ?? ""
       
        self.payableAmount = data["payableAmount"] as? Float ?? 0
        self.items = []
        self.allStatus = []
        self.id = data["id"] as? String ?? ""
        if let arr = data["items"] as? [[String : Any]] {
            for item in arr
            {
                let product = Product(data: item)
                self.items?.append(product)
            }
        }
        
        if let arr = data["allStatus"] as? [[String : Any]] {
            for item in arr
            {
                let status = Status(data: item)
                self.allStatus?.append(status)
            }
        }
        
    }
}


class Status {
    var completed: Bool?
    var createdAt: Timestamp?
    var description: String?
    var status: String?
    var title: String?
    var updatedAt: Timestamp?
    init(data: [String: Any] )
    {
        self.completed = data["completed"] as? Bool ?? true
        self.createdAt = data["createdAt"] as? Timestamp ?? nil
        self.updatedAt = data["updatedAt"] as? Timestamp ?? nil
        self.description = data["description"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.status = data["status"] as? String ?? ""
    }
    
    func getData() -> [String : Any]{
        let dict:[String : Any] = [
            "completed": self.completed,
            "createdAt": self.createdAt,
            "updatedAt": self.updatedAt,
            "description": self.description,
            "title": self.title,
            "status": self.status
        ]
        return dict
    }
}
