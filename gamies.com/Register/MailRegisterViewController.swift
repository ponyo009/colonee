//
//  MailRegisterViewController.swift
//  gamies.com
//
//  Created by akira on 2019/07/03.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class MailRegisterViewController: UIViewController {

    @IBOutlet weak var mailAddress: UITextField!
    var mail = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ButtonTapped(_ sender: Any) {
        mail = mailAddress.text!
        performSegue(withIdentifier: "Next", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! PasswordRegisterViewController
        next.mail = mail
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
