//
//  FoodCell.swift
//  Royal Cafe
//
//  Created by admin on 08/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase

class FoodCell: UITableViewCell {

    //outlets
    @IBOutlet weak var foodimg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    //variables
    private var food: Food!
    var username: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addToCartTapped(_ sender: Any) {
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        Firestore.firestore().collection(CART_REF).addDocument(data: [
            FOODNAME : nameLbl.text as Any,
            PRICE : priceLbl.text!,
            QUANTITY : 1,
            USERNAME : username
            
        ]) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            } else {
                //self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func configureCell(food: Food) {
        self.food = food
        nameLbl.text = food.foodname
        descLbl.text = food.fooddesc
        priceLbl.text = String(food.price)
        foodimg.image = UIImage(named: food.img)
    }
}
