//
//  NotificationViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 06/06/2020.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class NotificationViewController: UIViewController {
    
    
    var notificationArray = [Notification] ()
    
    @IBOutlet weak var tableView: UITableView!
    var notReference : DatabaseReference! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        
        //notReference = Database.database().reference().child("notificationCount").child(Constants.managerNodeName).child(Auth.auth().currentUser!.uid)
        
        getAllNotifications(queryText: "All") { (notification) in
            let timeS = notification.map({$0.timestamp})
            self.notificationArray.removeAll(where: {timeS.contains($0.timestamp)})
            self.notificationArray.append(contentsOf: notification)
            self.notificationArray.sort(by: {$0.timestamp > $1.timestamp})
            
            self.tableView.reloadData()
            self.getAllNotifications(queryText: "All Managers") { (notification2) in
                let time2 = notification2.map({$0.timestamp})
                self.notificationArray.removeAll(where: {time2.contains($0.timestamp)})
                self.notificationArray.append(contentsOf: notification2)
                self.notificationArray.sort(by: {$0.timestamp > $1.timestamp})
                
                self.tableView.reloadData()
                
                guard let userId = Auth.auth().currentUser?.uid else {return}
                
                
                self.getAllNotifications(queryText: userId) { (notification3) in
                    let time3 = notification3.map({$0.timestamp})
                    self.notificationArray.removeAll(where: {time3.contains($0.timestamp)})
                    self.notificationArray.append(contentsOf: notification3)
                    self.notificationArray.sort(by: {$0.timestamp > $1.timestamp})
                    
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Notifications"
        self.tabBarController?.navigationItem.title = "Notifications"

    }
    
    func getAllNotifications(queryText : String,completionHandler : ((_ notification : [Notification]) -> Void)? = nil){
        
        var notifications = [Notification]()
        let db = Firestore.firestore()
        db.collection("notification").whereField("sentTo", arrayContains: queryText ).addSnapshotListener( { (snapShot, error) in
            //            if error == nil{
            //            }
            //                    var allNotifications = [Notification]()
            //Parse and Append Channel Here
            if snapShot == nil{return}
            
            for document in snapShot!.documents {
                let notiID = document.get("id") as? String
                let id = document.documentID
                let senderName = document.get("senderName") as! String
                let notificationName = document.get("notificationName") as! String
                let description = document.get("description") as! String
                let timestamp = document.get("timestamp") as? Double ?? 0
                
                let senderID = document.get("senderID") as? String
                
                if Auth.auth().currentUser?.uid == senderID {
                    continue
                }
                
                if notiID != nil{
                    let notification = Notification(notificationID: notiID! ,id : id, name: notificationName, senderName: senderName, description: description, timestamp: timestamp)
                    
                    //                    self.notificationArray.removeAll(where: {$0.notificationID == notification.notificationID})
                    //                    self.notificationArray.append(notification)
                    notifications.removeAll(where: {$0.timestamp == notification.timestamp})
                    notifications.append(notification)
                    
                }
                else{
                    let notification = Notification( id : id, name: notificationName, senderName: senderName, description: description, timestamp: timestamp)
                    
                    //                        self.notificationArray.removeAll(where: {$0.notificationID == notification.notificationID})
                    //                        self.notificationArray.append(notification)
                    notifications.removeAll(where: {$0.timestamp == notification.timestamp})
                    notifications.append(notification)
                    
                    
                }
                
                
//                self.notReference.observeSingleEvent(of: .value ){ (snapshot) in
//                    var value = snapshot.value as? Int ?? 0
//
//                    value += 1
//
//                    self.notReference.setValue(value)
//                }
                
            }
            
            completionHandler!(notifications)
        })
        
    }
    
    
    func resetNotificationCount(){
        notReference.setValue(0)
    }
}

extension NotificationViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let notification = notificationArray[indexPath.row]
        cell.setItems(notificationName: notification.name, senderName: notification.senderName, description: notification.description, photoUrl: notification.notificationPhoto)
        
        return cell
    }
    
}
