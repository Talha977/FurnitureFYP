//
//  HomeViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 26/02/2020.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var btnNewPost: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var postsArr = [Posts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        getPost { (posts) in
            
            self.postsArr.removeAll()
            self.postsArr.append(contentsOf: posts)
            self.tableView.reloadData()
        }
        
        self.navigationItem.title = "Home"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName : "square.and.pencil"), style: .done, target: self, action: #selector(addPostBtn))
        //        try! Auth.auth().signOut()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            btnNewPost.isHidden = true
        }else{
            btnNewPost.isHidden = false
            
        }
    }
    
    @IBAction func addPostBtn(_ sender: Any) {
        self.present(NewPostViewController(), animated: true, completion: nil)
    }
    
    func getPost(completionHandler : ((_ post : [Posts]) -> Void)? = nil){
        let db = Firestore.firestore()
        
        db.collection("posts").addSnapshotListener { (snapshot, error) in
            for document in snapshot!.documents{
                let documentID = document.documentID as! String
                let id = document.get("id") as? String ?? ""
                
                let username = document.get("username") as? String ?? ""
                let text = document.get("text") as? String ?? ""
                let timestamp = document.get("timestamp") as? Double ?? 0
                let image = document.get("imageurl") as? String ?? ""
                let imageUrl = URL(string: image)
                
                let post = Posts(username: username, timestamp: timestamp, id: documentID, text: text, image: imageUrl!, userid: id)
                
                self.postsArr.removeAll(where: {$0.timestamp == post.timestamp})
                self.postsArr.append(post)
                
            }
            self.postsArr.sort(by: {$0.timestamp > $1.timestamp})
            
            completionHandler!(self.postsArr)
        }
        
    }
    
    
}
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return postsArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.setPost(post: postsArr[indexPath.row])
        
        cell.optionSelected = { [weak self] (name) in
            if name == "Delete"{
                let db = Firestore.firestore(); db.collection("posts").document(self!.postsArr[indexPath.row].id).delete { (error) in
                    
                    self!.postsArr.remove(at: indexPath.row)
                    
                    tableView.deleteSections([indexPath.row], with: .bottom)
                    
                }
                
            }
            else if name == "Message"{
                
            }
            else if name == "Response"{
                
            }
        }
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        return cell
    }
    
    
    
    
}
