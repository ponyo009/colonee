//
//  RegistrationViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseDatabase



class RegistrationViewController: UIViewController {
    
    var ref: DatabaseReference?
    var user = Auth.auth().currentUser!
    let db = Firestore.firestore()
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var SignUpFailedMessage: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func confirmButtonTapped(_ sender: Any) {
        //let obj = NCMBObject(className: "Userclass"
        //入力されたのが有効なアドレスとパスワードかどうかの確認
        if (userEmailTextField.text?.isEmpty)! || (userPasswordTextField.text?.isEmpty)! {
            SignUpFailedMessage.alpha = 1
        }
        
        //新規ユーザー登録
        Auth.auth().createUser(withEmail: userEmailTextField.text!, password: userPasswordTextField.text!) { (authResult, error) in
            if error != nil {
                self.SignUpFailedMessage.alpha = 1
                print("SignUpFailed")
                // 新規登録失敗時の処理
            }else{
               
                let db = Firestore.firestore()
                self.user = Auth.auth().currentUser!
                db.collection("users").document(self.user.uid).setData([
                    "username": self.user.displayName as Any,
                    "email": self.user.email as Any,
                    ])
                
                self.performSegue(withIdentifier: "SignUpSuccessed", sender: nil)
                print("SignUp!")
            
            }}
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
