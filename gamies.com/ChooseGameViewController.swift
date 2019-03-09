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
    
    @IBAction func button0(_ sender: Any) {
        let GameNumber = Games.index(of: Game0)
        print(GameNumber)
    }
    
    @IBAction func button1(_ sender: Any) {
        
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
