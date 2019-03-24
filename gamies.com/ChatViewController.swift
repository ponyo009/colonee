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
    
    var cellNumber:Int = 0
    
    var MatcherName = String()
    
    var messages:[JSQMessage]! = [JSQMessage]()
    
    var incommigBubble :JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
