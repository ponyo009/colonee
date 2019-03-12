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
    var timer :Timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector(("changeView")), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view.
    }
    
    func changeView() {
        performSegue(withIdentifier: "ChooseGame", sender: (Any).self)
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
