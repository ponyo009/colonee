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
    


    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        
        let obj = NCMBObject(className: "Userclass")
        
        obj?.setObject(userEmailTextField.text, forKey: "email")
        obj?.setObject(userPasswordTextField.text, forKey: "pass")
        obj?.saveInBackground({ (error) in
            if error != nil {
                // 保存に失敗した場合の処理
            }else{
                // 保存に成功した場合の処理
            }
        })
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
