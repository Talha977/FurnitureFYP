//
//  NewPostViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 26/02/2020.
//  Copyright © 2020 Danyal Naveed
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseFirestore

class NewPostViewController: UIViewController {

    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var imgUserImage: UIImageView!
    
    @IBOutlet weak var imgHomePic: UIImageView!
    
    @IBOutlet weak var tfHomeText: UITextField!
    
    @IBOutlet weak var btnPost: UIButton!
    
    @IBOutlet weak var btnAddPicture: UIButton!
    
    let db = Firestore.firestore()
    var hud : JGProgressHUD  = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tfHomeText.attributedPlaceholder = NSAttributedString(string: "Say something ...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        Utilities.styleFilledButton(btnPost)

         
       // hud.textLabel.text = "Loading"

        
    }



    
    @IBAction func btnAddPicturePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
//        sender.setTitle("", for: .selected)
//        sender.setTitle("Add Picture", for: .disabled)

        if sender.isSelected {
            showBottomActivity()

        
        }else{
            imgHomePic.image = nil

        }
        
        
    }
    
    @IBAction func btnPostPressed(_ sender: Any) {
        hud.textLabel.text = ""
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        hud.show(in: self.view)
        
        addPost()
        
        
    }
    
    func addPost (){
        if imgHomePic.image == nil {
            hud.textLabel.text = "No Image Added"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2, animated: true)
            return
            
        }
            let text = tfHomeText.text
            let timestamp = NSDate().timeIntervalSince1970
        uploadImage { (url) in
            let payload = ["text" : text , "timestamp" : timestamp , "username" : Auth.auth().currentUser?.displayName ,"imageurl" : url?.absoluteString , "id" : Auth.auth().currentUser?.uid, "profilePicUrl" : Auth.auth().currentUser?.photoURL?.absoluteString
                            ] as [String : Any]
                
                let db = Firestore.firestore()
                db.collection("posts").addDocument(data: payload) { (error) in
                    if error != nil{
                        print("succeful")
                       


                    }else{
                        self.tfHomeText.text = ""
                        self.imgHomePic.image = nil
                        self.btnAddPicture.isSelected = false
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.textLabel.text = "Posted"
                        self.hud.dismiss(afterDelay: 1, animated: true)
                        //self.navigationController?.popViewController(animated: true)
                        //

                    }
                }

        }
}
    func uploadImage(completion: @escaping (_ url: URL?)->()) {
        guard let image = imgHomePic.image else { return }
        let storageRef = Storage.storage().reference().child("ForumImages").child("\(UUID())")

        let imageData = image.jpegData(compressionQuality: 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.putData(imageData!, metadata: metaData) { (metaData, error) in
            if error == nil{
                print("success for  photo")
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            }else{
                print("error in save image")
                completion(nil)
            }
        }
    }
    func showBottomActivity(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let imgCamera = UIImage(systemName: "camera")!.withRenderingMode(.alwaysTemplate)
        let imgViewCamera = UIImageView()
        imgViewCamera.tintColor = .systemBlue
        imgViewCamera.image = imgCamera
        imgViewCamera.frame =  CGRect(x: 25, y: 18, width: 24, height: 20)
        alertController.view.addSubview(imgViewCamera)
        
        //self.image = self.image?.withRenderingMode(.alwaysTemplate)
                  //self.tintColor = value
        let imgAlbum = UIImage(systemName: "photo")!.withRenderingMode(.alwaysTemplate)
        let imgViewAlbum = UIImageView()
        imgViewAlbum.image = imgAlbum
        imgViewAlbum.tintColor = .systemBlue
        imgViewAlbum.frame = CGRect(x: 25, y: 75, width: 24, height: 20)
        alertController.view.addSubview(imgViewAlbum)
        //imageView1.frame =

           // Create the actions
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { action in
            self.scanImage()
        }
        
        let photosAction = UIAlertAction(title: "Photos", style: UIAlertAction.Style.default) {
               UIAlertAction in
            self.openGallery()
           }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
               UIAlertAction in
               NSLog("Cancel Pressed")
           }

           // Add the actions
           alertController.addAction(cameraAction)
           alertController.addAction(photosAction)
           alertController.addAction(cancelAction)

           // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func scanImage(){
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)    }
    
    func openGallery(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
        
    
    
}

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        imgHomePic.isHidden = false
        imgHomePic.image = image
    }
}

