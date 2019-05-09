//
//  HamburgerViewController.swift
//  gamies.com
//
//  Created by akira on 2019/05/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var HamburgerMenu: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let menuPosition = self.HamburgerMenu.layer.position
        //// 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.HamburgerMenu.layer.position.x = -self.HamburgerMenu.frame.width
        
        // 表示時のアニメーション
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: {self.HamburgerMenu.layer.position.x = menuPosition.x},
            completion: {bool in})
    }
    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1{
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {self.HamburgerMenu.layer.position.x = -self.HamburgerMenu.frame.width} ,
                    completion: {bool in self.dismiss(animated: true, completion: nil)}
                )
            }
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
