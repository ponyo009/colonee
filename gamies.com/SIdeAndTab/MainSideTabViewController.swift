//
//  MainSideTabViewController.swift
//  gamies.com
//
//  Created by akira on 2019/05/10.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class MainSideTabViewController: UIViewController {

    @IBOutlet weak var SIdeMenuContainer: UIView!
    @IBOutlet weak var MainContentViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuViewLeadingConstraint: NSLayoutConstraint!
    
    var menuVisible = false
    
    @objc func toggleSideMenu(fromVIewController: UIViewController){
        if menuVisible {
            UIView.animate(withDuration: 0.3, animations: {
                // hide the side menu to the left
                self.sideMenuViewLeadingConstraint.constant = 0 - self.SIdeMenuContainer.frame.size.width
                // move the content view (tab bar controller) to original position
                self.MainContentViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
                })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                // move the side menu to the right to show it
                self.sideMenuViewLeadingConstraint.constant = 0
                // move the content view (tab bar controller) to the right
                self.MainContentViewLeadingConstraint.constant = 0 + self.SIdeMenuContainer.frame.size.width
                self.view.layoutIfNeeded()
            })
        }
        menuVisible = !menuVisible
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuViewLeadingConstraint.constant = 0 - self.SIdeMenuContainer.frame.size.width
        
        
        
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
