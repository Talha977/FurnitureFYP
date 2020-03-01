//
//  ChatViewController.swift
//  LoginDemo
//
//  Created by Danyal on 05/02/2020.
//  Copyright © 2020 Hossein Esmaeilifarrokh. All rights reserved.
//



import UIKit
import Photos
import Firebase
import MessageKit
import FirebaseFirestore
import FirebaseStorage
import InputBarAccessoryView
import IQKeyboardManagerSwift
//import Toast_Swift

class ChatViewController: MessagesViewController {
    private var messages: [Message] = []
    var channel: Channel
    private var isNewChat : Bool = true
    private var isNewMsg : Bool = false

    private var messageId : String?
    private var newMessages = [String]()

    private var selectedIndex = [Int]()
    private var selectedMsgIDs = [String]()
    private var unreadMessages : Int = 0
    private var messageListener: ListenerRegistration?
    
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private var participantReference : CollectionReference?
    var user = Auth.auth().currentUser
    weak var inboxRef : InboxBarViewController? = nil
    var id = ""
    deinit {
        messageListener?.remove()
    }
    
    init(user: User, channel: Channel, isNewChat : Bool = true) {
        self.user = user
        self.channel = channel
        self.isNewChat = isNewChat
        super.init(nibName: nil, bundle: nil)
        
    }
    private var isSendingPhoto = false {
        didSet {
            DispatchQueue.main.async {
                self.messageInputBar.leftStackViewItems.forEach { item in
                    //            item.isEnabled = !self.isSendingPhoto
                }
            }
        }
    }
    
    private let storage = Storage.storage().reference()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(action(sender:)))
        guard let receiverId = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        title = channel.name
        
        let senderId = Auth.auth().currentUser!.uid
        //
        if isNewChat{
            id = senderId > receiverId ? "\(senderId)\(receiverId)" : "\(receiverId)\(senderId)"
        }
        else{
            id  = channel.id!
        }
        //
        //
        inboxRef?.selectedId = id
        
        reference = db.collection(["inbox", id, "thread"].joined(separator: "/"))
        participantReference = db.collection(["inbox"].joined(separator: "/"))
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                print(change)
                self.handleDocumentChange(change)
            }
        }
        
        if channel.hasUnreadMessages{
            self.db.collection("inbox").document(self.id).updateData(["latestMemberId":"", "unreadMessages":0])
            
        }
        
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarSize(.zero)
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
        
        // Do any additional setup after loading the view.
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        
        //        configureMessageInputBar()
        
        // 1
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .blue
        cameraItem.image = UIImage(systemName: "camera")
        
        // 2
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        // 3
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        
    }
    
    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        if selectedIndex.isEmpty{
//        self.view.makeToast("No Message Selected\nTap messages to select", duration: 3.0, position: .top)

            
        }
        for id in selectedMsgIDs{
            if newMessages.contains(id){
                inboxRef!.selectedInboxUnreadMsgs = inboxRef!.selectedInboxUnreadMsgs - 1
                newMessages.removeAll { $0 == id }

            }
            reference?.document(id).delete(){ err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!\(id)")

            }

        }

        
        }
        selectedIndex.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        IQKeyboardManager.shared.enable = true
//        if inboxRef!.selectedInboxUnreadMsgs <= 0 {
//            newMessages.removeAll()
//        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        IQKeyboardManager.shared.enable = false
    }
    // MARK: - Actions
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func save(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        }
        
     
        // Replace ID if it is from Inbox
        let recId = isNewChat ? self.channel.id : self.channel.id?.replacingOccurrences(of: Auth.auth().currentUser!.uid, with: "")
        
        inboxRef?.selectedInboxUnreadMsgs += 1
        let timestamp = NSDate().timeIntervalSince1970
        
        db.collection("inbox").document(id).setData(["recID":recId ?? "" , "senderID" : Auth.auth().currentUser!.uid, "receiverName" : self.channel.name, "senderName" : Auth.auth().currentUser?.displayName , "latestMemberId" : Auth.auth().currentUser!.uid, "unreadMessages":inboxRef?.selectedInboxUnreadMsgs ?? 1 ,
            "timestamp": timestamp ], completion: { (error) in
                                                                        
//            FCMHandler.sharedInstance.fetchFCMToken(receiverID: recId!) { token in
//
//            FCMHandler.sharedInstance.sendPush(title: "New Message", tokens: [token], senderName: userName, ExtraParametes: ["ChannelId" : self.channel.id , "Type" : "Chat", "ChannelName" : userName])
//            }
              
     
                                                                        
        })
        
        
    }
    //
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    private func handleDocumentChange(_ change: DocumentChange) {
        
        
        guard var message = Message(document: change.document) else {
            return
        }
        switch change.type {
        case .added:
            if let url = message.downloadURL {
                downloadImage(at: url) { [weak self] image in
                    guard let `self` = self else {
                        return
                    }
                    guard let image = image else {
                        return
                    }
                    
                    message.image = image
                    message.kind = MessageKind.photo(MessageMediaItem(image: image))
                    self.insertNewMessage(message)
                    if self.isNewMsg{
                        self.newMessages.append(message.id!)

                    }
                }
            } else {
                if isNewMsg{
                    self.newMessages.append(message.id!)

                }

                
                insertNewMessage(message)
                
            }
            
        case .removed:
//            messages.remove(at: index)
            if inboxRef!.selectedInboxUnreadMsgs < 0 {
                db.collection("channels").document(id).updateData(["unreadMessages" : 0])
            }else {
                db.collection("channels").document(id).updateData(["unreadMessages" : inboxRef!.selectedInboxUnreadMsgs])
            }
            
            messages.removeAll(where: {selectedMsgIDs.contains($0.messageId)})
            messagesCollectionView.reloadData()

            
            
        default:
            break
        }
    }
    
    
    
    private func uploadImage(_ image: UIImage, to channel: Channel, completion: @escaping (URL?) -> Void) {
        guard let channelID = channel.id else {
            completion(nil)
            return
        }
        
        guard let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                completion(nil)
                return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let ref = storage.child(channelID).child(imageName)
        ref.putData(data, metadata: metadata) { meta, error in
            ref.downloadURL(completion: { (url, error) in
                completion(url)
                print(url)
            })
        }
    }
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        
        uploadImage(image, to: channel) { [weak self] url in
            guard let `self` = self else {
                return
            }
            self.isSendingPhoto = false
            
            guard let url = url else {
                return
            }
            
            var message = Message(user: self.user!, image: image)
            message.downloadURL = url
            
            self.save(message)
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
    }
    
    
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {
        // 1
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        // 2
        return CGSize(width: 0, height:8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        // 3
        return 0
    }
    
    //    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    //          return 18
    //      }
    
    //      func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    //          return 17
    //      }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 15
    }
    
    //      func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    //          return 16
    //      }
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if !selectedIndex.isEmpty{
            if selectedIndex.contains(indexPath.section) {
                return .red
            }
                
            else {
                return isFromCurrentSender(message: message) ? .black : .purple
            }
        }
        return isFromCurrentSender(message: message) ? .black : .purple
        
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        
        // 2
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        // 3
        return .bubbleTail(corner, .curved)
    }
    
    
    
    

    
    
    
    
    
    
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: user!.uid, displayName: user?.displayName ?? "ABC")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return messages.count
    }
    
    
    // 3
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    //   4
    //  func cellTopLabelAttributedText(for message: MessageType,
    //    at indexPath: IndexPath) -> NSAttributedString? {
    //
    //    let name = message.sender.displayName
    //    return NSAttributedString(
    //      string: "name",
    //      attributes: [
    //        .font: UIFont.preferredFont(forTextStyle: .caption1),
    //        .foregroundColor: UIColor(white: 0.3, alpha: 1)
    //      ]
    //    )
    //  }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    
    
    
    
}




// MARK: - UIImagePickerControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let asset = info[.phAsset] as? PHAsset { // 1
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
                guard let image = result else {
                    return
                }
                
                self.sendPhoto(image)
            }
        } else if let image = info[.originalImage] as? UIImage { // 2
            sendPhoto(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(user: user!, content: text)
        
        isNewMsg = true

        save(message)
        inputBar.inputTextView.text = ""
    }
    
    
    
    
}

extension ChatViewController{
    
    private struct MessageMediaItem: MediaItem {
        
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

extension ChatViewController: MessageCellDelegate{
    func didTapMessage(in cell: MessageCollectionViewCell) {
        // handle message here
        let indexPath = messagesCollectionView.indexPath(for: cell)
        let message = messages[indexPath!.section]
        //        cell.backgroundColor = .blue
//        let selectedID = message.messageId
//        messageId = messages[indexPath!.section].messageId
        if isFromCurrentSender(message: message)
        {
            selectedMsgIDs.append(message.messageId ?? "")
            selectedIndex.append(indexPath!.section)
            
        }
        messagesCollectionView.reloadItems(at: [indexPath!])
        
        
        
    }
    
    
    
    
}
