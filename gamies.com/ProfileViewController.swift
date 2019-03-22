//
//  ProfileViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/10.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseUI
import FirebaseStorage

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let user = Auth.auth().currentUser
    var ref: DatabaseReference!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var image: UIImage!
    
    @IBOutlet weak var gamename: UILabel!
    var GameName = ""

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBAction func btnReset(_ sender: Any) {
        self.imageView.image = UIImage(named: "default.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // 選択した写真を取得
            image = info[.originalImage] as? UIImage
            // ImageViewに表示する
            self.imageView.image = image
            // 写真を選ぶビューを消す
            self.dismiss(animated: true)
        
        //GameChooseで選択したゲーム名をs受け取る
        gamename.text = GameName
        print("選択されたゲーム：" + gamename.text!)
        
        imageView.image = UIImage(named: "default.png")
        
        //現在ログイン中のユーザーのuserNameを表示
        username.text = user?.displayName
        // Do any additional setup after loading the view, typically from a nib.
        }}
    
    
    
    @IBAction func btnSelect(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // ライブラリから選ぶ
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            // 表示
            self.present(pickerView, animated: true)
            
        }
    }
    
    

    @IBAction func btnUpload(_ sender: Any) {
        
        let storageref = storage.reference()
        let usericonref = storageref.child("usericon")
        let usericonimage = image?.jpegData(compressionQuality: 0.9)
    
        usericonref.putData(usericonimage!)
    }
    

    
    @IBOutlet weak var NicknameTextField: UITextField!
    
    
    @IBOutlet weak var IntroduceTextField: UITextField!
    
    
    @IBAction func DecideButtonTapped(_ sender: Any) {
      
       
         db.collection("users").document((user?.uid)!).collection("Games").document(GameName).setData([
            "nickname": NicknameTextField.text!,
            "introduce": IntroduceTextField.text!
            ])
        
        print("Profile Saved")
        
        self.performSegue(withIdentifier: "ToSwipe", sender: (Any).self)

        
        
        }
    }
    
    

        // Do any additional setup after loading the view.

    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



