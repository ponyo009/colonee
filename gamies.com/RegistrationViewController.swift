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
        //let obj = NCMBObject(className: "Userclass"
        //入力されたのが有効なアドレスとパスワードかどうかの確認メソッド
        if (userEmailTextField.text?.isEmpty)! || (userPasswordTextField.text?.isEmpty)! {
            SignUpFailedMessage.alpha = 1
        }
        
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
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
