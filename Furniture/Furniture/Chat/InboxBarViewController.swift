//
//  InboxBarViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 01/03/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class InboxBarViewController: UIViewController {

    var selectedInboxUnreadMsgs = 0
    var selectedId = String()
    var selectedlastMemberID = ""


    @IBOutlet weak var tableView: UITableView!
    
    var channels = [Channel]()
       var channelIDs = [String]()
       var recSideChannels = [Channel]()
       var senderSideChannels = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "InboxCell", bundle: nil), forCellReuseIdentifier: "InboxCell")
        tableView.tableFooterView = UIView()
        self.selectedInboxUnreadMsgs =  0
        self.selectedId = ""
        self.tableView.reloadData()
               getChannelsFromRecID{ recChannels in
                   
                   self.recSideChannels.removeAll()
                   self.senderSideChannels.removeAll(where: {recChannels.contains($0)})
                   self.recSideChannels.append(contentsOf: recChannels)
                   
                   self.channels.removeAll()
                   self.channels.append(contentsOf: self.recSideChannels)
                   self.channels.append(contentsOf: self.senderSideChannels)
                   self.channels.sort(by: {$0.timestamp > $1.timestamp})

                   self.tableView.reloadData()
                   
                   self.getChannelsFromSenderID{ sendChannels in
                       self.senderSideChannels.removeAll()
                       self.recSideChannels.removeAll(where: {sendChannels.contains($0)})
                       self.senderSideChannels.append(contentsOf: sendChannels)
                       
                       self.channels.removeAll()
                       self.channels.append(contentsOf: self.recSideChannels)
                       self.channels.append(contentsOf: self.senderSideChannels)
                       self.channels.sort(by: {$0.timestamp > $1.timestamp})

                       self.tableView.reloadData()
                   }
               }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Inbox"
         self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName : "square.and.pencil"), style: .done, target: self, action: #selector(addPostBtn))
        let db = Firestore.firestore()
        if Auth.auth().currentUser!.uid != self.selectedlastMemberID && selectedId != ""{
                   db.collection("inbox").document(selectedId).updateData(["latestMemberId":"", "unreadMessages":0]) { (error) in
                       
                   }
               }
               selectedId = ""

               
           
    }

    @IBAction func addPostBtn(_ sender: Any) {
        self.present(NewPostViewController(), animated: true, completion: nil)
    }
    
     func getChannelsFromRecID(completionHandler : ((_ channel : [Channel]) -> Void)? = nil){
           
           
           var retrieveChannels = [Channel]()
        let db = Firestore.firestore()
           db.collection("inbox").whereField("recID", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener( { (snapShot, error) in
               
               if snapShot == nil{return}

               if error == nil{
                   //self.channels.removeAll()
               }
               for document in snapShot!.documents {
                   print("sender \(document.documentID)")
                   let id = document.documentID
                   let userName = Auth.auth().currentUser?.displayName ?? "abc"
                   let recName = document.get("receiverName") as! String
                   let sendName = document.get("senderName") as! String
                   let lastMemberID = document.get("latestMemberId") as! String
                   let unreadMessages = document.get("unreadMessages") as? Int ?? 0
                   let timestamp = document.get("timestamp") as? Double ?? 0

                   if id == self.selectedId{
                       self.selectedInboxUnreadMsgs = unreadMessages
                       self.selectedlastMemberID = lastMemberID

                   }
                   
                   
                   if userName != sendName{
                       var channel = Channel(id: id, name: sendName , timestamp : timestamp)
                       if lastMemberID != Auth.auth().currentUser?.uid ?? "" && lastMemberID != ""{
                           channel.hasUnreadMessages = true
                           channel.unreadMessages = unreadMessages
                           self.selectedlastMemberID = lastMemberID
                       }
                       retrieveChannels.removeAll(where: {$0.id == channel.id})
                       retrieveChannels.append(channel)
                   }
                   else if userName != recName{
                       var channel = Channel(id: id, name: recName , timestamp : timestamp)
                       if lastMemberID != Auth.auth().currentUser?.uid ?? "" && lastMemberID != ""{
                           channel.hasUnreadMessages = true
                           channel.unreadMessages = unreadMessages
                           self.selectedlastMemberID = lastMemberID
                       }
                       retrieveChannels.removeAll(where: {$0.id == channel.id})
                       retrieveChannels.append(channel)
                   }
               }
               completionHandler!(retrieveChannels)
               
               
               //Parse and Append Channel Here
           })
       }
       
       func getChannelsFromSenderID (completionHandler : ((_ channelIDs : [Channel]) -> Void)? = nil){
           let db = Firestore.firestore()
           db.collection("inbox").whereField("senderID", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener( { (snapShot, error) in
               if snapShot == nil{return}

               if error == nil{
               }
               var retrieveChannels = [Channel]()
               //Parse and Append Channel Here
               for document in snapShot!.documents {
                   let id = document.documentID
                let userName = Auth.auth().currentUser?.displayName ?? "abc"
                   let recName = document.get("receiverName") as! String
                   let sendName = document.get("senderName") as! String
                   let unreadMessages = document.get("unreadMessages") as? Int ?? 0
                   let lastMemberID = document.get("latestMemberId") as! String
                   let timestamp = document.get("timestamp") as? Double ?? 0

                   if id == self.selectedId{
                       self.selectedInboxUnreadMsgs = unreadMessages
                       self.selectedlastMemberID = lastMemberID

                   }
                   
                   if userName != sendName{
                       var channel = Channel(id: id, name: sendName , timestamp : timestamp)
                       channel.unreadMessages = unreadMessages
                       retrieveChannels.removeAll(where: {$0.id == channel.id})
                       retrieveChannels.append(channel)
                   }
                   else if userName != recName{
                       var channel = Channel(id: id, name: recName , timestamp : timestamp)
                       channel.unreadMessages = unreadMessages
                       
                       retrieveChannels.removeAll(where: {$0.id == channel.id})
                       retrieveChannels.append(channel)
                   }
               }
               completionHandler!(retrieveChannels)
           })
       }
       

}

extension InboxBarViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxCell

        cell.lblChatName.text = channels[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        selectedId = channel.id ?? ""
        selectedInboxUnreadMsgs = channel.unreadMessages
        
        let vc = ChatViewController(user: Auth.auth().currentUser!, channel: channel,isNewChat: false)
        vc.inboxRef = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
