//
//  OrderDataManager.swift
//  Grocery App
//
//  Created by Shubha Sachan on 08/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class OrderDataManager {
    
    var order = [Order]()
    
    func fetchOrdersData(callback: @escaping(_ error : Bool)-> Void){
        let db = Firestore.firestore()
        db.collection("orders").whereField("createdBy", isEqualTo: Auth.auth().currentUser?.uid).order(by: "createdAt", descending: true).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                order = []
                for document in querySnapshot!.documents {
                    let orders = Order(data: document.data() )
                    print("orders.id \(orders.id)")
                    self.order.append(orders)
                    
                }
                //sorting category cells according to rank
                
            }
            if order.count > 0 {
                callback(false)
            }else{
                callback(true)
            }
        }
    }
    
    func fetchOrdersDataAccordingStatus(status : String , callback: @escaping(_ error : Bool)-> Void){
        let db = Firestore.firestore()
        db.collection("orders").whereField("createdBy", isEqualTo: Auth.auth().currentUser?.uid).whereField("currentStatus", isEqualTo: status).order(by: "createdAt", descending: true).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                order = []
                for document in querySnapshot!.documents {
                    let orders = Order(data: document.data() )
                    print("orders.id \(orders.id)")
                    self.order.append(orders)
                }
                //sorting category cells according to rank
                
            }
            if order.count > 0 {
                callback(false)
            }else{
                callback(true)
            }
        }
    }
   
    func getData(id : String)->[[String : Any]]{
        let placedStatusDict : [String : Any] = ["completed":true,"createdAt":Timestamp(date: Date()),"updatedAt":Timestamp(date: Date()),"title":"Order Placed","status":"placed","description":"Your order #\(id) was placed for delivery."
        ]
        
        let confirmedStatusDict : [String : Any] = ["completed":false,"createdAt":Timestamp(date: Date()),"updatedAt":Timestamp(date: Date()),"title":"Confirmed","status":"confirmed","description":"Your order is confirmed. Will deliver soon."
        ]
        let processingStatusDict : [String : Any] =
            ["completed":false,"createdAt":Timestamp(date: Date()),"updatedAt":Timestamp(date: Date()),"title":"Processing","status":"processing","description":"Your product is processing to deliver you on time."
            ]
        let deliveredStatusDict : [String : Any] =
        ["completed":false,"createdAt":Timestamp(date: Date()),"updatedAt":Timestamp(date: Date()),"title":"Delivered","status":"delivered","description":"Product delivered to you and marked as delivered by customer."
        ]
        let array = [placedStatusDict,confirmedStatusDict,processingStatusDict,deliveredStatusDict]
        return array
    }
    
    func changeTimeFormat(date : Timestamp, format : String)->String{
        let date = date.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let formatedTimeString = formatter.string(from: date)
        return formatedTimeString
    }
}
