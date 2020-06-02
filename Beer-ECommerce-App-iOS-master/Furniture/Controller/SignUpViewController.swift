//
//  SignUpViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 01/03/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpElements()
    }
    
    func setUpElements(){
        
        
        Utilities.styleFilledButton(signUpButton)
    }
    
    
    //check the fields and validate that the data is correct. if everything is correct this method return nil. otherwise return the errors
    func validateFields() -> String?{
        
        // chech that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        //check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "A minimum 8 characters password contains of special characters and numbers are required."
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                }else{
                    
                    self.saveDetailsToFirestore(name: "users", result: result!)
                    
                    let reference = Database.database().reference().child("notificationCount").child("users").child(Auth.auth().currentUser!.uid)
                    reference.setValue(0)
                    self.performSegue(withIdentifier: "SignupScreen", sender: self)
                    
                }
            }
            
        }
        
        
        
    }
    
    
    func saveDetailsToFirestore(name: String, result : AuthDataResult ){
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let db = Firestore.firestore()
        db.collection(name).document(result.user.uid ).setData(["firstname" : firstName, "lastname" : lastName, "uid": result.user.uid ]) { (error) in
            
            if error != nil {
                // Show error message
                self.showError("Error saving user data\(error)")
            }
            else {
                let user = Auth.auth().currentUser
                let changeRequest = user?.createProfileChangeRequest()
                
                
                DispatchQueue.main.async {
                    changeRequest?.displayName =  firstName + " " + lastName
                    changeRequest?.commitChanges{ error in
                        if let _ = error {
                            // An error happened.
                        } else {
                            //print(user?.displayName)
                        }
                    }
                }
                let reference = Database.database().reference().child("notificationCount").child(name).child(Auth.auth().currentUser!.uid)
                reference.setValue(0)
                
            }
            
        }
        
    }
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    
    
    
    @IBAction func btnLoginScreen(_ sender: Any) {
        //        self.navigationController?.pushViewController(LoginViewController(), animated: true)
        
    }
    
}
