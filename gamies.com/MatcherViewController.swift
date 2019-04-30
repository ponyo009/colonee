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
    
    var UserOwnNickName = ""
    var GameName = UserDefaults.standard.object(forKey: "GameName") as! String
    
    
    //DB参照等
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    //マッチ判定後用
    var isMatch_count = 0
    var MatchedUIDs = [String]()
    var MatchedNames = [String]()
    var MatchTimes = [String]()
    //var Introduces = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellNumber:Int = 0
    var MatcherUID:String?
    
    var MatcherImageView = UIImageView()
    var MatcherNameLabel = UILabel()
    var MatcherIntroduce = UILabel()
    var MatchTimeSinceNow = UILabel()
    
    var MatcherName = String()
    
    //ValueによるDictionary検索用
    func findKeyForValue(value: String, dictionary: [String : String]) ->String?{
        for (key, array) in dictionary{
            if (array.contains(value)){
                return key
            }
        }
        return nil
    }
    
    func queryMatched(callback: @escaping ([QueryDocumentSnapshot]) -> ()){
        var documents: [QueryDocumentSnapshot] = []
        let matchedref = db.collection(GameName).document(UID!).collection("Liked").whereField("matched", isEqualTo: true)
        matchedref.getDocuments(){snapshot, err in
            if err == nil{
                documents = snapshot!.documents
                callback(documents)
            }else{
                print(err as Any)
            }
        }
    }
    
    func fetchImages(userID: String, callback:@escaping (UIImage) -> ()){
        //var fetchedImage = UIImage()
        let imageRef = storage.reference().child(userID).child("\((GameName)).jpeg")
        imageRef.getData(maxSize: 1*1024*1024){data, err in
            let image = UIImage(data: data!, scale: 1.0)
            print("imageview: ", image as Any)
       // print("uiimage: ", fetchedImage.image)
            callback(image!)
        }
    }
    
    func compareTime(timestamp: Timestamp, callback: (String) -> ()){
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute]
        let matchdata: Date = timestamp.dateValue()
        let span = matchdata.timeIntervalSinceNow
        callback(formatter.string(from: span * -1)!)
    }
    //プロフィール画像用
    var MatcherImage = UIImage()
    var MatcherImageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryMatched(){documents in
            for document in documents {
                self.compareTime(timestamp: document.data()["timestamp"] as! Timestamp){ time in
                    self.MatchTimes.append(time)}
                self.MatchedUIDs.append(document.documentID)
                self.MatchedNames.append(document.data()["nickname"] as! String)
                //self.Introduces.append(document.data()["introduce"] as! String)
                self.fetchImages(userID: document.documentID){fetchedimage in
                    self.MatcherImageArray.append(fetchedimage)
                    print(self.MatcherImageArray)
                    self.isMatch_count += 1
                    if self.isMatch_count >= documents.count{
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    }
                }
            }
        }
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
        //MatcherIntroduce = cell.viewWithTag(3) as! UILabel
       MatchTimeSinceNow = cell.viewWithTag(4) as! UILabel
        MatcherImageView.image = MatcherImageArray[indexPath.row]
        MatcherNameLabel.text = MatchedNames[indexPath.row]
        MatchTimeSinceNow.text = "\(MatchTimes[indexPath.row]) ago"
       // MatcherIntroduce.text = Introduces[indexPath.row]
        return cell
        
    }
    

  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellNumber = indexPath.row
        MatcherName = MatchedNames[indexPath.row]
        MatcherUID = MatchedUIDs[indexPath.row]
        MatcherImage = MatcherImageArray[indexPath.row]
        //pushで画面遷移
        performSegue(withIdentifier: "ToChat", sender: (Any).self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        
        if (segue.identifier == "ToChat"){
            
            let chatVC:JSQChatViewController = segue.destination as! JSQChatViewController
            
            //chatVC.cellNumber = cellNumber
            //chatVC.GameName = GameName
            chatVC.MatcherName = MatcherName
            chatVC.MatcherUID = MatcherUID!
           // chatVC.UserOwnNickName = UserOwnNickName
            
            
        }
        
    }
    
    
}
