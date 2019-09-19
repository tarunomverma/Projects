//
//  MainVC.swift
//  Royal Cafe
//
//  Created by admin on 08/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase

enum FoodCategory {
    case burger = "Burgers n Wraps"
    case classic = "Classic Dishes"
    case veg = "Vegetarian Delights"
    case soup = "Soups n Salads"
}
class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    //variables
    private var foods = [Food]()
    private var foodsCollectionRef: CollectionReference!
    private var foodsListener: ListenerRegistration!
    private var selectedCategory = FoodCategory.burger.rawValue
    private var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        //     tableView.estimatedRowHeight = 150
        //     tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 150
        
        foodsCollectionRef = Firestore.firestore().collection(FOOD_REF)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //checking if the user is alreay logged in, else instantiate the login screen
       handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if foodsListener != nil {
            foodsListener.remove()
        }
    }
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = FoodCategory.burger.rawValue
        case 1:
            selectedCategory = FoodCategory.veg.rawValue
        case 2:
            selectedCategory = FoodCategory.classic.rawValue
        default:
            selectedCategory = FoodCategory.soup.rawValue
        }
        
        foodsListener.remove()
        setListener()
    }
    
    func setListener() {
            //retrieving food items from database with categories
            foodsListener = foodsCollectionRef
                .whereField(CATEGORY, isEqualTo: selectedCategory)
                .addSnapshotListener { (snapshot, error) in
                    if let err = error {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        self.foods.removeAll()
                        self.foods = Food.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
            }        
    }
        
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //dynamically creating the number of rows in the table by counting the rows returned from database
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as? FoodCell {
            
            cell.configureCell(food: foods[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
