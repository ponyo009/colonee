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
    
    
   
    @IBOutlet weak var GameButton0: UIButton!
    
    
    
    @IBOutlet weak var Game0: UIView!
    @IBOutlet weak var Game1: UIView!
    @IBOutlet weak var Game2: UIView!
    @IBOutlet weak var Game3: UIView!
    @IBOutlet weak var Game4: UIView!
    @IBOutlet weak var Game5: UIView!

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
        
        //DBからuserのProfileデータを取得
        let UID = user?.uid
        let docref = db.collection("users").document(UID!).collection("Games").document(GameNames[tagnum
            ])
        
        docref.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.introduce = dataDescription
                
            } else {
                print("Document does not exist")
                self.performSegue(withIdentifier: "ToProfile", sender: (Any).self)
            }
        }
        
        //取得したらProfileデータをUserProfileControllerへ渡して画面遷移
        
        
        //取得できなかった場合はregisterへ
        
        
       // print("GameName Saved")
       // performSegue(withIdentifier: "ToProfile", sender: (Any).self)
    }
    
    //選択されたゲーム名を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToProfile" ){
            let vc = segue.destination as! ProfileViewController
            vc.GameName = GameNames[tagnum]
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

