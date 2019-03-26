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
    
    func setup() {
        self.senderId = "1234"
        self.senderDisplayName = "TEST"
    }
    
    let userID = Auth.auth().currentUser?.uid
    
    var cellNumber:Int = 0
    
    var MatcherName = String()
    
    var messages:[JSQMessage]! = [JSQMessage]()
    
    var incommingBubble :JSQMessagesBubbleImage!
    var outcommingBubble :JSQMessagesBubbleImage!
    var incomingAvata:JSQMessagesAvatarImage!
    var outcomingAvata:JSQMessagesAvatarImage!
    
    var userNameLabelText = String()
    
    var backgroundImageView = UIImageView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        

        //背景画像を反映
        
        //チャットをスタートさせる
        
        //情報をリアルタイムで取得する
        
        
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
