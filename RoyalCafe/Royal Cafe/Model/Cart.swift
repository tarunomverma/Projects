//
//  Cart.swift
//  Royal Cafe
//
//  Created by admin on 08/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import Firebase

class Cart{
    
    //variables
    private(set) var foodname: String!
    private(set) var foodprice: Double!
    private(set) var foodquan: Int!
    private(set) var cartId: String!    
    
    init(foodname: String, foodprice: Double, foodquan: Int, cartId: String ) {        
        self.foodname = foodname
        self.foodprice = foodprice
        self.foodquan = foodquan
        self.cartId = cartId        
    }
    
    class func parseData(snapshot : QuerySnapshot?) -> [Cart]{
        var carts = [Cart]()        
        guard let snap = snapshot else { return carts }
        for document in snap.documents {
            let data = document.data()
            
            let name = data[FOODNAME] as? String ?? "Coffee"
            let price = data[PRICE] as? Double ?? 0
            let quan = data[QUANTITY] as? Int ?? 3
            let cartId = document.documentID
            
            let newCart = Cart(foodname: name, foodprice: price, foodquan: quan, cartId: cartId)
            carts.append(newCart)
        }        
        return carts
    }
}
