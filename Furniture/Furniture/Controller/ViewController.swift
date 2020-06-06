//
//  ViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 01/03/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    
    @IBOutlet weak var btnLogin: UIButton!
    
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleFilledButton(btnSignUp)
        
        Utilities.styleHollowButton(btnLogin)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
