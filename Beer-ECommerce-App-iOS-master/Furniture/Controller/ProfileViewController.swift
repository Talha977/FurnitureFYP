//
//  ProfileViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 01/03/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var btnSignOut: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleFilledButton(btnSignOut)
        
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        
        tableView.register(UINib(nibName: "PostsCell", bundle: nil), forCellReuseIdentifier: "PostsCell")
       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Profile"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done,target: self, action: #selector(btnSignoutPressed(_:)))


    }
    @IBAction func btnSignoutPressed(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
//        self.navigationController?.popToViewController(LoginViewController(), animated: true)
        self.tabBarController?.navigationController?.popToRootViewController(animated: true)
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let vc = storyboard.instantiateViewController(withIdentifier: "VC") as! ViewController
//        self.navigationController = UINavigationController.init(rootViewController:vc)
    }
    
    
    @IBAction func btnSelectImage(_ sender: Any) {
    }
    

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
        
        let profileCell  = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            
           
            
            
            return profileCell
            
        }else{
            let postsCell :UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "PostsCell") as! PostsCell
            return postsCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }else {
            return view.bounds.size.height - 200
        }
    }
    
    
}
