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


class UserProfileViewController: SideTabContentViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

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
    var isIcon: Bool!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得
        image = info[.originalImage] as? UIImage
        // ImageViewに表示する
        if isIcon {
            self.iconImage.setImage(image, for: .normal)
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
        //imageIconの取得
        let ref = storage.reference().child(UID).child("\(gameID).jpeg")
        iconImage.imageView?.sd_setImage(with: ref)
        iconImage.setImage(self.iconImage.imageView?.image, for: .normal)
        if iconImage.imageView!.isHidden{
            let defaultImage = self.view.viewWithTag(10)
            defaultImage?.alpha = 1
            print("iconimage is nil")
        }else{}

        userID.text = UID
        user_nickname.text = UserDefaults.standard.object(forKey: "userName") as? String
        db.collection(gameID).document(UID).getDocument(){document, err  in
            self.user_introduce.text = document?.data()?["introduce"] as? String
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func iconImageBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // ライブラリから選ぶ
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            // 表示
            self.present(pickerView, animated: true)
            isIcon = true
        }
    }
    
    @IBAction func iconBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // ライブラリから選ぶ
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            // 表示
            self.present(pickerView, animated: true)
            isIcon = false
        }
    }
    
    @IBAction func editProfileBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
