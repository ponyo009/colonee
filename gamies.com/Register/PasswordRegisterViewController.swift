//
//  PasswordRegisterViewController.swift
//  gamies.com
//
//  Created by akira on 2019/07/03.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class PasswordRegisterViewController: UIViewController {

    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var email: UILabel!
    
    var password = String()
    var mail = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = mail
        TextField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ButtonTapped(_ sender: Any) {
          password = TextField.text!
        performSegue(withIdentifier: "Next", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! NameRegisterViewController
        next.mail = mail
        next.password = password
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TextField.text = TextField.text
        self.view.endEditing(true)
    }
    
    @IBAction func eyeBtnTouchdown(_ sender: Any) {
        TextField.isSecureTextEntry = false
    }
    
    
    @IBAction func eyeBtnTapped(_ sender: Any) {
        TextField.isSecureTextEntry = true
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
