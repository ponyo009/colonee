//
//  MatcherViewController.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/23.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI



class MatcherViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    let UID = Auth.auth().currentUser?.uid
    
    //SwipeViewから受け取り
    var GameName = ""
    var LikedNames = [String]()
    var LikedUIDs = [String]()
    var LikedUserInfos: [String:String] = [ : ]
    
    //DB参照等
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    //マッチ判定後用
    var isMatch_count = 0
    var MatchedUIDs = [String]()
    var MatchedNames = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellNumber:Int = 0
    
    var MatcherImageView = UIImageView()
    var MatcherNameLabel = UILabel()
    
    var MatcherName = String()
    
    //Dictionary検索用
    func findKeyForValue(value: String, dictionary: [String : String]) ->String?{
        for (key, array) in dictionary{
            if (array.contains(value)){
                return key
            }
        }
        return nil
    }
    
    //var MatcherImageArray =
        //["mai.jpeg","sumire.jpeg"]
    
    //プロフィール画像用
    var MatcherImage = UIImageView()
    var MatcherImageArray: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //マッチング処理
        print ("LikedUIDs", LikedUIDs)
        print ("LikedNames", LikedNames)
        
        for LikedUID in LikedUIDs {
            print ("LikedUID: ", LikedUID)
        //GameNameから、LikedUIDsの"Liked"に自分のID(UID)が存在する(exists)かどうか検索
            let storageref = storage.reference().child(LikedUID).child(GameName)
            let placeholderimage = UIImage(named: GameName)
            let likedref = db.collection(GameName).document(LikedUID).collection("Liked").document(UID!)
            likedref.getDocument{ (document, error) in
                if let document = document, document.exists{
                //存在した場合
                    print ("yes_counter: ", self.isMatch_count)
                    self.MatcherImage.sd_setImage(with: storageref, placeholderImage: placeholderimage)
                    self.MatchedUIDs.append(LikedUID)
                    self.MatchedNames.append(self.findKeyForValue(value: LikedUID, dictionary: self.LikedUserInfos)!)
                    self.MatcherImageArray.append(self.MatcherImage)
                    print("MatchedUIDs: ", self.MatchedUIDs)
                    print("MatchedNames: ", self.MatchedNames)
                    self.isMatch_count += 1
                } else {
                    //存在しない場合
                    print ("not_counter: ", self.isMatch_count)
                    print ("LikedName ",self.findKeyForValue(value: LikedUID, dictionary: self.LikedUserInfos)!,"didn't match")
                    self.isMatch_count += 1
                }
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        print("ImageArray: ", MatcherImageArray)
        //print(LikedNames)
        //print(LikedUIDs)
        
    
    
    }
    
    
    //デリゲートメソッド(TableView)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchedNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        MatcherImageView = cell.viewWithTag(1) as! UIImageView
        
        MatcherNameLabel = cell.viewWithTag(2) as! UILabel
        
        MatcherImageView = MatcherImageArray[indexPath.row]
        
        MatcherNameLabel.text = MatchedNames[indexPath.row]
        print ("matcheernamelabel.text: ", MatcherNameLabel.text)
        return cell
        
    }
    

  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(MatcherNameLabel.text)
        
        cellNumber = indexPath.row
        MatcherName = MatchedNames[indexPath.row]
        
        //pushで画面遷移
        
        performSegue(withIdentifier: "ToChat", sender: (Any).self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        
        if (segue.identifier == "ToChat"){
            
            let chatVC:ChatViewController = segue.destination as! ChatViewController
            
            chatVC.cellNumber = cellNumber
            chatVC.GameName = GameName
            chatVC.MatcherName = MatcherName
            
            
        }
        
    }
    
    
}
