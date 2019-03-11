//
//  RegistrationViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import NCMB

class RegistrationViewController: UIViewController {
    

    let user = NCMBUser()
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var SignUpFailedMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        
        //let obj = NCMBObject(className: "Userclass")
        
        let user = NCMBUser()
        
        //入力されたのが有効なアドレスとパスワードかどうかの確認メソッド
        
        user.userName = userEmailTextField.text
        user.password = userPasswordTextField.text
        user.signUpInBackground { (error) in
            if error != nil {
                self.SignUpFailedMessage.alpha = 1
                print("Failed")
                // 新規登録失敗時の処理
            }else{
                self.performSegue(withIdentifier: "SignUpSuccessed", sender: nil)
                print("SignUp!")
                // 新規登録成功時の処理
            }
        }
       //( obj?.setObject(userEmailTextField.text, forKey: "email")
        //obj?.setObject(userPasswordTextField.text, forKey: "pass")
        //obj?.saveInBackground({ (error) in
         //   if error != nil {
                // 保存に失敗した場合の処理
           // }else{
                // 保存に成功した場合の処理
       //     }
       // })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
