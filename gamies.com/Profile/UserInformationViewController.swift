//
//  UserInformationViewController.swift
//  gamies.com
//
//  Created by akira on 2019/07/06.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class UserInformationViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var mailAddress: UILabel!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var introduce: UITextView!
    
    let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = user?.displayName
        mailAddress.text = user?.email
//        introduce.text = 
        // Do any additional setup after loading the view.
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
