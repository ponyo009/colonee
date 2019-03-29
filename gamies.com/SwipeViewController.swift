//
//  SwipeViewController.swift
//  gamies.com
//
//  Created by akira on 2019/03/23.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class SwipeViewController: UIViewController {

    @IBOutlet weak var ToMatcher: UIButton!
    
    let UID = Auth.auth().currentUser?.uid
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    var GameName = ""
    var document_data: Dictionary<String,String>!
    var data_volume: Int!
    var document_number = 0
    
    var document_ID: String!
    
    //ユーザー情報のカード情報
    let cardFrame = CGRect.init(x:16, y:73, width:343, height:415)
    let iconImageFrame = CGRect.init(x:51, y:29, width:240, height:128)
    let usernickname = CGRect.init(x:8, y:165, width:320, height:41)
    let userintroduction = CGRect.init(x:8, y:214, width:320, height:167)
    
    //UIView作成
    func CreateUIView(){
        let UserCard = UIView.init(frame: self.cardFrame)
        UserCard.tag += 1
    }
    
    //imageview作成と画像取得
    func CreateIconImageView() {
        let userIconImage = UIImageView.init(frame:self.iconImageFrame )
        var storageref = storage.reference().child(/*useridが必要*/document_ID).child(GameName)
        userIconImage.sd_setImage(with: storageref)
        userIconImage.tag += 1
    }
    
    //nicknameラベル
    func CreateNickNameLabel(){
        let userNickName = UILabel.init(frame: usernickname)
        var nicknameref = db.collection(GameName).document(document_ID)
        nicknameref.getDocument{(document,error) in
            if let document = document, document.exists{
                let document_array = document.data()
                userNickName.text = document_array!["nickname"] as? String
                userNickName.tag += 1
            }
        }
    }
    //introduceラベル
    func CreateIntroduceLabel(){
        let userIntroduction = UILabel.init(frame: userintroduction)
        var introductionref = db.collection(GameName).document(document_ID)
        introductionref.getDocument{(document,error) in
            if let document = document, document.exists{
                let document_array = document.data()
                userIntroduction.text = document_array!["introduce"] as? String
                userIntroduction.tag += 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DBから<GameName>に格納されているuserの情報をすべて取得(自分のデータも持ってきてしまう)
        db.collection(GameName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //ドキュメント数の取得
                self.data_volume = querySnapshot?.count
                print(self.data_volume)
                
                //それぞれのドキュメントの内容をdocumet_dataに代入
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.document_ID = document.documentID
                    self.document_data = (document.data() as? Dictionary<String, String>)!
                    
                    //data_volume分のカードの作成
                    self.CreateUIView()
                    self.CreateIconImageView()
                    self.CreateNickNameLabel()
                    self.CreateIntroduceLabel()
                    
                }
                
                
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToMatcher"){
            let vc = segue.destination as! MatcherViewController
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
