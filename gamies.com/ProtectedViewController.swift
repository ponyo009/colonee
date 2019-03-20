//
//  ProtectedViewController.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class ProtectedViewController: UIViewController {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "文字ロゴ")
        
        // Image Viewに画像を設定
        imageView.image = image

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "LoginView", sender: self)
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
