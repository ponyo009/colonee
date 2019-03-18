//
//  ChooseGameViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import NCMB
class ChooseGameViewController: UIViewController {

    @IBOutlet weak var Game0: UIView!
    @IBOutlet weak var Game1: UIView!
    @IBOutlet weak var Game2: UIView!
    @IBOutlet weak var Game3: UIView!
    @IBOutlet weak var Game4: UIView!
    @IBOutlet weak var Game5: UIView!

    
    let GameNames = ["Fate Grand Order", "アイドルマスター シンデレラガールズ", "荒野行動", "モンスターストライク", "白猫プロジェクト", "Puzzle & Dragons"]
    var tagnum = Int()
    var objId = String()
    var obj = NCMBObject()
    let user = NCMBUser.current()
    
    override func viewDidLoad() {
        
        let query = NCMBQuery(className: "Userclass")
        query?.whereKey("userName", equalTo: user?.userName)
        query?.findObjectsInBackground({(objects,error) in
            if(error != nil || objects == nil){
                print(error!)
                print("Newuser")
            }else{
                //ログイン中のユーザーのobjectIdを取得
                self.objId = (self.user?.objectId)!
                print(objects!)
            }
        })
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func ButtonTapped(_ sender: UIButton) {
        tagnum = sender.tag
        
        let subobj = NCMBObject(className: "Gameclass")
        subobj?.setObject(GameNames[tagnum], forKey: "GameName")
        let GameclassObjId = subobj?.objectId
        subobj?.save(nil)
        
        let obj = NCMBObject(className: "Userclass")
        obj?.setObject(user?.userName, forKey: "userName")
        obj?.setObject(subobj, forKey: "Games")
        obj?.saveInBackground({(error) in if
            (error) != nil{
            print(error)
        }else{
            print("GameClassSaved")
            self.objId = (obj?.objectId)!
            }
        })
        
        performSegue(withIdentifier: "ToProfile", sender: (Any).self)
    }
    
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

