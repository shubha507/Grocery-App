//
//  Order.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage


class Order {
    
    var id : String?
    var total : Double?
    var totalDiscount : Double?
    var payableAmount : Double?
    var updatedAt : Timestamp?
    var currentStatus : String?
    var createdBy : String?
    var createdAt : Timestamp?
    var allStatus : [OrderStatus]?
    var items : [Product]?
    var name : String?
    var contact : String?
    var deliveryAddress : String?
    
    init(id : String?){
        
    }
    
    init(data : [String : Any]){
        self.id = data["id"] as? String ?? ""
        self.total = data["total"] as? Double ?? 0.0
        self.totalDiscount = data["totalDiscount"] as? Double ?? 0.0
        self.payableAmount = data["payableAmount"] as? Double ?? 0.0
        self.updatedAt = data["updatedAt"] as? Timestamp ?? nil
        self.currentStatus = data["currentStatus"] as? String ?? ""
        self.createdBy = data["createdBy"] as? String ?? ""
        self.createdAt = data["createdAt"] as? Timestamp ?? nil
        self.items = []
        if let arr = data["items"] as? [[String:Any]]{
            for item in arr{
               let orderdProduct = Product(data : item)
                items?.append(orderdProduct)
            }
        }
        self.name = data["name"] as? String ?? ""
        self.contact = data["contact"] as? String ?? ""
        self.deliveryAddress = data["deliveryAddress"] as? String ?? ""
        self.allStatus = []
        if let arr = data["allStatus"] as? [[String:Any]]{
            for item in arr{
               let status = OrderStatus(data : item)
                allStatus?.append(status)
            }
        }
    }
}
