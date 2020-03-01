//
//  ProfileViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 01/03/2020.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var btnSignOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleFilledButton(btnSignOut)
    }
    


    @IBAction func btnSignoutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        self.navigationController?.pushViewController(ViewController(), animated: true)
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let vc = storyboard.instantiateViewController(withIdentifier: "VC") as! ViewController
//        self.navigationController = UINavigationController.init(rootViewController:vc)
    }
}
