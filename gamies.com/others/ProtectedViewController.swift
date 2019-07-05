//
//  ProtectedViewController.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class ProtectedViewController: UIViewController {
    
    
    let userdefaults_email = UserDefaults.standard.object(forKey: "userEmail")
    let userdefaults_pass = UserDefaults.standard.object(forKey: "userPassword")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userdefaults_pass != nil || userdefaults_email != nil {
             self.performSegue(withIdentifier: "Login", sender: self)
        }else{
            self.performSegue(withIdentifier: "First", sender: self)
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
