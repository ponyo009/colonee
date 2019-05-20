//
//  CollectionViewController.swift
//  gamies.com
//
//  Created by akira on 2019/05/08.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class CollectionViewController: SideTabContentViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var CollectionView: UICollectionView!
    
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
        var cellNumber:Int = 0
        var SelectedUID:String?
        
        var MatcherImageView = UIImageView()
        var MatcherNameLabel = UILabel()
        var MatcherIntroduce = UILabel()
        var MatchTimeSinceNow = UILabel()
        
        var SelectedName = String()
        var SelectedImage = UIImage()
        var MatcherImageArray = [UIImage]()
    
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
        var image = UIImage(named: "default")
        let imageRef = storage.reference().child(userID).child("\((GameName)).jpeg")
        imageRef.getData(maxSize: 1*1024*1024){data, err in
            if data != nil {
                image = UIImage(data: data!, scale: 0.1)
                print("imageview: ", image as Any)
                // print("uiimage: ", fetchedImage.image)
                callback(image!)
            }else{
                callback(image!)
            }
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
            
            //CollectionView.register(UINib(nibName: "name", bundle: nil), forCellWithReuseIdentifier: "Cell")
            
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
                            self.CollectionView.delegate = self
                            self.CollectionView.dataSource = self
                            self.CollectionView.reloadData()
                        }
                    }
                }
            }
            
            
            // Do any additional setup after loading the view.
        }
    
     // MARK: UICollectionViewDelegate
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of items
            return MatchedNames.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
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
            // Configure the cell
            return cell
        }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
           // collectionView.viewWithTag(<#T##tag: Int##Int#>)
        
            cellNumber = indexPath.row
            SelectedName = MatchedNames[indexPath.row]
            SelectedUID = MatchedUIDs[indexPath.row]
            SelectedImage = MatcherImageArray[indexPath.row]
            
            let ref = db.collection(GameName).document(UID!).collection("Matched").document(SelectedUID!)
            ref.setData(["checked": true], merge: true)
            IsChecked[indexPath.row] = true
            
            //SideMenuが表示されていた場合、隠す。
            let MainVC = self.tabBarController?.parent as? MainSideTabViewController
            if (MainVC?.menuVisible)! {
            MainVC?.toggleSideMenu(fromVIewController: self)
            }
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
        
      override  func viewDidDisappear(_ animated: Bool) {
            CollectionView.reloadData()
        }
        /*
         // Uncomment this method to specify if the specified item should be highlighted during tracking
         override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment this method to specify if the specified item should be selected
         override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
         override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
         
         }
         */
        
    }

