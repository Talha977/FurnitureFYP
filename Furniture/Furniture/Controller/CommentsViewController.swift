//
//  CommentsViewController.swift
//  LoginDemo
//
//  Created by Danyal on 03/03/2020.
//  Copyright © 2020 Hossein Esmaeilifarrokh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import JGProgressHUD

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tfComment: UITextField!
    
    
    @IBOutlet weak var btnPost: UIButton!
    
    var commentsArr = [Comment]()
    var newArray = [Comment]()
    let postID : String
    let senderID : String

    
    
    var fetchingMore = false
      var endReached = false
      
      var lastTimestamp : Double?
      var firstTimestamp : Double?
    var leadingScreensForBatching:CGFloat = 1.0

    var isDelete : Bool = false
    var reference: CollectionReference?
    init(postID: String,senderID : String) {
        self.postID = postID
        self.senderID = senderID

        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let db = Firestore.firestore()

    let hud = JGProgressHUD(style: .dark)
    
    var commentDismiss :(( _ dismiss : Bool)->Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getComments(postID:  postID ) { (comments) in
            self.commentsArr.removeAll()
            self.commentsArr = comments

            self.commentsArr.sort(by: {$0.timestamp > $1.timestamp})
            self.lastTimestamp = self.commentsArr.last?.timestamp
            self.firstTimestamp = self.commentsArr.first?.timestamp
            self.fetchingMore = false

            self.tableView.reloadData()
            
        }
    }
    
        override func viewWillAppear(_ animated: Bool) {
    //        self.navigationController?.setNavigationBarHidden(false, animated: false)
    //        IQKeyboardManager.shared.enable = false
            
//            let settings = FirestoreSettings()
//            settings.isPersistenceEnabled = false
//
//            db.settings = settings
            
            self.navigationItem.title = "Comments"
            self.navigationItem.rightBarButtonItem = nil



        }
    override func viewDidDisappear(_ animated: Bool) {
        commentDismiss?(true)

//        db.settings = settings
    }
    //

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        
        let contentHeight = scrollView.contentSize.height
        
        
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
            
            self.lastTimestamp = self.commentsArr.last?.timestamp
            self.firstTimestamp = self.commentsArr.first?.timestamp
            
            if !fetchingMore {
                getComments(postID:  postID ) { (comments) in
                    //                let timestamp = post.map({$0.timestamp})
                    //                self.postArr.removeAll(where: {timestamp.contains($0.timestamp)})
                    //
                    //                self.postArr.append(contentsOf: post)
                    self.commentsArr = comments
                    self.tableView.reloadData()
                    self.fetchingMore = false
                }
                
            }
            
        }
    }

    
    func getComments(postID: String,completionHandler : ((_ comment : [Comment]) -> Void)? = nil){
        var query : Query
        fetchingMore = true
     
        var tempComments : [Comment] = self.commentsArr
        //var tempComments = [Comment] ()

        query =  db.collection("comments").document(postID).collection("comment").order(by: "timestamp",descending: true)
            
    
    
    query.addSnapshotListener { (snapshot, error) in
        
        if snapshot == nil{return}

                for document in snapshot!.documents{
                    if self.isDelete{
                        tempComments.removeAll()
                        self.isDelete = false
                    }
                    let id = document.documentID
                    let text = document.get("commentText") as? String
                    let senderID = document.get("senderID") as? String
                    let timestamp = document.get("timestamp") as? Double
                    let imgString = document.get("senderProfileUrl") as? String ?? ""
                    let senderName = document.get("senderName") as? String ?? ""

                    
                     tempComments.removeAll(where: {$0.timestamp == timestamp})
                    if imgString == ""{
                        let comment = Comment(id : id ,text: text!, timestamp: timestamp!, senderID : senderID!, senderName: senderName)
                        tempComments.append(comment)

                    }else{
                        let imgUrl = URL(string: imgString)

                        let comment = Comment(id : id ,text: text!, timestamp: timestamp!, senderID : senderID! , senderPhotoUrl: imgUrl, senderName: senderName)
                       
                        tempComments.append(comment)
                        
                    }

                    }
                        completionHandler!(tempComments)

                    
                }
                
                
         

        
    }
    
    
    @IBAction func btnPostPressed(_ sender: Any) {
       
        let currentUser = Auth.auth().currentUser
        let uid = currentUser?.uid
        let profileUrl = currentUser?.photoURL
        let username = currentUser?.displayName

        
        let timestamp = NSDate().timeIntervalSince1970
        let text = tfComment.text
        
        var data = [String:Any]()
        data = ["commentText" : text, "timestamp" : timestamp , "senderID" : uid, "senderProfileUrl" : profileUrl?.absoluteString, "senderName" : username]
        
        let db = Firestore.firestore()
        db.collection("comments").document(postID).collection("comment").addDocument(data: data) { (error) in
            if error == nil {
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 1,animated: true)
                
            }else{
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.textLabel.text = error?.localizedDescription
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 3,animated: true)
            }
        }
        
            

           
                let notification = [ "senderName" : username ,
                        "notificationName" : "Comment" ,
                        "sentTo" : [self.senderID] ,
                        "description" : "New Comment" ,
                        "timestamp" : timestamp,
                        "photoUrl": profileUrl?.absoluteString] as [String : Any]
                    
                self.db.collection("notification").addDocument(data: notification){ (error) in
                        
                    }

            
                
            

        
    }
    
    

    


}

extension CommentsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
        
        cell.setComment(comment: commentsArr[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let commentId = commentsArr[indexPath.row].id
            //db.collection("comments").document(postID).delete()//.collection("comment").document(commentId).delete() //{ error in
//                if error == nil {
//                    print("Delete SuccesFully")
//
//                }else {
//                    print("Not Deleted ")
//
//                }
//            }
//
            reference = db.collection(["comments", postID, "comment"].joined(separator: "/"))
            reference?.document(commentId).delete(){ err in

                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!\(commentId)")
                    self.commentsArr.removeAll(where: {$0.id == commentId})
                    self.lastTimestamp = self.commentsArr.last?.timestamp
                    self.firstTimestamp = self.commentsArr.first?.timestamp

                }

            }

            self.isDelete = true
            self.commentsArr.removeAll(where: {$0.id == commentId})
            self.lastTimestamp = self.commentsArr.last?.timestamp
            self.firstTimestamp = self.commentsArr.first?.timestamp

            tableView.deleteRows(at: [indexPath], with: .right)

            

            
        }
    }
    
    
}
