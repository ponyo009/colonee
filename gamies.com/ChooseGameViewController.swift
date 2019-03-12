//
//  ChooseGameViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class ChooseGameViewController: UIViewController {

    @IBOutlet weak var Game0: UIView!
    @IBOutlet weak var Game1: UIView!
    @IBOutlet weak var Game2: UIView!
    @IBOutlet weak var Game3: UIView!
    @IBOutlet weak var Game4: UIView!
    @IBOutlet weak var Game5: UIView!

    
    var Games = [UIView]()
    let GameNames = ["Fate Grand Order", "アイドルマスター シンデレラガールズ", "荒野行動", "モンスターストライク", "白猫プロジェクト", "Puzzle & Dragons"]
    var tagnum = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Games.append(Game0)
        Games.append(Game1)
        Games.append(Game2)
        Games.append(Game3)
        Games.append(Game4)
        Games.append(Game5)

        // Do any additional setup after loading the view.
    }
    @IBAction func ButtonTapped(_ sender: UIButton) {
         tagnum = sender.tag
        performSegue(withIdentifier: "ToProfile", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToProfile" ){
            let vc = segue.destination as! ProfileViewController
            vc.GameName = GameNames[tagnum]
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

