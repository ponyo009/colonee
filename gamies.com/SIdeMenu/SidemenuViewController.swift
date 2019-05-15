//
//  SidemenuViewController.swift
//  gamies.com
//
//  Created by akira on 2019/05/14.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class SidemenuViewController: UIViewController {

    @IBOutlet weak var gamename: UILabel!
    @IBOutlet weak var gameTableView: UITableView!
    let cellidentifier = "sidemenucell"
    var currentActivNav: UINavigationController?
    
    var gameCount = 0
    var gameIcon = UIImage()
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gameIcon)
        gamename.text = UserDefaults.standard.object(forKey: "GameName") as? String
        imageArray.append(UIImage(named: "荒野行動")!)
        //gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellidentifier)
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.reloadData()
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

extension SidemenuViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath)
        
        let gameimage = cell.viewWithTag(1) as! UIImageView
        gameimage.image = imageArray[indexPath.row]
       
        return cell
    }
}

extension SidemenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let currentActiveNav = self.currentActivNav,
            let mainVC = self.parent as? MainSideTabViewController {
            mainVC.hideSideMenu()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ChooseGameViewController")
            currentActiveNav.pushViewController(profileVC, animated: true)
        }
    }
}
/*
extension SidemenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        //return gameCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath)
        gameIcon = cell.viewWithTag(1) as? UIImageView
        gameIcon?.image = UIImage(named: "default")
        return cell
    }
}

extension SidemenuViewController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentActivNav = self.currentActivNav {
            let mainVC = self.parent as? MainSideTabViewController
            mainVC?.hideSideMenu()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gameChooseVC = storyboard.instantiateViewController(withIdentifier: "ChooseGame")
            currentActivNav.pushViewController(gameChooseVC, animated: true)
        }
    }
}
*/
