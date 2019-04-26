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
    var data_volume = 0
    var swipe_counter = 1
    
    //ユーザーカード位置（レスポンシブにしたい）
    var cardFrame = CGRect(x:16, y:73, width:350, height:370)
    let iconImageFrame = CGRect(x:51, y:29, width:240, height:128)
    let usernicknameframe = CGRect(x:8, y:165, width:320, height:41)
    let userintroductionframe = CGRect(x:8, y:214, width:320, height:167)
    
    //ユーザーカード
    var UserCard: UIView!
    var UserIconImage = UIImageView()
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
    func CreateIconImageView(document_id: String, callback: (UIImage) -> ()) {
        UserIconImage = UIImageView(frame:self.iconImageFrame )
        let storageref = storage.reference().child(document_id).child(GameName)
        UserIconImage.sd_setImage(with: storageref)
        UserIconImage.tag = tagnum
        print(UserIconImage)//入ってる
        print(UserIconImage.image)//なぜかnil
        callback(UserIconImage.image!)
        UserCard.addSubview(UserIconImage)
    }
    //nicknameラベル
    func CreateNickNameLabel(nickname: String){
        var userNickName = UILabel.init(frame: usernicknameframe)
        userNickName.tag = tagnum
        userNickName.backgroundColor = UIColor.white
       //特定のtagnumのUILabelを指定
        UserCard.addSubview(userNickName)
        userNickName = userNickName.viewWithTag(tagnum) as! UILabel
        userNickName.text = nickname
    }
    
    
    //introduceラベル
    func CreateIntroduceLabel(introduce: String){
        var userIntroduction = UILabel.init(frame: userintroductionframe)
        userIntroduction.tag = tagnum
        userIntroduction.backgroundColor = UIColor.white
        UserCard.addSubview(userIntroduction)
        userIntroduction = userIntroduction.viewWithTag(tagnum) as! UILabel
        userIntroduction.text = introduce
    }
    //Usercardを元の位置に
    func resetCard() {
        UserCard.center = self.centerOfCard
        UserCard.transform = .identity
    }
    
    //
    func getAllDocuments(callback:@escaping (QuerySnapshot) -> ()){
        db.collection(GameName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                callback(querySnapshot!)
            }
        }
    }
    //スワイプ済みの相手を除外
    func isSwiped(document_id: String, callback: @escaping (Bool) -> ()){
        var isSwiped: Bool!
        let islikedref = db.collection(GameName).document(UID!).collection("Liked").document(document_id)
        islikedref.getDocument{(document, error) in
            if document!.exists  {
                print("This User(\(document_id)) is already Swiped")
                isSwiped = true
                callback(isSwiped)
            }else if document_id != self.UID{
                isSwiped = false
                self.data_volume += 1
                callback(isSwiped)
            }
        }
    }
    
    func createUserCard(document_id: String, nickname:String, introduce:String, isSwiped:Bool){
        if document_id != UID && isSwiped == false{
            CreateUIView()
            CreateIconImageView(document_id: document_id){image in
                IconImages.append(image)}
            CreateNickNameLabel(nickname: nickname)
            CreateIntroduceLabel(introduce: introduce)
            self.tagnum += 1
        }else if document_id == UID{
            self.UserOwnNickName = nickname
            print ("mynickname: ", self.UserOwnNickName)
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
        
        getAllDocuments(){snapshot in
            let documents = snapshot.documents
            for document in documents{
                self.isSwiped(document_id: document.documentID){isSwiped in
                    self.createUserCard(document_id: document.documentID, nickname: document.data()["nickname"] as! String, introduce: document.data()["introduce"] as! String, isSwiped: isSwiped)
                }
            }
        }
        
        // DBから<GameName>に格納されているuserの情報をすべて取得（ゆくゆくは絞る）
     /*   db.collection(GameName).getDocuments() { (querySnapshot, err) in
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
        } */
        
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
