//
//  LoginViewController.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController {

   
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordField: UITextField!
    
    @IBOutlet weak var LoginFailedMessage: UILabel!
    
    let userdefaults_email = UserDefaults.standard.object(forKey: "userEmail")
    let userdefaults_pass = UserDefaults.standard.object(forKey: "userPassword")
    //UserDefaultsの定義

    
    override func viewDidLoad() {
        super.viewDidLoad()

        userEmailTextField.text = userdefaults_email as? String
        userPasswordField.text = userdefaults_pass as? String

        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func loginbutton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: userEmailTextField.text!, password: userPasswordField.text!) { (user, error) in
            if error != nil{
                self.LoginFailedMessage.alpha = 1
            }else{
            
            self.performSegue(withIdentifier: "ToChooseGame", sender: (Any).self)
            }
    }
}
}
        
        //  NCMBUser.logInWithUsername(inBackground:user.userName, password: user.password, block:({(user: NCMBUser!, error: NSError!) in
        //     if error != nil {
        // ログイン失敗時の処理
        //       self.LoginFailedMessage.alpha = 1
        // }else{
        // ログイン成功時の処理
        //   self.performSegue(withIdentifier: "ToChooseGame", sender: nil)
        // }
        // } as! NCMBUserResultBlock))
        
    

    
        
      //  NCMBUser.logInWithUsername(inBackground:user.userName, password: user.password, block:({(user: NCMBUser!, error: NSError!) in
       //     if error != nil {
                // ログイン失敗時の処理
         //       self.LoginFailedMessage.alpha = 1
           // }else{
                // ログイン成功時の処理
             //   self.performSegue(withIdentifier: "ToChooseGame", sender: nil)
           // }
           // } as! NCMBUserResultBlock))

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



