//
//  NameRegisterViewController.swift
//  gamies.com
//
//  Created by akira on 2019/07/03.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class NameRegisterViewController: UIViewController {

    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var pass: UITextField!
    
    
    var mail = String()
    var password = String()
    var username = String()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        email.text = mail
        pass.text = password
        pass.isSecureTextEntry = true
        pass.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ButtonTapped(_ sender: Any) {
         username = TextField.text!
        Auth.auth().createUser(withEmail: mail, password: password) { (AuthDataResult, err) in
            if err != nil{
                print("SignUpFailed: ", err)
            }else{
                self.user = Auth.auth().currentUser
                self.user?.createProfileChangeRequest().displayName = self.username
                self.user?.createProfileChangeRequest().commitChanges(completion: { (err) in
                    if let err = err {
                        print("UserProfileUpdate Failed")
                    }else{
                        print("UserProfileUpdate Successed")
                    }
                })
                let db = Firestore.firestore()
                db.collection("users").document(self.user!.uid).setData([
                    "email": self.user?.email as Any,
                    "username": self.username as Any,
                    ])
                UserDefaults.standard.set(self.mail, forKey:"userEamil")
                UserDefaults.standard.set(self.password, forKey:"userPassword")
                UserDefaults.standard.set(self.username, forKey: "userName")
                self.performSegue(withIdentifier: "ToWelcome", sender: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TextField.text = TextField.text
        self.view.endEditing(true)
    }
    
    
    @IBAction func eyeBtnTouchdown(_ sender: Any) {
        pass.isSecureTextEntry = false
    }
    
    @IBAction func eyeBtnTapped(_ sender: Any) {
        pass.isSecureTextEntry = true
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
