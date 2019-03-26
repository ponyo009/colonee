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
    
    var GameName = ""
    var document_data: Dictionary<String,String>!
    
    //ユーザーの情報を一括にまとめるためのカード素材
    let UserCard = UIView()
    let userIconImage = UIImageView()
    let usernickname = UILabel()
    let userintroduce = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DBから<GameName>に格納されているuserの情報をすべて取得
        db.collection(GameName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.document_data = document.data() as? Dictionary<String, String>
                    
                }
            }
        }
        
        // Do any additional setup after loading the view.
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
