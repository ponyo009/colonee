//
//  UserProfileViewController.swift
//  gamies.com
//
//  Created by akira on 2019/03/21.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseDatabase


class UserProfileViewController: UIViewController {

    @IBOutlet weak var iconimage: UIImageView!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var nickname = ""
    var introduce = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nickname)
        print(introduce)
        let UID = user!.uid
      //  let ref = storage.reference().child(UID).child("\(GameName)")
        

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
