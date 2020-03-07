//
//  HomeCell.swift
//  FurnitureApp
//
//  Created by Danyal on 26/02/2020.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit
import Kingfisher
import DropDown
import Firebase

class HomeCell: UITableViewCell {

    
    @IBOutlet weak var imgUserPic: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var imgHomePic: UIImageView!
    
    @IBOutlet weak var lblUsername2: UILabel!
    
    @IBOutlet weak var lbltext: UILabel!
    
    @IBOutlet weak var lblTimestamp: UILabel!
    
    @IBOutlet weak var btnOptions: UIButton!
    
    var dropDownData = [String]()
    var optionSelected :((_ optionName : String) -> Void )? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func setPost(post: Posts){
         let timestamp = post.timestamp
         let date = Date(timeIntervalSince1970: timestamp)

        lblTimestamp.text = date.calenderTimeSinceNow()
         lbltext.text = post.text
        
         lblUsername.text = post.username
         lblUsername2.text = post.username
         
        
        imgHomePic.kf.setImage(with: post.image)
        
        if Auth.auth().currentUser?.uid == post.userid {
                dropDownData = ["Delete"]
            
        }else{
            dropDownData = [ "Message"]

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
    
    
    
}
