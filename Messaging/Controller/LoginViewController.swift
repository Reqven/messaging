//
//  ViewController.swift
//  Messaging
//
//  Created by Manu on 27/04/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        self.view.endEditing(true)
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] user, error in
                //guard let strongSelf = self else { return }
                // ...
                if user != nil {
                    print("Successfully logged in !")
                    self!.performSegue(withIdentifier: "fromLogingToMessaging", sender: self!)
                } else {
                    self?.loginButton.shake()
                }
                SVProgressHUD.dismiss()
        }
    }
}

