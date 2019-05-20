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

    
    
    func fetchAllgames () {
        let ref = db.collection("Games")
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            [weak self] in
            ref.getDocuments { (documents, err) in
                print("start1")
                let documents = documents?.documents
                for document in documents! {
                    self!.gameIDs.append(document.documentID)
                    self!.gameNames.append(document.data()["title"] as! String)
                }
                print("finished1")
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
                print("start2")
                let documents = documents?.documents
                for document in documents! {
                    self!.userGameNames.append(document.data()["title"] as! String)
                    self!.userGameIDs.append(document.documentID)
                }
                print("finished2")
                self!.dispatchGroup.leave()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllgames()
        fetchUserGames()
        
        dispatchGroup.notify(queue: .main){
            print(self.gameNames.subtracting(self.userGameNames))
            
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
