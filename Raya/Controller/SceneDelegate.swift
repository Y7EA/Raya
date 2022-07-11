//
//  SceneDelegate.swift
//  Raya
//
//  Created by Yahya haj ali  on 23/03/2022.
//
import UIKit
import Firebase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    //R authListener  متغير لمعرفة المستخدم اذا كان مسجل خروج من التطبيق او لا عشان اول ما يفوت ع التطبيق يضل حافظ حسابه مش كل ما يشغل لازم يسجل دخول خلص بسجل مره وحده وبضل فاتح ووقت ما بعده بعمل تسجيل خروج ف وظيفه ثانيه راح نعملها لقدام بأذن الله

    var authListener: AuthStateDidChangeListenerHandle?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        autoLogin()
        resetBadget()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        resetBadget()
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        LocationManager.shared.startUpdating()
        resetBadget()
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        LocationManager.shared.stopUpdating()
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        resetBadget()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        LocationManager.shared.stopUpdating()
        resetBadget()
        
    }
    
    
    
    func autoLogin(){
        
        
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            
            if user != nil && userDefaults.object(forKey: kCURRENTUSER) != nil {
                
                DispatchQueue.main.async {
                    self.goToApp()
                }

                
            }
            
            
        })
    }
    
    
    private func goToApp() {
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        
        
        self.window?.rootViewController = mainView
        
    }

    
    private func resetBadget() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}

