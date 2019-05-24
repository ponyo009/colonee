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
    var imagename = UserDefaults.standard.object(forKey: "gameID") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ProfileButton.setImage(UIImage(named: "\(imagename)"), for: .normal)
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
        
        // gesture recognizer, to detect the gesture and perform action
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // function to handle the pan gesture
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        // how much distance have user finger moved since touch start (in X and Y)
        let translation = recognizer.translation(in: self.view)
      
        // the main view controller that have two container view
        guard let MainVC = self.navigationController?.tabBarController?.parent as? MainSideTabViewController
            else{ return }
        
    // when user lift up finger / end drag
        if (recognizer.state == .ended || recognizer.state == .failed || recognizer.state == .cancelled){
            if (MainVC.menuVisible){
                 // user finger moved to left before ending drag
                if (translation.x < 0){
                    // toggle side menu (to fully hide it)
                    MainVC.toggleSideMenu(fromVIewController: self)
                }
            }else{
                // user finger moved to right and more than 100pt
                if (translation.x >= 100 ){
                    // toggle side menu (to fully show it)
                    MainVC.toggleSideMenu(fromVIewController: self)
                }else{
                    // user finger moved to right but too less
                    // hide back the side menu (with animation)
                    MainVC.view.layoutIfNeeded()
                    UIView.animate(withDuration: 0.3) {
                        MainVC.sideMenuViewLeadingConstraint.constant = 0 - MainVC.SIdeMenuContainer.frame.size.width
                        MainVC.MainContentViewLeadingConstraint.constant = 0
                        MainVC.view.layoutIfNeeded()
                    }
                }
            }
            // early return so code below won't get executed
            return
        }
        // if side menu is not visisble
        // and user finger move to right
        // and the distance moved is smaller than the side menu's width
        if(!MainVC.menuVisible && translation.x > 0.0 && translation.x <= MainVC.SIdeMenuContainer.frame.size.width){
            // move the side menu to the right
            MainVC.sideMenuViewLeadingConstraint.constant = 0 - MainVC.SIdeMenuContainer.frame.size.width + translation.x
            
            // move the tab bar controller to the right
            MainVC.MainContentViewLeadingConstraint.constant = 0 + translation.x
        }
            
            // if the side menu is visible
            // and user finger move to left
            // and the distance moved is smaller than the side menu's width
        if(MainVC.menuVisible && translation.x >= 0 - MainVC.SIdeMenuContainer.frame.size.width && translation.x < 0.0){
            // move the side menu to the left
            MainVC.sideMenuViewLeadingConstraint.constant = 0 + translation.x
                
            // move the tab bar controller to the left
            MainVC.MainContentViewLeadingConstraint.constant = MainVC.SIdeMenuContainer.frame.size.width + translation.x
        }
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
