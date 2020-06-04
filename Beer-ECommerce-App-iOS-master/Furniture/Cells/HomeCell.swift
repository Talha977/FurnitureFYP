//
//  HomeCell.swift
//  FurnitureApp
//
//  Created by Danyal on 26/02/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//

import UIKit
import Kingfisher
import DropDown
import Firebase
import FirebaseFirestore

class HomeCell: UITableViewCell {

    
    @IBOutlet weak var imgUserPic: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var imgHomePic: UIImageView!
    
    @IBOutlet weak var lblUsername2: UILabel!
    
    @IBOutlet weak var lbltext: UILabel!
    
    @IBOutlet weak var lblTimestamp: UILabel!
    
    @IBOutlet weak var btnOptions: UIButton!
    
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    var dropDownData = [String]()
    var optionSelected :((_ optionName : String) -> Void )? = nil
    
    var sharedImage :((_ image : UIImage) -> Void )? = nil
    

    var post : Posts!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        imgUserPic.layer.cornerRadius = 25
        imgUserPic.layer.masksToBounds = true
        // Configure the view for the selected state
    }
    
    func setPost(post: Posts, likedId : [String] , savedId : [String]){
        self.post = post
         let timestamp = post.timestamp
         let date = Date(timeIntervalSince1970: timestamp)

         lblTimestamp.text = date.calenderTimeSinceNow()
         lbltext.text = post.text
        
         lblUsername.text = post.username
         lblUsername2.text = post.username
         
        
        imgHomePic.kf.setImage(with: post.image)
        
        if post.profilePicUrl != nil {
            imgUserPic.kf.setImage(with: post.profilePicUrl)

        }else{
            imgUserPic.image = UIImage(systemName: "person")
        }

        
        if Auth.auth().currentUser?.uid == post.userid {
                dropDownData = ["Delete"]
            
        }else{
            dropDownData = [ "Message"]

        }
        
        if likedId.contains(post.id){
            btnLike.isSelected = true
        }else{
            btnLike.isSelected = false

        }
        
        if savedId.contains(post.id){
            btnSave.isSelected = true
        }else{
            btnSave.isSelected = false

        }

 
    }
    
    @IBAction func btnOptionsPressed(_ sender: UIButton) {
            print("pressed")
            let dropDown = DropDown()
    //
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 100, y: sender.bounds.height)
    

            // The list of items to display. Can be changed dynamically
      
        dropDown.dataSource = dropDownData
            
            // Action triggered on selection
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
              print("Selected item: \(item) at index: \(index)")
                self.optionSelected!(item)
                
            }
    //        dropDown.width = 200
            dropDown.show()

        }
    
    
    @IBAction func btnLikePress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return }

        if sender.isSelected{

            db.collection("liked").document(userID).collection("like").document(post.id).setData(["postID": post.id])
        }else{
            db.collection("liked").document(userID)
                .collection("like").document(post.id).delete()
            
        }
    }
    
    @IBAction func btnCommentPress(_ sender: Any) {
    }
    
    @IBAction func btnSharePress(_ sender: Any) {
        if imgHomePic != nil {
            sharedImage?((imgHomePic?.image)!)
        }
    }
    
    @IBAction func btnSavePress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return }

        if sender.isSelected{
            db.collection("saved").document(userID).collection("save").document(post.id).setData(["postID": post.id])
        }else{
            db.collection("saved").document(userID)
                .collection("save").document(post.id).delete()
            
        }
    }
}
