//
//  ProfileEditViewController.swift
//  gamies.com
//
//  Created by akira on 2019/07/06.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var editTagBtn: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var mailAddress: UILabel!
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var introduce: UITextView!
    @IBOutlet weak var IconImage: UIButton!
    @IBOutlet weak var ProfileImage: UIButton!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()

    let GameID = UserDefaults.standard.object(forKey: "gameID") as! String
    var image: UIImage!
   
    //ImagePicker判定用
    var isIcon: Bool!
    
    //プロフィル更新確認用
    let preUsername = Auth.auth().currentUser?.displayName
    var passedIntroduce = String()
    var passedIconImage = UIImage()
    var passedProfileImage = UIImage()
    var iconChanged = false
    var profileImageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userName.text = user?.displayName
        mailAddress.text = user!.email
        introduce.text = passedIntroduce
        
        //Tagボタン描画
        editTagBtn.layer.borderWidth = 1.0
        editTagBtn.layer.borderColor = UIColor.darkGray.cgColor
        editTagBtn.layer.cornerRadius = 3.0
        
        //プロフィール画像描画
        IconImage.imageView?.image = passedIconImage
        ProfileImage.imageView?.image = passedProfileImage
        IconImage.clipsToBounds = true
        ProfileImage.layer.cornerRadius = 50.0 / 2
        ProfileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editFinishBtnTapped(_ sender: Any) {
        //ユーザーネームか自己紹介が更新されていた場合、アップロード
        updateProfile()
        //プロファイル画像かアイコンが更新されていた場合、アップロード
        updateImage()
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateProfile(){
        let preIntroduce = passedIntroduce
        let ref =   db.collection("\(GameID)").document("\(user!.uid)")
        let userref = db.collection("users").document(user!.uid)
        let changerequest = user?.createProfileChangeRequest()
        
        if preUsername != userName.text &&  preIntroduce != introduce.text{
            ref.setData(["introduce": introduce.text])
            userref.updateData(["username" : userName.text!])
            changerequest!.displayName = userName.text!
            changerequest?.commitChanges(completion: { (err) in
                if let err = err {
                    print("UserProfileUpdate Failed:", err)
                }else{
                    print("UserProfileUpdate Successed")
                }
            })
        }else if preUsername != userName.text{
            changerequest!.displayName = userName.text!
            changerequest?.commitChanges(completion: { (err) in
                if let err = err {
                    print("UserProfileUpdate Failed:", err)
                }else{
                    print("UserProfileUpdate Successed")
                }
            })
            userref.updateData(["username" : userName.text!])
        }else if preIntroduce != introduce.text{
            ref.setData( [ "introduce": introduce.text])
        }else{}
    }
    
    func updateImage(){
        let storageref = storage.child(user!.uid)
        
        if iconChanged && profileImageChanged {
            let iconref = storageref.child("iconImage.jpeg")
            let iconImageData = IconImage.imageView!.image!.jpegData(compressionQuality: 0.2)
            let profileimageref = storageref.child("\(GameID).jpeg")
            let profileImageData = ProfileImage.imageView!.image!.jpegData(compressionQuality: 0.2)
            
            iconref.putData(iconImageData!)
            profileimageref.putData(profileImageData!)
        }else if profileImageChanged{
            let profileimageref = storageref.child("\(GameID).jpeg")
            let profileImageData = ProfileImage.imageView!.image!.jpegData(compressionQuality: 0.2)
            profileimageref.putData(profileImageData!)
        }else if iconChanged {
            let iconref = storageref.child("iconImage.jpeg")
            let iconImageData = IconImage.imageView!.image!.jpegData(compressionQuality: 0.2)
             iconref.putData(iconImageData!)
        }else{}
    }
    
    @IBAction func editTagBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "toEditTag", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得
        image = info[.originalImage] as? UIImage
        // ImageViewに表示する
        if isIcon {
            self.IconImage.setImage(image, for: .normal)
            let defaultImage = self.view.viewWithTag(10)
            defaultImage?.alpha = 0
            iconChanged = true
        }else{
            self.ProfileImage.setImage(image, for: .normal)
            profileImageChanged = true
        }
        // 写真を選ぶビューを消す
        self.dismiss(animated: true)
    }
    
    @IBAction func ProfileImageTapped(_ sender: Any) {
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
    
    @IBAction func IconImageTapped(_ sender: Any) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
