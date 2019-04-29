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

    @IBOutlet weak var user_nickname: UILabel!
    @IBOutlet weak var user_introduce: UILabel!
    @IBOutlet weak var iconimage: UIImageView!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    //ChooseGameから受けとり
    var nickname = ""
    var introduce = ""
    var GameName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let UID = user!.uid
        
        //imageViewの初期化
        iconimage.image = UIImage(named: "default.png")
        
    //userimageiconの取得
        let ref = storage.reference().child(UID).child("\(GameName).jpeg")
        iconimage.sd_setImage(with: ref)
        
        user_nickname.text = nickname
        user_introduce.text = introduce
        
  /*    //初登録用
        if nickname .isEmpty {
            let userref = db.collection(GameName).document(UID)
            userref.getDocument {(document, error) in
                if let document = document {
                    let document_data = document.data()
                    self.user_nickname.text = document_data!["nickname"] as? String
                    self.user_introduce.text = document_data!["introduce"] as? String
        }else{
                    self.user_nickname.text = self.nickname
                    self.user_introduce.text = self.introduce
                }
            }
        }*/
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        performSegue(withIdentifier: "ToSwipe", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToSwipe"){
            let vc = segue.destination as! SwipeViewController
            vc.GameName = GameName
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

}
