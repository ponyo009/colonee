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
   // @IBOutlet weak var LoginFailedMessage: UILabel!
    
    let userdefaults_email = UserDefaults.standard.object(forKey: "userEmail")
    let userdefaults_pass = UserDefaults.standard.object(forKey: "userPassword")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userEmailTextField.text = userdefaults_email as? String
        userPasswordField.text = userdefaults_pass as? String

        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func loginbutton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: userEmailTextField.text!, password: userPasswordField.text!) { (user, error) in
            if user == nil{
                //self.LoginFailedMessage.alpha = 1
                print("signInFailed")
            }else{
                //UserDefaultsにアドレスとパスを保存
                UserDefaults.standard.set(self.userEmailTextField.text, forKey: "userEmail")
                UserDefaults.standard.set(self.userPasswordField.text, forKey: "userPassword")
                
                self.performSegue(withIdentifier: "ToChooseGame", sender: (Any).self)
            }
        }
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "Register", sender: self)
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



