//
//  InboxBarViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 01/03/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//
import Firebase
import MessageKit


struct Message: MessageType {
    var sender: SenderType
        
    
    var kind: MessageKind  = .text("")
  
  let id: String?
  let content: String
  let sentDate: Date

  
  var messageId: String {
    return id ?? UUID().uuidString
  }
  
  var image: UIImage? = nil
  var downloadURL: URL? = nil
  
  init(user: User, content: String) {
    sender = Sender(id: user.uid, displayName: user.displayName ?? "ABC")
    self.content = content
    sentDate = Date()
    id = nil
  }
  
  init(user: User, image: UIImage) {
    sender = Sender(id: user.uid, displayName: user.displayName  ?? "ABC")
    self.image = image
    content = ""
    sentDate = Date()
    id = nil
    let mediaItem = ImageMediaItem(image: image)
    kind = .photo(mediaItem)
  }
  
  init?(document: QueryDocumentSnapshot) {
    let data = document.data()
    
    
    guard let senderID = data["senderID"] as? String else {
      return nil
    }
    guard let senderName = data["senderName"] as? String else {
      return nil
    }
    
    guard let timeInterval = data["created"] as? Double else {
      return nil
    }
    
    id = document.documentID
    
    self.sentDate = Date(timeIntervalSince1970: timeInterval)
    sender = Sender(id: senderID, displayName: senderName)
    
    if let content = data["content"] as? String {
      self.content = content
        self.kind = .text(self.content)
      downloadURL = nil
    } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
      downloadURL = url
        self.kind = . text("")
      content = ""
    } else {
      return nil
    }
 }
    
    private struct ImageMediaItem: MediaItem {
           
           var url: URL?
           var image: UIImage?
           var placeholderImage: UIImage
           var size: CGSize
           
           init(image: UIImage) {
               self.image = image
               self.size = CGSize(width: 240, height: 240)
               self.placeholderImage = UIImage()
           }
           
       }
  
}

extension Message: DatabaseRepresentation {
  
  var representation: [String : Any] {
    var rep: [String : Any] = [
        "created": sentDate.timeIntervalSince1970,
      "senderID": sender.senderId,
      "senderName": sender.displayName
    ]
    
    if let url = downloadURL {
      rep["url"] = url.absoluteString
    } else {
      rep["content"] = content
    }
    
    return rep
  }
  
}

extension Message: Comparable {
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
  
}


