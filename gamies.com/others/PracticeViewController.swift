//
//  PracticeViewController.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/26.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

extension Array where Element: Equatable {
    typealias E = Element
    
    func subtracting(_ other: [E]) -> [E] {
        return self.flatMap { element in
            if (other.filter { $0 == element }).count == 0 {
                return element
            } else {
                return nil
            }
        }
    }
    
    mutating func subtract(_ other: [E]) {
        self = subtracting(other)
    }
}

class PracticeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dispatchGroup = DispatchGroup()
    let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)

    let UID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    var gameIDs = [String]()
    var gameNames = [String]()
    var userGameIDs = [String]()
    var userGameNames = [String]()
    var diffGameIDs = [String]()
    var diffGameNames = [String]()
    var gameForCells = [DictionaryLiteral<Any, Any>]()
    
    let cellidentifier = "choosegamecell"
    var gameicon: UIImageView!
    
    
    func fetchAllgames () {
        let ref = db.collection("Games")
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            [weak self] in
            ref.getDocuments { (documents, err) in
                //print("start1")
                let documents = documents?.documents
                for document in documents! {
                    self!.gameIDs.append(document.documentID)
                    self!.gameNames.append(document.data()["title"] as! String)
                }
                //print("finished1")
                self!.dispatchGroup.leave()
            }
        }
    }
    
    func fetchUserGames() {
        let ref = db.collection("users").document(UID!).collection("Games")
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            [weak self] in
            ref.getDocuments { (documents, err) in
                //print("start2")
                let documents = documents?.documents
                for document in documents! {
                    self!.userGameNames.append(document.data()["title"] as! String)
                    self!.userGameIDs.append(document.documentID)
                    self!.gameForCells.append([document.documentID: 1])
                }
                //print("finished2")
                self!.dispatchGroup.leave()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllgames()
        fetchUserGames()
        
        dispatchGroup.notify(queue: .main){
            self.diffGameIDs = self.gameIDs.subtracting(self.userGameIDs)
            self.diffGameNames = self.gameNames.subtracting(self.userGameNames)
            for game in self.diffGameIDs {
                self.gameForCells.append([game: 2])
            }
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
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

extension PracticeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath)
        let gameForCell = gameForCells[indexPath.row]
        let gameId = gameForCell[0].key as! String
        let gameTag = gameForCell[0].value as! Int
       
        gameicon = cell.viewWithTag(1) as? UIImageView
        gameicon.image = UIImage(named: gameId)
        cell.tag = gameTag
        
        return cell
    }
}

extension PracticeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
