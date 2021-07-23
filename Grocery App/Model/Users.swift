//
//  Users.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/06/21.
//

import UIKit

class users {
    var name : String?
    var id : String?
    var address : String?
    var phone : String?
    var url : String?
    var fcmToken : String?
    var role: String?
    init(name : String?,id : String?,address : String?,phone : String?,url : String?,fcmToken : String?, role: String?){
        self.name = name
        self.phone = phone
        self.id = id
        self.fcmToken = fcmToken
        self.address = address
        self.url = url
        self.role = role
    }
    
    func getData()->[String : Any]{
        let dict:[String : Any] = [
            "name":self.name,
            "phone":self.phone,
            "address":self.address,
            "fcmToken":self.fcmToken,
            "id":self.id,
            "url":self.url,
            "role":self.role
        ]
        return dict
    }
    
    
    
}
