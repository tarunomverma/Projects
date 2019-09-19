//
//  CartVC.swift
//  Royal Cafe
//
//  Created by admin on 08/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase

class CartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutBtn: UIButton!
    
    //variables
    private var carts = [Cart]()
    private var cartsCollectionRef: CollectionReference!
    private var cartsListener: ListenerRegistration!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        print(username)
        cartsCollectionRef = Firestore.firestore().collection(CART_REF)
    
        // Do any additional setup after loading the view.
    }    
    
    override func viewDidAppear(_ animated: Bool) {
        print(username)
        cartsListener = cartsCollectionRef
            .whereField("username", isEqualTo: "name")
            .addSnapshotListener { (snapshot, error) in
                if let err = error {
                    debugPrint("Error fetching docs: \(err)")
                } else {
                    self.carts.removeAll()
                    self.carts = Cart.parseData(snapshot: snapshot)
                    self.tableView.reloadData()
                }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        if cartsListener != nil {
            cartsListener.remove()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartCell {
            
            cell.configureCell(cart: carts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
