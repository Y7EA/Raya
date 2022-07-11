//
//  User.swift
//  Raya
//
//  Created by Yahya haj ali  on 25/03/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct User: Codable, Equatable {
    
    var id = ""
    var username: String
    var email: String
    var pushId = ""//background لارسال الاشعارات للمستخدم في حالة كان التطبيق ف
    var avatarLink = ""
    var status: String
    
    
    
    static var currentId: String {
        
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        
        if Auth.auth().currentUser != nil {
            
            if let data = userDefaults.data(forKey: kCURRENTUSER) {
                
                let decoder = JSONDecoder()
                
                do {
                    
                    let userObject = try decoder.decode(User.self, from: data)
                    
                    return userObject
                } catch {
                    
                    print (error.localizedDescription)
                    
                }
                
            }
        }
        return nil
    }
    
    static func == (lhs: User, rhs: User)-> Bool {
        lhs.id == rhs.id
    }
 
    
    
}
//convert هين منا نحول الاوبجك اللا بيانات لحفظها ف الموقع وبتقوم ف حفظ الداتا ف الfirebase
func saveUserLocally(_ user: User) {
    
    let econder = JSONEncoder()
    
    do {
    let data = try econder.encode(user)
    
        userDefaults.set(data, forKey: kCURRENTUSER)
    } catch {
        print (error.localizedDescription)
    }
    
}

// not corect في مشكله ف تخزين الصور نوع الصورة اتوقع مع الداتا بيس لهيك ما برضى يعمل مستخدمين وهميين فيها

func createDummyUsers() {
    print("creating dummy users...")
    
    let names = ["Rahaf", "Omar ", "Eman", "Talal", "jalal"]
    
    var imageIndex = 1
    var userIndex = 1
    
    for i in 0..<5 {
        
        let id = UUID().uuidString
        
        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
        
        FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { (avatarLink) in
            
            let user = User(id: id, username: names[i], email: "user\(userIndex)@mail.com", pushId: "", avatarLink: avatarLink ?? "", status: "No Status")
            
            userIndex += 1
            FUserListener.shared.saveUserToFirestore(user)
        }
        
        imageIndex += 1
        if imageIndex == 5 {
            imageIndex = 1
        }
    }
    
}
