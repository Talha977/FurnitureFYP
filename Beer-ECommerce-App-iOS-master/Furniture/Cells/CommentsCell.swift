//
//  CommentsCell.swift
//  LoginDemo
//
//  Created by Danyal on 03/03/2020.
//  Copyright © 2020 Hossein Esmaeilifarrokh. All rights reserved.
//

import UIKit
import Kingfisher

class CommentsCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblSenderName: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    userImage.layer.cornerRadius = userImage.bounds.height / 2
    userImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setComment(comment: Comment){
        
        let timestamp = comment.timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        lblTime.text = date.calenderTimeSinceNow()
        lblText.text = comment.text

        lblSenderName.text = comment.senderName
        if comment.senderPhotoUrl != nil{
            
            userImage.kf.setImage(with: comment.senderPhotoUrl)

        }else{
            self.userImage.image = UIImage(systemName: "person.fill")

        }
    }
    
}


