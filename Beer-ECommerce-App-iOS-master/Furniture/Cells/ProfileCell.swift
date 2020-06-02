//
//  ProfileCell.swift
//  FurnitureApp
//
//  Created by Danyal on 02/06/2020.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var btnAddImage: UIButton!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var lblPostsCount: UILabel!
   
    @IBOutlet weak var postView: UIView!
    
    @IBOutlet weak var saveView: UIView!
    
    @IBOutlet weak var profileStack: UIStackView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
                   
                   imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height/2
                   imgProfilePic.layer.masksToBounds = true
                   
                 
                   
                  
                   btnAddImage.layer.cornerRadius = btnAddImage.frame.height/2
                   btnAddImage.layer.masksToBounds = true
                          
                          
                   
                   
                   
                   imgPlus.layer.cornerRadius = 10
                   imgPlus.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        saveView.isHidden = false
        postView.isHidden = true

    }
    
    @IBAction func btnPostPressed(_ sender: Any) {
        saveView.isHidden = true
        postView.isHidden = false
    }
}
