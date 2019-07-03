//
//  FirstViewController.swift
//  gamies.com
//
//  Created by akira on 2019/07/03.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import TwitterKit

class FirstViewController: UIViewController {

    @IBOutlet weak var TWTRButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginBtn = TWTRLogInButton { (<#TWTRSession?#>, <#Error?#>) in
            <#code#>
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
