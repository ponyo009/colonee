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


    
    let UID = Auth.auth().currentUser?.uid
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    var UserOwnNickName = ""
    var GameName = ""
    var document_data: Dictionary<String,String>!
    var document_number = 0
    var document_ID: String!
    var document_nickname: String!
    
    //データ数とスワイプカウンター
    var data_volume: Int!
    var swipe_counter = 1
    
    //ユーザーカード位置（レスポンシブにしたい）
    var cardFrame = CGRect(x:16, y:73, width:350, height:370)
    let iconImageFrame = CGRect(x:51, y:29, width:240, height:128)
    let usernicknameframe = CGRect(x:8, y:165, width:320, height:41)
    let userintroductionframe = CGRect(x:8, y:214, width:320, height:167)
    
    //ユーザーカード
    var UserCard: UIView!
    var UserIconImage: UIImageView!
    var tagnum = 1
    var centerOfCard: CGPoint!
    
    //like処理用
    var NickNames: [String] = []
    var LikedNames: [String] = []
    var UserIDs: [String] = []
    var LikedUIDs: [String] = []
    var LikedUserInfos: [String:String] = [ : ]
    var IconImage:UIImage!
    var IconImages: [UIImage] = []
    var LikedImages: [String : UIImage] = [:]
    
    //マッチ確認用
    var IsMatch: Bool = false
    
    //UIView作成
    func CreateUIView(){
        UserCard = UIView(frame: cardFrame)
        UserCard.tag = tagnum
        UserCard.backgroundColor = UIColor.white
        view.addSubview(UserCard)
        UserCard = self.view.viewWithTag(tagnum)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        UserCard.addGestureRecognizer(panGesture)
    }
    //imageview作成と画像取得（UserIconImage.imageがnilになる時がある）
    func CreateIconImageView() {
        UserIconImage = UIImageView(frame:self.iconImageFrame )
        let storageref = storage.reference().child(document_ID).child(GameName)
        UserIconImage.sd_setImage(with: storageref)
        UserIconImage.tag = tagnum
        print ("icon: ", UserIconImage)
        print ("iconimage: ", UserIconImage.image)
        UserCard.addSubview(UserIconImage)
    }
    //nicknameラベル
    func CreateNickNameLabel(){
        var userNickName = UILabel.init(frame: usernicknameframe)
        userNickName.tag = tagnum
        userNickName.backgroundColor = UIColor.white
       //特定のtagnumのUILabelを指定
        UserCard.addSubview(userNickName)
        userNickName = userNickName.viewWithTag(tagnum) as! UILabel
        
        let nicknameref = db.collection(GameName).document(document_ID)
        nicknameref.getDocument{(document,error) in
            if let document = document, document.exists{
                let document_array = document.data()
                userNickName.text = document_array!["nickname"] as? String
            }
        }
    }
    //introduceラベル
    func CreateIntroduceLabel(){
        var userIntroduction = UILabel.init(frame: userintroductionframe)
        userIntroduction.tag = tagnum
        userIntroduction.backgroundColor = UIColor.white
        UserCard.addSubview(userIntroduction)
        userIntroduction = userIntroduction.viewWithTag(tagnum) as! UILabel
        var introductionref = db.collection(GameName).document(document_ID)
        introductionref.getDocument{(document,error) in
            if let document = document, document.exists{
                let document_array = document.data()
                userIntroduction.text = document_array!["introduce"] as? String
            }
        }
    }
    //Usercardを元の位置に
    func resetCard() {
        UserCard.center = self.centerOfCard
        UserCard.transform = .identity
    }
    
    //マッチ済みかどうか確認
    func isMatched(document_ID: String){
        let isMatchedref = db.collection(GameName).document(UID!).collection("Liked")
        isMatchedref.document(document_ID).getDocument{(snapshot, error) in
            if let snapshot = snapshot, snapshot.exists  {
                let ismatch_data = snapshot.data()
                print("ducment_ID: ", document_ID)
                self.IsMatch = ismatch_data!["matched"] as! Bool
            }else{
                self.IsMatch = false
            }
            print("IsMatch: ", self.IsMatch)
        }
    }
    
    //Pangestureのアクション *１番手前のカードしかリセットされない
    @objc func panAction(_ sender: UIPanGestureRecognizer){
        
        centerOfCard = UserCard.center
        let card = sender.view
        let point = sender.translation(in: view)
        
        card?.center = CGPoint(x: (card?.center.x)! + point.x, y: (card?.center.y)! + point.y)
        UserCard.center = CGPoint(x: (card?.center.x)! + point.x, y: card!.center.y + point.y)
        //角度を変える
        let xFromCenter = card!.center.x - view.center.x
        card!.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2 ) * 0.785)
        UserCard.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2 ) * 0.785)
        
        
        if sender.state == UIGestureRecognizer.State.ended {
            //左に大きくスワイプ(Bad)
            if card!.center.x < 75 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.resetCard()
                    self.UserCard.center = CGPoint(x: self.UserCard.center.x - 350, y: self.UserCard.center.y)
                })
                self.UserCard.removeFromSuperview()
                db.collection(GameName).document(UID!).collection("Liked").document(UserIDs[data_volume - swipe_counter]).setData(["Liked": false])
                swipe_counter += 1
                if swipe_counter > data_volume{
                    performSegue(withIdentifier: "ToMatcher", sender: (Any).self)
                }
            //LikeイメージとBadイメージ用
                /* likeimageView.alpha = 0
                }*/
                return
                //右に大きくスワイプ(Like)
            } else if card!.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.resetCard()
                    self.UserCard.center = CGPoint(x: self.UserCard.center.x + 350, y: self.UserCard.center.y)
                })
                self.UserCard.removeFromSuperview()
                LikedNames.append(NickNames[data_volume - swipe_counter])
                LikedUIDs.append(UserIDs[data_volume - swipe_counter])
                LikedImages.updateValue(IconImages[data_volume - swipe_counter], forKey: UserIDs[data_volume - swipe_counter])
                LikedUserInfos.updateValue(UserIDs[data_volume - swipe_counter], forKey: NickNames[data_volume - swipe_counter])
                db.collection(GameName).document(UID!).collection("Liked").document(UserIDs[data_volume - swipe_counter]).setData(["Liked": true])
                swipe_counter += 1
                if swipe_counter > data_volume{
                    performSegue(withIdentifier: "ToMatcher", sender: (Any).self)
                    print("LikedImages: ", LikedImages)
                }
                
               /* likeimageView.alpha = 0
               
                */
                return
            }
        }
        UIView.animate(withDuration: 0.1, animations:{
            self.resetCard()
            self.UserCard.center = self.centerOfCard
            self.UserCard.transform = .identity
        })
    }
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DBから<GameName>に格納されているuserの情報をすべて取得（ゆくゆくは絞る）
        db.collection(GameName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //ドキュメント数の取得（自分の情報は除くため -1）
                self.data_volume = querySnapshot!.count - 1
                //それぞれのドキュメントの内容を取り出して処理
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.document_ID = document.documentID
                    //自分と既にマッチ済みの相手を除外
                    if self.document_ID != self.UID {
                        self.isMatched(document_ID: self.document_ID)
                        if self.IsMatch == false{
                        self.document_data = (document.data() as? Dictionary<String, String>)!
                        self.document_nickname = self.document_data["nickname"]
                        self.NickNames.append(self.document_nickname)
                        self.UserIDs.append(self.document_ID)
                //data_volume分のカードの作成
                        self.CreateUIView()
                        self.CreateIconImageView()
                        self.CreateNickNameLabel()
                        self.CreateIntroduceLabel()
                        self.IconImages.append(self.UserIconImage.image!)//エラー吐くとしたらここ
                        self.tagnum += 1
                        }
                    }else{
                        self.document_data = (document.data() as? Dictionary<String, String>)!
                        self.UserOwnNickName = self.document_data["nickname"]!
                        print ("mynickname: ", self.UserOwnNickName)
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func ToMatch(_ sender: UIButton) {
        performSegue(withIdentifier: "ToMatcher", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToMatcher"){
            let vc = segue.destination as! MatcherViewController
            vc.GameName = GameName
            vc.LikedNames = LikedNames
            vc.LikedUIDs = LikedUIDs
            vc.LikedImages = LikedImages
            vc.LikedUserInfos = LikedUserInfos
            vc.UserOwnNickName = UserOwnNickName
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
