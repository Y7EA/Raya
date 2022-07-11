//
//  ViewController.swift
//  Raya
//
//  Created by Yahya haj ali  on 23/03/2022.
//

import UIKit
import ProgressHUD // هاي مكتبه ضفناها ف pod بتساعد في اظهار مسج للمستخدم بشكل اجمل واسهل

class LoginViewController: UIViewController {

     //MARK:- IBActions
    
    
    @IBAction func composeButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. هين راح اضيف الاشياء الي بدي اياها او ل ما تتحمل شاشة التطبيق
        emailLabelOutlet.text = ""
        passwordLabelOutlet.text = ""
        confirmPasswordLabelOutlet.text = ""
        
        emailTextFieldOutlet.delegate = self
        passwordTextFieldOutlet.delegate = self
        confirmPasswordTextFieldOutlet.delegate = self
        
        
        setupBagroundTap() // i هاي للكيبورد عشان اذا ضغطة ع الشاشه يختفي
        // Do any additional setup after loading the view.
    }

    
  //MARK:- Variables
  
    var isLogin: Bool = false
    
    
 //MARK:- IBOutlets
    
    
    //Labels
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var emailLabelOutlet: UILabel!
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    @IBOutlet weak var confirmPasswordLabelOutlet: UILabel!
    @IBOutlet weak var haveAnAccountLabelOutlet: UILabel!
    //TextFields

    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    @IBOutlet weak var confirmPasswordTextFieldOutlet: UITextField!
    
    //Button Outlets
    
    @IBOutlet weak var forgetPasswordOutlet: UIButton!
    @IBOutlet weak var resendEmailOutlet: UIButton!
    @IBOutlet weak var registerOutlet: UIButton!
    @IBOutlet weak var loginOutlet: UIButton!
    
//MARK:- IBAction
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        
        if isDataInputedFor(mode: "forgetPassword") {
            print ("all data inputed correctly")
            // reser password هين راح اعمل من ال فاير بيس ميزت انه يعيد تعين الرقم السري من جديد يعني فنكشن لقدام هتكون

            forgetPassword()

        } else {
            // alert masseg هين عشان اظهر مسج للمستخدم اذا ما دخل المدخلات صح الخاصه ب نسيان كلمة المرور وهكذا
            //i هين ب استخدام المكتبه شوف كيف اسهل من الكود الي فوق
            ProgressHUD.showError("All Fields Are Requird ")
            
        }
        
        
        
    }
    
    
    @IBAction func resendEamilPressed(_ sender: UIButton) {
        print ("resend email pressed")
        
        resendVerficationEmail()
        
        
        

    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {

        if isDataInputedFor(mode: isLogin ? "login" : "register") {
            
            // login or register هين راح اعمل انه بعد ما يسجل او يعمل حساب شو راح يصير انه يروح ع الابلكيشن تاعنا الشات

           
            isLogin ? loginUser() : registerUser()
            
            //TODO:- LOGIN or Register
            
            
            //Register
            

            
            
            
        } else {
            
            ProgressHUD.showError("All fields are required")
        }
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        updateUIMode(mode: isLogin)
            
    }
    
    
    
    private func updateUIMode(mode: Bool) {
        //login to register page احول من صفحة التسجيل الى انشاء حساب وشو اظهر بكل صحفه
        
        if !mode {
            titleOutlet.text = "Login"
            confirmPasswordLabelOutlet.isHidden = true
            confirmPasswordTextFieldOutlet.isHidden = true
            registerOutlet.setTitle("Login", for: .normal)
            loginOutlet.setTitle("Register", for: .normal)
            haveAnAccountLabelOutlet.text = "New here?"
            forgetPasswordOutlet.isHidden = false
            resendEmailOutlet.isHidden = true
        } else {
            titleOutlet.text = "Register"
            confirmPasswordLabelOutlet.isHidden = false
            confirmPasswordTextFieldOutlet.isHidden = false
            registerOutlet.setTitle("Register", for: .normal)
            loginOutlet.setTitle("Login", for: .normal)
            haveAnAccountLabelOutlet.text = "Have an account?"
            resendEmailOutlet.isHidden = false
            forgetPasswordOutlet.isHidden = true
            



        }
        
        isLogin.toggle()
        
        
    }
    
    
     //MARK:- Helpers Or Utilities
    // Helpers هين عشان اتأكد من المدخلات واطلعله مسج اذا حاطط الايميل والباس وغيره صح وبحط الفنكشن الخاصه ب مساعدة المسخدم ف تسجيل حساب ونسيان كلمة المرور وهكذا

    
    private func isDataInputedFor (mode: String) ->Bool {
        
        switch mode {
        case "login":
            return emailTextFieldOutlet.text != "" && passwordTextFieldOutlet.text != ""
        case "register":
            return emailTextFieldOutlet.text != "" && passwordTextFieldOutlet.text != nil && confirmPasswordTextFieldOutlet.text != ""
            
        case "forgetPassword":
            return emailTextFieldOutlet.text != ""
        default:
            return false
        }
        
        
    }
    
    
     //MARK:- Tap Gesture Recognizer
    // Tap Gesture Recognizer هاي عشان بس اكبس ع اشي فاضي يروح الكيبورد وانا بكتب بدل ما يضل معلق وهي اسمها تاب

    
    private func setupBagroundTap() {
        
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    // Object of c لازم تكون من هاض النوع عشان يتعرف عليها هيك هي اساس من اللغه بس اعمل

    @objc func hideKeyboard () {
        view.endEditing(false)
    }
    
    
    
     //MARK:- Forget passowrd
    
    private func forgetPassword(){
        FUserListener.shared.resetPasswordFor(email: emailTextFieldOutlet.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Reset password email has been sent")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    
     //MARK:- Register User
    //Y الفنكشن الخاصه عند ضغط ع زر resend email

    
    private func registerUser() {
        
            
            if passwordTextFieldOutlet.text! == confirmPasswordTextFieldOutlet.text! {
                FUserListener.shared.registerUserWith(email: emailTextFieldOutlet.text!, password: passwordTextFieldOutlet.text!) { (error) in
                    
                    if error == nil {
                        ProgressHUD.showSuccess("Verification email sent, please verify your email and confirm the registeration")
                        
                    }else {
                        ProgressHUD.showError(error!.localizedDescription)
                    }
                    
                }
                
                
            }
            
        
    }
    
    
    private func resendVerficationEmail() {
        
        FUserListener.shared.resendVerficationEmailWith(email: emailTextFieldOutlet.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Verification email sent successfully")
            }else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
            
        }
    }
    
    
    
    
 //MARK:- Login user
    
    private func loginUser() {
        
        FUserListener.shared.loginUserWith(email: emailTextFieldOutlet.text!, passwrod: passwordTextFieldOutlet.text!) { (error, isEmailVerified) in
            
            if error == nil {
                
                if isEmailVerified {
                    // i هسا سجل وكلشي تماما يفوت ع التطبيق
                    self.goToApp()
                    if User.currentUser != nil {
                        let pushManager = PushNotificationManager(userID: User.currentId)
                            pushManager.registerForPushNotifications()
               
                    }
                    
                    print ("go to chat application")
                    
                } else {
                    ProgressHUD.showFailed("Please check your email and verify your registration")
                    
                }
                
                
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
            
        }
        
    }
    
    
     //MARK:- Navigation
    
    private func goToApp(){
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
       
}

 //MARK:- UI Text Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        emailLabelOutlet.text = emailTextFieldOutlet.hasText ? "Email" : ""
        passwordLabelOutlet.text = passwordTextFieldOutlet.hasText ? "Password" : ""
        confirmPasswordLabelOutlet.text = confirmPasswordTextFieldOutlet.hasText ? "Confirm Password" : ""
        
    }
}
