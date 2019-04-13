//
//  JSQChatViewController.swift
//  gamies.com
//
//  Created by akira on 2019/04/13.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseUI

class JSQChatViewController: JSQMessagesViewController {

    //MatcherViewから受け取り
    var UserOwnNickName = ""
    var GameName = ""
    var MatcherUID = ""
    var MatcherName = ""
    
    //firebase関連
    let user = Auth.auth().currentUser
    var UID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var chatref: CollectionReference!
    
    //chat関連
    var messages: [JSQMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderDisplayName = UserOwnNickName
        senderId = UID
        
        chatref = db.collection(GameName).document(UID!).collection("Liked").document(MatcherUID).collection("Chat")
        
        chatref.addSnapshotListener{(snapshot, err) in
            guard let chat_value = snapshot else {
                print ("snapshot is nil")
                return
            }
            chat_value.documentChanges.forEach { change in
                if change.type == .added{
                    //追加されたデータを表示
                    let chatData = change.document.data() as Dictionary
                    let body = chatData["body"] as! String
                    let senderId = chatData["senderId"] as! String
                    let displayname = chatData["displayname"] as! String
                    let message =  JSQMessage(senderId: senderId, displayName: displayname, text: body)
                    self.messages.append(message!)
                    self.finishReceivingMessage()
                }
            }
        }
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }

     // コメントの背景色の指定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory()?.outgoingMessagesBubbleImage(with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        }else{
            return JSQMessagesBubbleImageFactory()?.incomingMessagesBubbleImage(with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
    }
    
     // コメントの文字色の指定
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if messages[indexPath.row].senderId == senderId {
            cell.textView.textColor = UIColor.white
        }else{
            cell.textView.textColor = UIColor.darkGray
        }
        return cell
    }
    
    //コメント数のカウント
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // ユーザのアバターの設定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(
            withUserInitials: messages[indexPath.row].senderDisplayName,
            backgroundColor: UIColor.darkGray,
            textColor: UIColor.white,
            font: UIFont.systemFont(ofSize: 10),
            diameter: 30)
    }
    
    //sendボタンが押された際
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        inputToolbar.contentView.textView.text = ""
        chatref.addDocument(data: ["senderId": senderId, "body": text, "displayname": senderDisplayName])
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
