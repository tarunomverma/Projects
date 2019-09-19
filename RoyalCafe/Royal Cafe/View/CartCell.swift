//
//  CartCell.swift
//  Royal Cafe
//
//  Created by admin on 08/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase

class CartCell: UITableViewCell {

    //outlets
    @IBOutlet weak var foodname: UILabel!
    @IBOutlet weak var foodprice: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var foodquan: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    
    //variables
    private var cart: Cart!
    var cartRef: DocumentReference!
    var oldQuan: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(cart: Cart) {
        self.cart = cart
        foodname.text = cart.foodname
        foodprice.text = String(cart.foodprice)
        foodquan.text = String(cart.foodquan)
    }    
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            
            let cartDocument: DocumentSnapshot            
            do {
                try cartDocument = transaction.getDocument(Firestore.firestore()
                    .collection(CART_REF).document(self.cart.cartId))
            } catch let error as NSError {
                debugPrint("Fetch error: \(error.localizedDescription)")
                return nil
            }            
            self.oldQuan = cartDocument.data()![QUANTITY] as? Int
            transaction.updateData([QUANTITY : self.oldQuan + 1], forDocument: self.cartRef)
                        
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.foodquan.text = String( self.oldQuan + 1)
            }
        }
        
    }
    @IBAction func minusBtnTapped(_ sender: Any) {
        
        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            
            let cartDocument: DocumentSnapshot            
            do {
                try cartDocument = transaction.getDocument(Firestore.firestore()
                    .collection(CART_REF).document(self.cart.cartId))
            } catch let error as NSError {
                debugPrint("Fetch error: \(error.localizedDescription)")
                return nil
            }
            
            self.oldQuan = cartDocument.data()![QUANTITY] as? Int
            
            if(self.oldQuan == 0){
                transaction.updateData([QUANTITY : self.oldQuan - 1], forDocument: self.cartRef)
            }
            else
            {
                transaction.updateData([QUANTITY : 0], forDocument: self.cartRef)
            }
            
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.foodquan.text = String(self.oldQuan + 1)
            }
        }        
    }
}
