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
    var UserOwnNickName = ""
    var GameName = ""
    var LikedNames = [String]()
    var LikedUIDs = [String]()
    var LikedImages = [UIImage]()
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
    var MatcherUID:String?
    
    var MatcherImageView = UIImageView()
    var MatcherNameLabel = UILabel()
    
    var MatcherName = String()
    
    //Dictionary(LikedUserInfos)検索用
    func findKeyForValue(value: String, dictionary: [String : String]) ->String?{
        for (key, array) in dictionary{
            if (array.contains(value)){
                return key
            }
        }
        return nil
    }
    
    //プロフィール画像用
    var MatcherImage = UIImage()
    var MatcherImageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //マッチング処理
        //print ("LikedUIDs: ", LikedUIDs)
        //print ("LikedNames: ", LikedNames)
        
        for LikedUID in LikedUIDs {
            //print ("LikedUID: ", LikedUID)
        //GameNameから、LikedUIDの"Liked"に自分のID(UID)が存在する(exists)かどうか検索
    
            //var placeholderimage = UIImage(named: GameName)
            let likedref = db.collection(GameName).document(LikedUID).collection("Liked").document(UID!)
            likedref.getDocument{ (document, error) in
                if let document = document, document.exists{
                //存在した場合
                    let matchedref = self.db.collection(self.GameName).document(self.UID!).collection("Liked").document(LikedUID)
                    matchedref.setData(["matched": true])
                    //var storageref = self.storage.reference().child(LikedUID).child(self.GameName)
                    //self.MatcherImage
                    //print("MatcherImage: ", self.MatcherImage.image)
                    self.MatchedUIDs.append(LikedUID)
                    self.MatchedNames.append(self.findKeyForValue(value: LikedUID, dictionary: self.LikedUserInfos)!)
                    self.MatcherImageArray.append(self.LikedImages[self.isMatch_count])//辞書にして紐づけないとずれる（？）
                   // print("MatchedUIDs: ", self.MatchedUIDs)
                    //print("MatchedNames: ", self.MatchedNames)
                    //print("ImageArray: ", self.MatcherImageArray)
                    self.isMatch_count += 1
                    if self.isMatch_count >= self.LikedUIDs.count{
                        //print("MatchedNames: ",self.MatchedNames)
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    }
                } else {
                    //存在しない場合
                    print (self.findKeyForValue(value: LikedUID, dictionary: self.LikedUserInfos)!,"didn't match")
                    self.isMatch_count += 1
                    if self.isMatch_count >= self.LikedUIDs.count{
                        //print("MatchedNames: ",self.MatchedNames)
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    }
                }
            }
        }
       
        
        //print(LikedNames)
        //print(LikedUIDs)
        
    
    
    }
    
    
    //デリゲートメソッド(TableView)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchedNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        MatcherImageView = cell.viewWithTag(1) as! UIImageView
        MatcherNameLabel = cell.viewWithTag(2) as! UILabel
        MatcherImageView.image = MatcherImageArray[indexPath.row]
        MatcherNameLabel.text = MatchedNames[indexPath.row]
        //print ("matcheernamelabel.text: ", MatcherNameLabel.text)
        //print ("MatcherImageView: ",MatcherImageView)
        return cell
        
    }
    

  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellNumber = indexPath.row
        MatcherName = MatchedNames[indexPath.row]
        MatcherUID = MatchedUIDs[indexPath.row]
        MatcherImage = MatcherImageArray[indexPath.row]
        //print(MatcherNameLabel.text)
        //pushで画面遷移
        performSegue(withIdentifier: "ToChat", sender: (Any).self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        
        if (segue.identifier == "ToChat"){
            
            let chatVC:ChatViewController = segue.destination as! ChatViewController
            
            chatVC.cellNumber = cellNumber
            chatVC.GameName = GameName
            chatVC.MatcherName = MatcherName
            chatVC.MatcherUID = MatcherUID!
            chatVC.UserOwnNickName = UserOwnNickName
            
            
        }
        
    }
    
    
}
