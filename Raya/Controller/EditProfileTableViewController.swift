//
//  EditProfileTableViewController.swift
//  Raya
//
//  Created by Yahya haj ali  on 20/04/2022.
//

import UIKit
import Gallery // Gallery library خاصة في التعامل مع الصور
import ProgressHUD

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        configureTextField()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //f منا نعمل فنكشن ترجع معلومات المستخدم الحالي

        showUserInfo()

    }

    // Variables
    //! un define يعني بدي اعمل init للمتغير لاحقا زي كانه int x ;
    var gallery : GalleryController!
    
    
     //MARK:- IBOutlets
    
    @IBOutlet weak var avatarImageViewOutlet: UIImageView!
    @IBOutlet weak var usernameTextFieldOutlet: UITextField!
    @IBOutlet weak var statusLabelOutlet: UILabel!
      
    
     //MARK:- IBActions
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        showImageGallery()
        
    }
    
       
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 0.0 :30.0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableview")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {

            performSegue(withIdentifier: "editProfileToStatusSegue", sender: self)
            
            
        }
        
        
        
    }
    
    
    
     //MARK:- Show USer Info
    
    private func showUserInfo() {
        
        if let user = User.currentUser {
            
            usernameTextFieldOutlet.text = user.username
            statusLabelOutlet.text = user.status
            
            if user.avatarLink != "" {

                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImageViewOutlet.image = avatarImage?.circleMasked
                }
                
            }
        }
    }
    
    
    
     //MARK:- Configure Textfield
    //s هاي للنص تاع اسم المستخدم عشان اغيره
    
    private func configureTextField() {
        
        usernameTextFieldOutlet.delegate = self
        usernameTextFieldOutlet.clearButtonMode = .whileEditing
    }

    
     //MARK:- Gallery
    //self هاي اني اسلم ال controller view الوظيفة عشان يسند او يعمل قيمه او اي عمليه بدي اياها بتكون زي تفاعل المستخدم مع الشاشة وهيك بشكل عام
    //showImageGallery هاي الي بس نضغط ع edit بتفتح المعرض ونغير الصوره
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        
        self.present(gallery, animated: true, completion: nil)
        
    }
    
    
     //MARK:- Text field delegate function
    // Text field delegat function هاي عشان احفظ الاسم الي غيرته محل الايميل الي كان defult اساسا من اول ما اعملت الحساب
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextFieldOutlet {
            
            if textField.text != "" {
                
                if var user = User.currentUser {
                    
                    user.username = textField.text!
                    saveUserLocally(user)
                    FUserListener.shared.saveUserToFirestore(user)
                }
                
            }
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    //up رفع صورة وحفظها ف الداتا بيس
    private func uploadAvatarImage(_ image: UIImage) {
        
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            if var user = User.currentUser {
                
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FUserListener.shared.saveUserToFirestore(user)
            }
            
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentId)
                                    
        }
                       
    }
    
        
}

extension EditProfileTableViewController : GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            images.first!.resolve { (avatarImage) in
                if avatarImage != nil {
                    
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImageViewOutlet.image = avatarImage
                } else {
                    ProgressHUD.showError("Could not select image")
                }
                
                
            }
            
            
        }
        controller.dismiss(animated: true, completion: nil)

    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)

    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)

    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
}
