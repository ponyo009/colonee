//
//  UserProfileViewController.swift
//  gamies.com
//
//  Created by akira on 2019/03/21.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseDatabase


class UserProfileViewController: SideTabContentViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var ProfileTags: UICollectionView!
    @IBOutlet weak var user_nickname: UILabel!
    @IBOutlet weak var user_introduce: UITextView!
    @IBOutlet weak var iconImage: UIButton!
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let storage = Storage.storage()

    let GameName = UserDefaults.standard.object(forKey: "GameName") as! String
    let gameID =  UserDefaults.standard.object(forKey: "gameID") as! String
    var image: UIImage!
    //pickerView分岐用
    var isIcon: Bool!
    //値渡し用
    var isIconImage: Bool!
    var isIconBtn: Bool!
    
    var tags: [String]!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得
        image = info[.originalImage] as? UIImage
        // ImageViewに表示する
        if isIcon {
            self.iconImage.setImage(image, for: .normal)
            let defaultImage = self.view.viewWithTag(10)
            defaultImage?.alpha = 0
        }else{
            self.iconBtn.setImage(image, for: .normal)
        }
        // 写真を選ぶビューを消す
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let UID = user!.uid

        //print("GameName@Profile: ", GameName)
        //imageの初期化
//        iconImage.setImage(UIImage(named: "default.png"), for: .normal)
//        iconBtn.setImage(UIImage(named: "register_logo"), for: .normal)
        //プローフィル編集ボタン描画
        editProfile.layer.borderWidth = 1.0
        editProfile.layer.borderColor = UIColor.black.cgColor
        editProfile.layer.cornerRadius = 3.0
        //iconBtn描画
        iconBtn.layer.cornerRadius = 35.0 / 2
        iconBtn.clipsToBounds = true
        iconImage.clipsToBounds = true
        //imageIconの取得
       fetchIconImage(UID: UID)
        //IconBtnの取得
        fetchIcon(UID: UID)
        
        userID.text = UID
        user_nickname.text = user?.displayName
        db.collection(gameID).document(UID).getDocument(){document, err  in
            self.tags = document?.data()?["tag"] as? [String]
            self.user_introduce.text = document?.data()?["introduce"] as? String
        }
        // Do any additional setup after loading the view.
    }
    
    func fetchIconImage(UID:String) {
        let ref = storage.reference().child(UID).child("Image_\(gameID).jpeg")
        iconImage.imageView?.sd_setImage(with: ref)
        iconImage.setImage(self.iconImage.imageView?.image, for: .normal)
        if iconImage.imageView!.isHidden{
            let defaultImage = self.view.viewWithTag(10)
            defaultImage?.alpha = 1
            isIconImage = false
        }else{}
    }
    
    func fetchIcon(UID:String){
        let ref = storage.reference().child(UID).child("Icon_\(gameID).jpeg")
        iconBtn.imageView?.sd_setImage(with: ref)
        iconBtn.setImage(self.iconBtn.imageView?.image, for: .normal)
        if iconBtn.imageView!.isHidden{
            iconBtn.setImage(UIImage(named: "icon_default"), for: .normal)
            print("iconBtn:",iconBtn)
            isIconBtn = false
        }else{}
    }
    
    @IBAction func iconImageBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            isIcon = true
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // ライブラリから選ぶ
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            // 表示
            self.present(pickerView, animated: true)
        }
    }
    
    @IBAction func iconBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            isIcon = false
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // ライブラリから選ぶ
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            // 表示
            self.present(pickerView, animated: true)
        }
    }
    
    @IBAction func editProfileBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    // MARK: - Navigation
    @IBAction func plusBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            isIcon = true
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // ライブラリから選ぶ
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            // 表示
            self.present(pickerView, animated: true)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let nextVC = segue.destination as! ProfileEditViewController
        nextVC.passedIntroduce = self.user_introduce.text
        if isIconImage && isIconBtn {
            nextVC.passedIconImage = self.iconImage.imageView!.image!
            nextVC.passedProfileImage = self.iconBtn.imageView!.image!
        }else if isIconImage{
            nextVC.passedIconImage = self.iconImage.imageView!.image!
        }else if isIconBtn{
            nextVC.passedProfileImage = self.iconBtn.imageView!.image!
        }else{}
       
        // Pass the selected object to the new view controller.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let tag = cell.viewWithTag(11) as! UIButton
        tag.titleLabel?.text = tags[indexPath.row]
        
        return cell
    }
}

