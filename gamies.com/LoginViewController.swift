//
//  LoginViewController.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import NCMB


class LoginViewController: UIViewController {

   
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var LoginFailedMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginbutton(_ sender: UIButton) {
        do{
            try NCMBUser.logIn(withUsername: userEmailTextField.text, password: userPasswordField.text)
            performSegue(withIdentifier: "ToChooseGame", sender: (Any).self)
        }catch{
            let errors = error
            print (errors)
            performSegue(withIdentifier: "ToRegister", sender: (Any).self)
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



