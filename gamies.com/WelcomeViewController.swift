//
//  WelcomeViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/12.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    //自動遷移を実装したい
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 0.5秒後に実行したい処理
            self.performSegue(withIdentifier: "ChooseGame", sender: (Any).self)
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
