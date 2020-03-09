//
//  InboxBarViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 01/03/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//

import UIKit

class InboxBarViewController: UIViewController {

    var selectedInboxUnreadMsgs = 0
    var selectedId = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Inbox"
         self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName : "square.and.pencil"), style: .done, target: self, action: #selector(addPostBtn))
    }

    @IBAction func addPostBtn(_ sender: Any) {
        self.present(NewPostViewController(), animated: true, completion: nil)
    }

}
