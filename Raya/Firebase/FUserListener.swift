//
//  FUserListener.swift
//  Raya
//
//  Created by Yahya haj ali  on 25/03/2022.
// r مسؤول عن عمليات الكتابه والقراءة من الفيس ستور

import Foundation
import Firebase

class FUserListener {
    
    static let shared = FUserListener()
    
    private init () {}
    
    //completion هاض خاص للحدوث خطا يعطي مسج انه الداتا غلط او ما صار وصول الها وهيك

     //MARK:- Login
    
    func loginUserWith(email: String, passwrod: String, completion: @escaping(_ error: Error?,_ isEmailVerified: Bool)->Void)
    {
        Auth.auth().signIn(withEmail: email, password: passwrod) { (authResults, error) in
            
            if error == nil && authResults!.user.isEmailVerified {
                completion (error, true)
                //y هاي الفنكشن لتحميل بيانات المستخدم بس يسجل دخول يمكن لانه يمكن اكثر من مستخدم يسجل ع نفس الجوال في كل مره بفتح مستخدم حساب اله يحمل بياناته الي خاصه فيه وهيك

                self.downloadUserFromFirestore(userId: authResults!.user.uid)
                
            } else {
                completion(error, false)
            }
        }        
    }
            
     //MARK:- Logout
    
    func logoutCurrentUser(completion: @escaping (_ error: Error?)-> Void) {
        
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            completion(nil)
        } catch let error as NSError {
                
                completion(error)
            }
    }
    
     //MARK:- Register
    
    func registerUserWith (email: String, password: String, completion: @escaping (_ error: Error?) ->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] (authResults, error) in
            
            completion(error)
         
            if error == nil {
                
                authResults!.user.sendEmailVerification { (error) in
                    
                        completion(error)
                }
                
            }
            
            if authResults?.user != nil {
                
                let user = User(id: authResults!.user.uid, username: email, email: email, pushId: "", avatarLink: "", status: "Hey, I am using Raya")
                
                  
                saveUserToFirestore(user)
                saveUserLocally(user)
                

                
            }
            
        }
    }
    
    
     //MARK:- Resend link verficiatoin function
    //Y ارسال ايميل للتأكيد وايضا نسيان كلمة المرور
    
    func resendVerficationEmailWith(email: String, completion: @escaping (_ error: Error?)->Void) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                completion(error)
            })
        })
        
        
    }
    
     //MARK:- Reset password
    
    func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
        
    }

    func saveUserToFirestore(_ user: User) {
        do {
        
            try FirestoreReference(.User).document(user.id).setData(from: user)
        } catch {
            print (error.localizedDescription)
        }
        
    }
    
     //MARK:- Downlaod user from firestore
    private func downloadUserFromFirestore (userId: String) {
        FirestoreReference(.User).document(userId).getDocument { (document, error) in
            guard let userDocument = document else {
                print ("no data found")
                return
            }
            
            let result = Result {
                try? userDocument.data (as: User.self)
            
            }
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print ("Document does not exist")
                }
                
            case .failure(let error):
                print ("error decoding user", error.localizedDescription)

            
            }
    
        }
    }
    
     //MARK:- Download users using IDs
    
    func downloadUsersFromFirestore(withIds: [String], completion: @escaping(_ allUsers: [User])->Void) {
        
        //arry is empty عرفنا المصفوفه فارغه وعباناها ب كل المسخدمين في الفور لوب ما عد المستخدم الي فاتح الحساب عن طريق الاي دي تاع المستخدم الحالي

        var count = 0
        var usersArray: [User] = []
        
        //for loop هاي عشان ما يظهر مع المستخدمين المستخدم الي فاتح الحساب يعني بس يحط ع الامستخدمين ما يبين اسمه بينهم لانه شو بده بحاله يحكي شات مع حاله مثلا (:

        for userId in withIds {
            
            FirestoreReference(.User).document(userId).getDocument { (querySnapshot, error) in
                
                guard let document = querySnapshot else {
                    return
                }
                let user = try? document.data(as: User.self)
                
                usersArray.append (user!)
                count+=1
                
                if count == withIds.count {
                    completion (usersArray)
                }
                
            }
        }
        
        
         
    }
    
    
    
     //MARK:- Download all users
    func downloadAllUsersFromFirestore(completion: @escaping (_ allUsers: [User])->Void) {
        
        var users: [User] = []
        
        FirestoreReference(.User).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print ("No documents found")
                return
            }
            
            let allUsers = documents.compactMap { (snapshot) -> User? in
                return try? snapshot.data(as: User.self)
            }
            
            for user in allUsers {
                if User.currentId != user.id {
                    users.append(user)
                }
            }
            
            completion(users)
            
        }
        
        
        
    }
    
}

