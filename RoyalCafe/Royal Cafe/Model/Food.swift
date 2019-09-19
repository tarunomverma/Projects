//
//  Food.swift
//  Royal Cafe
//
//  Created by admin on 08/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import Firebase

class Food {
    
    //variables
    private(set) var foodname: String!
    private(set) var fooddesc: String!
    private(set) var price: Double!
    private(set) var img: String!
    private(set) var foodId: String!

    init(foodname: String, fooddesc: String, price: Double, img: String, foodId:String) {        
        self.foodname = foodname
        self.fooddesc = fooddesc
        self.price = price
        self.img = img
        self.foodId = foodId
    }
    
    class func parseData(snapshot : QuerySnapshot?) -> [Food]{
        var foods = [Food]()
        
        guard let snap = snapshot else { return foods }
        for document in snap.documents {
            let data = document.data()
            
            let name = data[NAME] as? String ?? "Anonymous"
            let desc = data[DESC] as? String ?? "This is description"
            let price = data[PRICE] as? Double ?? 0
            let img = data[IMG] as? String ?? "default"
            let foodId = document.documentID
            
            let newFood = Food(foodname: name, fooddesc: desc, price: price, img: img, foodId: foodId)
            foods.append(newFood)
        }        
        return foods
    }
}
