//
//  ProfileEditViewController.swift
//  gamies.com
//
//  Created by akira on 2019/07/06.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController {

    @IBOutlet weak var editTagBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editTagBtn.layer.borderWidth = 1.0
        editTagBtn.layer.borderColor = UIColor.darkGray.cgColor
        editTagBtn.layer.cornerRadius = 3.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editFinishBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func editTagBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "toEditTag", sender: self)
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
