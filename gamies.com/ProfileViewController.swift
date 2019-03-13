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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得
        let image = info[.originalImage] as! UIImage
        // ImageViewに表示する
        self.imageView.image = image
        // 写真を選ぶビューを消す
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var gamename: UILabel!
    var GameName = ""

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func btnReset(_ sender: Any) {
        self.imageView.image = UIImage(named: "default.png")
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
        let photoData:Data = NSData(data: UIImageJPEGRepresentation(self.imageView.compressionQuality!, 0.80)!) as Data
        // ファイル名の処理
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
                // 保存成功時の処理
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamename.text = GameName
        print(gamename.text)
        
        imageView.image = UIImage(named: "default.png")
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        
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


