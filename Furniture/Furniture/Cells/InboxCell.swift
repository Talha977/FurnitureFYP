//
//  InboxCell.swift
//  LoginDemo
//
//  Created by Danyal on 04/02/2020.
//  Copyright © 2020 Hossein Esmaeilifarrokh. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {

    @IBOutlet weak var lblMsgCount: UILabel!
    @IBOutlet weak var lblChatName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMsgCount.layer.cornerRadius = 0.5 * lblMsgCount.bounds.size.width
        lblMsgCount.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
