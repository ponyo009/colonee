//
//  ChatViewController.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/23.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseUI

class ChatViewController: JSQMessagesViewController {

//MatcherViewから受け取り
    var UserOwnNickName = ""
    var GameName = ""
    var MatcherUID = ""
    //userとuseridの定義
    let user = Auth.auth().currentUser
    var UID = Auth.auth().currentUser?.uid
    //usernicknameの取得
    let db = Firestore.firestore()
    var usernickname: String!
    
    func setup() {
        self.senderId = UID
        self.senderDisplayName = UserOwnNickName
    }
    
    
    
    
    var cellNumber:Int = 0
    
    var MatcherName = String()
    
    var decodedImage = UIImage()
    var decodedImage2 = UIImage()
    
    var messages:[JSQMessage]! = [JSQMessage]()
    
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvata:JSQMessagesAvatarImage!
    var outgoingAvata:JSQMessagesAvatarImage!
    
    var backgroundImageView = UIImageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //背景画像を反映
        
        //Matcherの名前を反映させる
        self.title = MatcherName
        //チャットをスタートさせる
        chatStart()
        //情報をリアルタイムで取得する
        getInfo()
        
       //アバターなし
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    func chatStart(){
       automaticallyAdjustsScrollViewInsets = true
        /* のろせここ頼む
         Firebaseへ送信するIDと名前の設定 */
        
        if UserDefaults.standard.object(forKey: "nickname") != nil{
            self.UID = Auth.auth().currentUser?.uid
            self.usernickname = UserOwnNickName
            
        }
        

    
    // 吹き出しの設定
     let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(
            with: UIColor.gray)
        
        self.outgoingBubble = bubbleFactory?.incomingMessagesBubbleImage(
                with: UIColor.blue)
        
        self.incomingAvata = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: decodedImage2, diameter: 64)
        self.outgoingAvata =
            JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: decodedImage, diameter: 64)
        
    //メッセージ配列の初期化
        self.messages = []
    
}
    
    func getInfo(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
       
        let chatref = db.collection(GameName).document(UID!).collection("Liked").document(MatcherUID).collection("Chat")
        //リアルタイム更新用
       
        chatref.addSnapshotListener {(snapshot, error) in
            guard let chat_value = snapshot else {
                print ("snapshot is nil")
                return
            }
            chat_value.documentChanges.forEach { change in
                //更新内容が追加だったとき
                if change.type == .added {
                    //追加されたデータを表示
                    let chatData = change.document.data() as Dictionary
                    let body = chatData["body"] as! String
                    let senderId = chatData["userID"] as! String
                    let nickname = chatData["nickname"] as! String
                    let message =  JSQMessage(senderId:senderId,displayName: nickname,text: body)
                    self.messages.append(message!)
                    self.finishReceivingMessage()
                }
            }
                }
        
        
       /* firebase.observe(.childAdded, with:{
            (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                let snapshotValue = snapshot.value as! NSDictionary
                snapshotValue.setValuesForKeys(dictionary)
                let text = snapshotValue["text"] as! String
                let senderId = snapshotValue["from"] as! String
                let name = snapshotValue["name"] as! String
                let message = JSQMessage(senderId:senderId,displayName: name,text: text)
                self.messages?.append(message!)
                self.finishReceivingMessage()
                
            }
        })*/
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
}
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath as IndexPath) as? JSQMessagesCollectionViewCell
        if messages![indexPath.row].senderId == senderId {
            
        }
        return cell!
    }
    
    }
        


