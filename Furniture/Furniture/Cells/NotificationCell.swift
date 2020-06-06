//
//  NotificationCell.swift
//  UdormStudent
//
//  Created by Danyal on 17/02/2020.
//  Copyright © 2020 Hossein Esmaeilifarrokh. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lblNotificationName: UILabel!
    
    @IBOutlet weak var lblSenderName: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var notificiationImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        notificiationImage.layer.cornerRadius = notificiationImage.frame.height/2
        notificiationImage.layer.masksToBounds = true
        // Configure the view for the selected state
    }
    
    func setItems(notificationName:String , senderName:String , description:String , photoUrl : URL?)
    {
        
        if photoUrl == nil  {
            notificiationImage.image = UIImage(systemName: "person.circle")
        }else{
            notificiationImage.kf.setImage(with: photoUrl)

        }
        if notificationName == "Emergency"{
            lblNotificationName.textColor = .red
        }
        lblNotificationName.text = "\(notificationName):"
        lblSenderName.text = "from \(senderName)"
        lblDescription.text = description
    }
    
}
