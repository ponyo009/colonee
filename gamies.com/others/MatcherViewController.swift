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



class MatcherViewController:SideTabContentViewController, UITableViewDelegate, UITableViewDataSource {

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
    var IsChecked = [Bool]()
    //var Introduces = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellNumber:Int = 0
    var SelectedUID:String?
    
    var MatcherImageView = UIImageView()
    var MatcherNameLabel = UILabel()
    var MatcherIntroduce = UILabel()
    var MatchTimeSinceNow = UILabel()
    
    var SelectedName = String()
    var SelectedImage = UIImage()
    var MatcherImageArray = [UIImage]()
    
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
        let matchedref = db.collection(GameName).document(UID!).collection("Matched")
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
            let image = UIImage(data: data!, scale: 0.1)
            print("imageview: ", image as Any)
       // print("uiimage: ", fetchedImage.image)
            callback(image!)
        }
    }
    
    func compareTime(timestamp: Timestamp, callback: (String) -> ()){
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour]
        let matchdata: Date = timestamp.dateValue()
        let span = matchdata.timeIntervalSinceNow
        callback(formatter.string(from: span * -1)!)
    }
    
    func appendData(document: QueryDocumentSnapshot){
        MatchedUIDs.append(document.documentID)
        MatchedNames.append(document.data()["nickname"] as! String)
        IsChecked.append(document.data()["checked"] as! Bool)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryMatched(){documents in
            for document in documents {
                self.compareTime(timestamp: document.data()["timestamp"] as! Timestamp){ time in
                    self.MatchTimes.append(time)}
                self.appendData(document: document)
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
        if IsChecked[indexPath.row] == true{
            cell.backgroundColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor.cyan
        }
       // MatcherIntroduce.text = Introduces[indexPath.row]
        return cell
        
    }
    

  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellNumber = indexPath.row
        SelectedName = MatchedNames[indexPath.row]
        SelectedUID = MatchedUIDs[indexPath.row]
        SelectedImage = MatcherImageArray[indexPath.row]
        
        let ref = db.collection(GameName).document(UID!).collection("Liked").document(SelectedUID!)
        ref.setData(["checked": true], merge: true)
        IsChecked[indexPath.row] = true
        //pushで画面遷移
        performSegue(withIdentifier: "ToChat", sender: (Any).self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        
        if (segue.identifier == "ToChat"){
            
            let chatVC:JSQChatViewController = segue.destination as! JSQChatViewController
            
            //chatVC.cellNumber = cellNumber
            //chatVC.GameName = GameName
            chatVC.MatcherName = SelectedName
            chatVC.MatcherUID = SelectedUID!
           // chatVC.UserOwnNickName = UserOwnNickName
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableView.reloadData()
    }
}
