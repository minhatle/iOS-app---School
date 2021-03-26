// Fullname : Minh Nhat Le              StudentID: 164029175
//  Order.swift
//  MinhLe_MyORDER
//
//  Created by Minh Le on 2021-02-06.
//

import Foundation

struct Order{
    var coffeeType : String
    var coffeeSize : String
    var quantity : Int
    
    init(){
        self.coffeeSize = ""
        self.coffeeType = ""
        self.quantity = 0
    }
    init(type : String, size : String, quantity_ : Int){
        self.coffeeType = type
        self.coffeeSize = size
        self.quantity = quantity_
    }
    
}
