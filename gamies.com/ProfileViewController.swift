//
//  ProfileViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/10.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var gamename: UILabel!
    var GameName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamename.text = GameName

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
