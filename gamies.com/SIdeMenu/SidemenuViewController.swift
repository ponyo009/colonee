//
//  SidemenuViewController.swift
//  gamies.com
//
//  Created by akira on 2019/05/14.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SidemenuViewController: UIViewController {

   
    @IBOutlet weak var SideMenuCollectionView: UICollectionView!
    
    let cellidentifier = "sidemenucell"
    var currentActivNav: UINavigationController?
    
    var gameCount = 0
    var gameIcon = UIImage()
    var GameName = UserDefaults.standard.object(forKey: "GameName") as! String
    var gameID = UserDefaults.standard.object(forKey: "gameID") as! String
    let gameref = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("Games")
    
    var imageArray = [UIImage]()
    var gameIDs = [String]()
    var cellcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初期化
        gameIcon = UIImage()
        imageArray = [UIImage]()
        gameIDs = [String]()
        
        gameref.getDocuments { (snapshot, err) in
            let documents = snapshot?.documents
            for document in documents! {
                let iconName = document.documentID
                self.gameIDs.append(iconName)
                self.imageArray.append(UIImage(named: iconName)!)
                //gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellidentifier)
                self.SideMenuCollectionView.dataSource = self
                self.SideMenuCollectionView.delegate = self
                self.SideMenuCollectionView.reloadData()
            }
        }
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
        return imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath)
        
        let gameimage = cell.viewWithTag(1) as! UIImageView
        if cellcount == imageArray.count{
            gameimage.image = UIImage(named: "gamies")
            cell.tag = 1
        }else{
             gameimage.image = imageArray[indexPath.row]
        }
        cellcount += 1
        return cell
    }
}

extension SidemenuViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        if cell!.tag == 1 {
            performSegue(withIdentifier: "toChoose", sender: (Any).self)
        }else{
            UserDefaults.standard.set(gameIDs[indexPath.row], forKey: "gameID")
            performSegue(withIdentifier: "toMain", sender: (Any).self)
        }
        //if let currentActivNav = self.currentActivNav,
                /*
            let mainVC = self.parent as? MainSideTabViewController {
            mainVC.hideSideMenu()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ChooseGameViewController")
            currentActivNav.pushViewController(profileVC, animated: true)
        */
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
