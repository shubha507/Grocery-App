//
//  Order.swift
//  Grocery App
//
//  Created by Shubha Sachan on 02/06/21.
//

import UIKit

class Order {
    
    var id: String?
    var total: Double?
    var totalDiscount: Double?
    var payableAmount: Double?
    var updatedAt: NSDate?
    var currentStatus: String?
    var createdBy: String?
    var createdAt: NSDate?
    var allStatus: [OrderStatus]?
    var items: [Product]?
    var name: String?
    var contact: String?
    var deliveryAddress: String?
}

class OrderStatus {
    
}
