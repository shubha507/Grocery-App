//
//  Categories.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/05/21.
//

import UIKit

struct Categories {
    
    var name : String?
    var rank : Int?
    var url : String?
    
    
    init(Name : String?,Rank : Int?, Url : String?) {
        self.name = Name
        self.rank = Rank
        self.url = Url
    }
}

