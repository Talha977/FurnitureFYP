//
//  LoginViewController.swift
//  LoginDemo
//
//  Created by Hossein Esmaeilifarrokh on 9/29/19.
//  Copyright © 2019 Hossein Esmaeilifarrokh. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpElements()
        
    }
    
    func setUpElements(){
        errorLabel.alpha = 0// hiding error label
        
        //        Utilities.styleTextField(emailTextField)
        //        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(LoginButton)
        
    }
    
    
    
    
    @IBAction func logginTapped(_ sender: Any) {
        // valided text filed
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                // couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                
                
                
                //                let nextVC = self.storyboard?.instantiateViewController(identifier: "loginController") as? FurnitureListView
                //                self.navigationController?.pushViewController(nextVC!, animated: true)
                
                self.performSegue(withIdentifier: "loginController", sender: self)
                
            }
            
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        //        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        
        
    }
    
    
}
