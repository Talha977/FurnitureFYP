//
//  HomeViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 26/02/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseFirestore


class HomeViewController: UIViewController {
    
    @IBOutlet weak var btnNewPost: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var postsArr = [Posts]()
    var hud : JGProgressHUD  = JGProgressHUD(style: .dark)
    
    weak var inboxRef : InboxBarViewController? = nil

    
    var newMsgBtn = UIBarButtonItem()
    var profileBtn = UIBarButtonItem()
    

    var savedIds = [String]()
    var likedIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        tableView.delegate = self
        tableView.dataSource = self
        //hud.textLabel.text = "Loading"
        hud.show(in: self.view)

        
        
        getPost { (posts) in
            
//            self.postsArr.removeAll()
//            self.postsArr.append(contentsOf: posts)
            self.postsArr = posts
            self.tableView.reloadData()
        }
        
        getLikedPostIDs { likedIds in
            self.tableView.reloadData()

            self.likedIds = likedIds
        }
        getSavedPostIDs { saveIds in
            self.tableView.reloadData()

            self.savedIds = saveIds

            
        }
        

        //        try! Auth.auth().signOut()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Home"
        
        newMsgBtn = UIBarButtonItem(image: UIImage(systemName : "square.and.pencil"), style: .done, target: self, action: #selector(addPostBtn))
        profileBtn = UIBarButtonItem(image: UIImage(systemName : "person.fill"), style: .done, target: self, action: #selector(openProfile))
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [profileBtn,newMsgBtn]

//        if Auth.auth().currentUser == nil {
//            btnNewPost.isHidden = true
//        }else{
//            btnNewPost.isHidden = false
//
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItems = [profileBtn]
    }
    
    func getSavedPostIDs(completionHandler : ((_ ids : [String]) -> Void)? = nil){
        var ids = [String]()
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return }
        db.collection("saved").document(userID).collection("save").getDocuments { (snapshot, error) in
            for document in snapshot!.documents{
                let id = document.documentID
                ids.append(id)
            }
            completionHandler!(ids)
        }
    }
    
    
    func getLikedPostIDs(completionHandler : ((_ ids : [String]) -> Void)? = nil){
        var ids = [String]()
        let db = Firestore.firestore()
        
        guard let userID = Auth.auth().currentUser?.uid else {return }
        db.collection("liked").document(userID).collection("like").getDocuments { (snapshot, error) in
            for document in snapshot!.documents{
                let id = document.documentID
                ids.append(id)
            }
            completionHandler!(ids)
        }
    }
    
    
    
    @IBAction func addPostBtn(_ sender: Any) {
        //self.present(NewPostViewController(), animated: true, completion: nil)
        self.navigationController?.pushViewController(NewPostViewController(), animated: true)
    }
    @IBAction func openProfile(_ sender: Any) {
           let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier:"Profile") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
       }
    
    func getPost(completionHandler : ((_ post : [Posts]) -> Void)? = nil){
        let db = Firestore.firestore()
        
        db.collection("posts").addSnapshotListener { (snapshot, error) in
            self.hud.dismiss(animated: true)

            if snapshot == nil {
                return
            }
            for document in snapshot!.documents{
                let documentID = document.documentID as! String
                let id = document.get("id") as? String ?? ""
                
                let username = document.get("username") as? String ?? ""
                let text = document.get("text") as? String ?? ""
                let timestamp = document.get("timestamp") as? Double ?? 0
                let image = document.get("imageurl") as? String ?? ""
                let imageUrl = URL(string: image)
                let profilePicImage = document.get("profilePicUrl") as? String ?? ""
                let profilePicUrl = URL(string: profilePicImage)
                
                let post = Posts(username: username, timestamp: timestamp, id: documentID, text: text, image: imageUrl!, userid: id, profilePicUrl : profilePicUrl)
                
                self.postsArr.removeAll(where: {$0.timestamp == post.timestamp})
                self.postsArr.append(post)
                
            }
            self.postsArr.sort(by: {$0.timestamp > $1.timestamp})
            
            completionHandler!(self.postsArr)
        }
        
    }
    
    func share(image : UIImage){
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
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
        cell.setPost(post: postsArr[indexPath.section], likedId: self.likedIds , savedId: self.savedIds)
        
        cell.sharedImage = { [weak self] (image) in
            self!.share(image: image)
        }

        cell.optionSelected = { [weak self] (name) in
            if name == "Delete"{
                let db = Firestore.firestore(); db.collection("posts").document(self!.postsArr[indexPath.row].id).delete { (error) in
                    
                    self!.postsArr.remove(at: indexPath.row)
                    
                    tableView.deleteSections([indexPath.row], with: .bottom)
                    
                }
                
            }
            else if name == "Message"{
                
                let channel : Channel = Channel(id: self!.postsArr[indexPath.section].userid, name: self!.postsArr[indexPath.section].username)
                let  vc = ChatViewController(user: Auth.auth().currentUser!, channel: channel)
                self!.inboxRef?.selectedId = channel.id ?? ""
                
                vc.inboxRef = self!.inboxRef
                vc.postImage = cell.imgHomePic.image
                self?.navigationController?.pushViewController(vc, animated: true)

                
            }
            else if name == "Response"{
                
            }
        }
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        return cell
    }
    
    
    
    
}
