//
//  ProfileViewController.swift
//  gamies.com
//
//  Created by Akira Norose on 2019/03/10.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import NCMB


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let applicationkey = "6592f551af5bd3d036a6d2e256c3f355ee613b1fb786b16c6cd61fffdcc24fdf"
    let clientkey  = "a1718a69a8664ce4cbefc668d1a3017915ab1a923f4c98dd82231d400c5fd101"
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // 選択した写真を取得
        let image = info[.originalImage] as! UIImage
        // ImageViewに表示する
        self.imageView.image = image
        // 写真を選ぶビューを消す
        self.dismiss(animated: true)

    }
    
    let user = NCMBUser.current()
    
    var objId = String()
    
    @IBOutlet weak var gamename: UILabel!
    var GameName = ""

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBAction func btnReset(_ sender: Any) {
        self.imageView.image = UIImage(named: "default.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GameChooseで選択したゲーム名をs受け取る
        gamename.text = GameName
        print("洗濯されたゲーム：" + gamename.text!)
        
        imageView.image = UIImage(named: "default.png")
        
        //現在ログイン中のユーザーのuserNameを表示
        username.text = user?.userName
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
        let imageData = self.imageView.image!.jpegData(compressionQuality: 0.80)
        let photoData:Data = NSData(data: imageData!) as Data
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-HH-mm-ss"
        let fileName = formatter.string(from: Date()) + ".jpg"
        // データとファイル名でNCMBFileを作成
        let file = NCMBFile.file(withName: fileName, data: photoData) as! NCMBFile
        // 保存処理
        file.saveInBackground({ (error) in
            if error != nil {
                // 保存失敗時の処理
                print(error)
            } else {
                print("imageupload successed")
                // 保存成功時の処理
            }
        })
    }
    

    
    @IBOutlet weak var NicknameTextField: UITextField!
    
    
    @IBOutlet weak var IntroduceTextField: UITextField!
    
    
    @IBAction func DecideButtonTapped(_ sender: Any) {
        //let obj = NCMBObject(className: "Userclass")
       
       
        
        let profile = NCMBObject(className: "Profileclass")
        profile?.setObject(NicknameTextField.text , forKey: "nickname")
        profile?.setObject(IntroduceTextField.text , forKey: "introduce")
        profile?.save(nil)
        
        
        let gameobj = NCMBObject(className: "Gameclass", objectId: objId)
        gameobj?.setObject(profile, forKey: "Profile")
        gameobj?.saveInBackground({ (err) in
            if err != nil {
                print("SaveProfileFailed")
                print(err?.localizedDescription ?? "");
            } else {
                print("ProfileSaved");
                self.performSegue(withIdentifier: "ToSwipe", sender: (Any).self)
            }
        })
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



