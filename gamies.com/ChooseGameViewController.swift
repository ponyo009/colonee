//
//  ChooseGameViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseUI

class ChooseGameViewController: UIViewController {
    
    
    
    @IBOutlet weak var Game0: UIView!
    @IBOutlet weak var Game1: UIView!
    @IBOutlet weak var Game2: UIView!
    @IBOutlet weak var Game3: UIView!
    @IBOutlet weak var Game4: UIView!
    @IBOutlet weak var Game5: UIView!

    //ここにゲームを追加していく感じ？
    let GameNames = ["Fate Grand Order", "アイドルマスター シンデレラガールズ", "荒野行動", "モンスターストライク", "白猫プロジェクト", "Puzzle & Dragons"]

    var tagnum = Int()
    let user = Auth.auth().currentUser
    var ref: DocumentReference!
    let db = Firestore.firestore()
    let storage = Storage.storage()

    var introduce: String!
    var nickname: String!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func ButtonTapped(_ sender: UIButton) {
    //ボタンのtagの数字を取得
        tagnum = sender.tag
        
    //DBからuserのProfileデータを取得して遷移
        
        let UID = user?.uid
             //print (UID)
        //選択されたゲーム名のドキュメントへの参照
        let docref = db.collection(GameNames[tagnum]).document(UID!)
        //ドキュメント内容の取得
        docref.getDocument { (document, error) in
            if document!.exists {
                //取得できた場合、UserProfileへ
                let document_array = document!.data()
                self.nickname = document_array!["nickname"] as? String
                self.introduce = document_array!["introduce"] as? String
                self.performSegue(withIdentifier: "ToUserProfile", sender: (Any).self)
            } else {
                //取得できなかった場合、profile登録画面へ
                print("Document does not exist")
                self.performSegue(withIdentifier: "ToProfile", sender: (Any).self)
            }
        }
    }
    
    //選択されたゲーム名をregisterへ、nicnameとintroduceをUserProfileへ渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToProfile" ){
            let vc = segue.destination as! ProfileViewController
            vc.GameName = GameNames[tagnum]
        }else if (segue.identifier == "ToUserProfile"){
            let vc2 = segue.destination as! UserProfileViewController
            vc2.nickname = nickname
            vc2.introduce = introduce
            vc2.GameName = GameNames[tagnum]
        }

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

