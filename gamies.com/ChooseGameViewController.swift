//
//  ChooseGameViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseUI

class ChooseGameViewController: UIViewController {

    @IBOutlet weak var Game0: UIView!
    @IBOutlet weak var Game1: UIView!
    @IBOutlet weak var Game2: UIView!
    @IBOutlet weak var Game3: UIView!
    @IBOutlet weak var Game4: UIView!
    @IBOutlet weak var Game5: UIView!

    
    let db = Firestore.firestore()
    let GameNames = ["Fate Grand Order", "アイドルマスター シンデレラガールズ", "荒野行動", "モンスターストライク", "白猫プロジェクト", "Puzzle & Dragons"]
    var tagnum = Int()
    var objId = String()
    let user = Auth.auth().currentUser
    var docID: String!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func ButtonTapped(_ sender: UIButton) {
        
        tagnum = sender.tag
        var ref: DocumentReference!
        
        ref = db.collection("games").addDocument(data: [
            "gamename": GameNames[tagnum],
            "UID": user?.uid as Any
            ])
        
       
        
        //ref = db.collection("users").document(docID).collection("Games").addDocument(data:[
          //  "gamename": GameNames[tagnum]]
           // )
        
       
        print("GameName Saved")
        
        performSegue(withIdentifier: "ToProfile", sender: (Any).self)

            
       
    }
    
    //選択されたゲーム名とそのobjectidを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToProfile" ){
            let vc = segue.destination as! ProfileViewController
            vc.GameName = GameNames[tagnum]
            let id = segue.destination as! ProfileViewController
            id.objId = objId
    }

}
}

    
    
    
    
    
    
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

