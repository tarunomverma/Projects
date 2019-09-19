//
//  LoginVCViewController.swift
//  Royal Cafe
//
//  Created by admin on 09/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    //outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage.init(named: "home_img")
        let backgroundImageView = UIImageView.init(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImageView, at: 0)
       
        // Do any additional setup after loading the view.
    }    

    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = emailTF.text,
            let password = passwordTF.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("Error signing in: \(error)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
