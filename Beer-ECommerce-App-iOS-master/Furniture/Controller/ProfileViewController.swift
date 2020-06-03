//
//  ProfileViewController.swift
//  FurnitureApp
//
//  Created by Danyal on 01/03/2020.
//  Copyright © 2020 Danyal Naveed. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var btnSignOut: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    static var postsCount : Int = 100
    static var saveCount : Int = 1
    static var count : Int = 100
    var profileCell = ProfileCell()
    var profileImage:UIImage?
    
    var hud : JGProgressHUD  = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Utilities.styleFilledButton(btnSignOut)
        
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        
        tableView.register(UINib(nibName: "PostsCell", bundle: nil), forCellReuseIdentifier: "PostsCell")
        
        let imageUrl = Auth.auth().currentUser?.photoURL
        
        if imageUrl != nil{
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: imageUrl!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.profileImage = image
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Profile"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done,target: self, action: #selector(btnSignoutPressed(_:)))
        
        
    }
    @IBAction func btnSignoutPressed(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        //        self.navigationController?.popToViewController(LoginViewController(), animated: true)
        self.tabBarController?.navigationController?.popToRootViewController(animated: true)
        //        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //        let vc = storyboard.instantiateViewController(withIdentifier: "VC") as! ViewController
        //        self.navigationController = UINavigationController.init(rootViewController:vc)
    }
    
    
    @IBAction func btnSelectImage(_ sender: Any) {
        showBottomActivity()
    }
    
    func showBottomActivity(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let imgCamera = UIImage(systemName: "camera")!.withRenderingMode(.alwaysTemplate)
        let imgViewCamera = UIImageView()
        imgViewCamera.tintColor = .systemBlue
        imgViewCamera.image = imgCamera
        imgViewCamera.frame =  CGRect(x: 25, y: 18, width: 24, height: 20)
        alertController.view.addSubview(imgViewCamera)
        
        let imgAlbum = UIImage(systemName: "photo")!.withRenderingMode(.alwaysTemplate)
        let imgViewAlbum = UIImageView()
        imgViewAlbum.image = imgAlbum
        imgViewAlbum.tintColor = .systemBlue
        imgViewAlbum.frame = CGRect(x: 25, y: 75, width: 24, height: 20)
        alertController.view.addSubview(imgViewAlbum)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { action in
            
            self.openCamera()
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
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            
        }
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func openCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Camera not Supported", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert,animated: true)
        }
        
    }
    
    func openGallery(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping (_ url: URL?)->()) {
           guard let uid = Auth.auth().currentUser?.uid else { return }
           let storageRef = Storage.storage().reference().child("profileImage").child("\(uid)")
           
        let imageData = profileImage?.jpegData(compressionQuality: 0.8)
           let metaData = StorageMetadata()
           metaData.contentType = "image/jpeg"
           storageRef.putData(imageData!, metadata: metaData) { (metaData, error) in
               if error == nil{
                   print("success for profile photo")
                   storageRef.downloadURL(completion: { (url, error) in
                       completion(url)
                   })
               }else{
                   print("error in save image")
                   completion(nil)
               }
           }
       }
    
    func uploadPic(){
          guard let image = profileImage else {return}
          
          let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
          uploadProfileImage(image) { url in
              changeRequest?.photoURL = url
              changeRequest?.commitChanges { (error) in
                  if error != nil {
                      print(error?.localizedDescription)
                  }else{
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.dismiss(afterDelay: 1, animated: true)
                      let db = Firestore.firestore()
                      db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["imageUrl": url?.absoluteString])
                      
                  }
              }
          }
      }
    
    
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            
            let profileCell  = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            
            profileCell.changeData = { isPosts in
                if isPosts{
                    ProfileViewController.count = 100
                    let cell = tableView.cellForRow(at: [0,1]) as! PostsCell
                    cell.collectionView.reloadData()
                    
                    //tableView.reloadRows(at: [[0,1]], with: .automatic)
                    
                }else{
                    ProfileViewController.count = 1
                    let cell = tableView.cellForRow(at: [0,1]) as! PostsCell
                    cell.collectionView.reloadData()
                    
                    //tableView.reloadRows(at: [[0,1]], with: .automatic)
                    
                }
                
            }
            
            if profileImage != nil {
                profileCell.imgProfilePic.image = profileImage

            }
            
            profileCell.btnAddImage.addTarget(self, action: #selector(btnSelectImage(_:)), for: .touchUpInside)
            
            return profileCell
            
        }else{
            let postsCell :UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "PostsCell") as! PostsCell
            return postsCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }else {
            return view.bounds.size.height - 200
        }
    }
    
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        profileCell = self.tableView.cellForRow(at: [0,0]) as! ProfileCell
        profileImage = image

        profileCell.imgProfilePic.image = image
        hud.show(in: self.view)

        uploadPic()

        //profileCell.reloadInputViews()
        
    }
}

