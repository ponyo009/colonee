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
    @IBOutlet weak var SideMenuCollectionView: UICollectionView!
    
    let cellidentifier = "sidemenucell"
    var currentActivNav: UINavigationController?
    
    var gameCount = 0
    var gameIcon = UIImage()
    let GameName = UserDefaults.standard.object(forKey: "GameName") as! String
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gameIcon)
        gamename.text = GameName
        imageArray.append(UIImage(named: GameName)!)
        //gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellidentifier)
        SideMenuCollectionView.dataSource = self
        SideMenuCollectionView.delegate = self
        SideMenuCollectionView.reloadData()
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

extension SidemenuViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath)
        
        let gameimage = cell.viewWithTag(1) as! UIImageView
        gameimage.image = imageArray[indexPath.row]
        
        return cell
    }
}

extension SidemenuViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let currentActivNav = self.currentActivNav,
            let mainVC = self.parent as? MainSideTabViewController {
            mainVC.hideSideMenu()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ChooseGameViewController")
            currentActivNav.pushViewController(profileVC, animated: true)
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
