//
//  Notification.swift
//  FurnitureApp
//
//  Created by Danyal on 06/06/2020.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import Foundation
struct Notification : Codable{
    var notificationID : String?
    var id : String

    var name : String
    var senderName : String
    var description :String
    var timestamp : Double
    var notificationPhoto : URL?
}
