//
//  SideTabContentViewController.swift
//  gamies.com
//
//  Created by akira on 2019/05/10.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class SideTabContentViewController: UIViewController {

    let ProfileButton = UIButton(type: .custom)
    var imagename = UserDefaults.standard.object(forKey: "GameName") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ProfileButton.setImage(UIImage(named: "three"), for: .normal)
        ProfileButton.contentMode = .scaleAspectFit
        ProfileButton.translatesAutoresizingMaskIntoConstraints = false
        
        // function performed when the button is tapped
        ProfileButton.addTarget(self, action: #selector(ProfileButtonTapped(_:)), for: .touchUpInside)
        
         // Add the profile button as the left bar button of the navigation bar
        let barbutton = UIBarButtonItem(customView: ProfileButton)
        self.navigationItem.leftBarButtonItem = barbutton
        
        // Set the width and height for the profile button
        NSLayoutConstraint.activate([
            ProfileButton.widthAnchor.constraint(equalToConstant: 35.0),
            ProfileButton.heightAnchor.constraint(equalToConstant: 35.0)
            ])
        
         // Make the profile button become circular
        ProfileButton.layer.cornerRadius = 35.0 / 2
        ProfileButton.clipsToBounds = true
    }
    
    @IBAction func ProfileButtonTapped (_ sender: Any) {
        // current view controller (self) is embed in navigation controller which is embed in tab bar controller
        // .parent means the view controller that has the container view (ie. MainSiswTabViewController)
        if let mainVC = self.navigationController?.tabBarController?.parent as? MainSideTabViewController {
            mainVC.toggleSideMenu(fromVIewController: self)
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

}
