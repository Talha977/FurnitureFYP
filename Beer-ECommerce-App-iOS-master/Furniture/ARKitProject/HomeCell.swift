//
//  HomeCell.swift
//  FurnitureApp
//
//  Created by Danyal on 26/02/2020.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCell: UITableViewCell {

    
    @IBOutlet weak var imgUserPic: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var imgHomePic: UIImageView!
    
    @IBOutlet weak var lblUsername2: UILabel!
    
    @IBOutlet weak var lbltext: UILabel!
    
    @IBOutlet weak var lblTimestamp: UILabel!
    
    @IBOutlet weak var btnOptions: UIButton!
    
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
//        ImageService.getImage(withURL: post.image!) { (image) in
//              self.imgHomePic.image = image
//          }
 
    }
    
    @IBAction func btnOptionsPressed(_ sender: Any) {
    }
    
    
}
