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
import JGProgressHUD

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    var hud = JGProgressHUD(style: .dark)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpElements()
        
    }
    
    func setUpElements(){
        // hiding error label
        
        //        Utilities.styleTextField(emailTextField)
        //        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(LoginButton)
        
    }
    
    
    
    
    @IBAction func logginTapped(_ sender: Any) {
        // valided text filed
        hud.show(in: self.view)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            self.hud.dismiss(animated: true)

            if error != nil{
                self.errorLabel.isHidden = false

               self.errorLabel.text = error?.localizedDescription
            }
            else{

               // self.performSegue(withIdentifier: "loginController", sender: self)

                
                
                                let nextVC = self.storyboard?.instantiateViewController(identifier: "MainNavigation") as? UINavigationController
                self.present(nextVC!, animated: true, completion: nil)
                //navigationController?.pushViewController(nextVC!, animated: true)
                
                
                
            }
            
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        //        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        
        
    }
    
    
}
