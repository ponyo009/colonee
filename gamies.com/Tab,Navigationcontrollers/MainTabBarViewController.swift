//
//  TabBarViewController.swift
//  gamies.com
//
//  Created by akira on 2019/04/29.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    
    var nickname = ""
    var introduce = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        for viewController in viewControllers! {
            if let ProfileNavController = viewController as? ProfileNavController {
                if let UserProfileVC = ProfileNavController.viewControllers.first as? UserProfileViewController {
                    UserProfileVC.nickname = nickname
                    UserProfileVC.introduce = introduce
                }
            }
        }
        // Do any additional setup after loading the view..
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
