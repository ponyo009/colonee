//
//  MatcherViewController.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/23.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MatcherViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var callNumber:Int = 0
    
    var MatcherImageView = UIImageView()
    var MatcherNameLabel = UILabel()
    
    var MatcherName = String()
    
    var MatcherImageArray =
        ["mai.jpeg"]
    
    var MatcherNameArray = ["まい"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
    
    }
    
    
    //デリゲートメソッド(TableView)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatcherNameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        MatcherImageView = cell.viewWithTag(1) as! UIImageView
        
        MatcherNameLabel =
            cell.viewWithTag(2) as!
            UILabel
        
        MatcherImageView.image = UIImage(named: MatcherImageArray[indexPath.row])
        
        MatcherNameLabel.text = MatcherNameArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        callNumber = indexPath.row
        MatcherName = MatcherNameArray[indexPath.row]
        
        //pushで画面遷移
        
        performSegue(withIdentifier: "chat", sender: nil)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        
        if (segue.identifier == "chat"){
            
            let chatVC:ChatViewController = segue.destination as! ChatViewController
            
            chatVC.callNumber = callNumber
            chatVC.MatcherName = MatcherName
            
            
        }
        
    }
    
    
}
