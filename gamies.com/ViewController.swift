//
//  ViewController.swift
//  Tinderaaa
//
//  Created by Akira Norose on 2019/03/06.
//  Copyright © 2019 Akira Norose. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var BasicCard: UIView!
    @IBOutlet weak var likeimageView: UIImageView!
 
    @IBOutlet weak var Person1: UIView!
    @IBOutlet weak var Person2: UIView!
    @IBOutlet weak var Person3: UIView!
    @IBOutlet weak var Person4: UIView!
    
    var centerOfCard: CGPoint!
    var people = [UIView]()
    var selectedCardCount: Int = 0
    
    let name = ["ほのか", "あかり", "ゆり", "マイク"]
    var likedName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOfCard = BasicCard.center
        people.append(Person1)
        people.append(Person2)
        people.append(Person3)
        people.append(Person4)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func resetCard() {
        BasicCard.center = self.centerOfCard
        BasicCard.transform = .identity
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushList"{
            let vc = segue.destination as! ListViewController
            vc.likedName = likedName
        }
    }
    @IBAction func SwipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        people[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        //角度を変える
        let xFromCenter = card.center.x - view.center.x
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2 ) * 0.785)
        people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2 ) * 0.785)
        
        if xFromCenter > 0 {
            likeimageView.image = UIImage(named: "good")
            likeimageView.alpha = 1
            likeimageView.tintColor = UIColor.blue
        } else if xFromCenter < 0 {
            likeimageView.image = UIImage(named: "bad")
            likeimageView.alpha = 1
            likeimageView.tintColor = UIColor.red
        }
        
        if sender.state == UIGestureRecognizer.State.ended {
            //左に大きくスワイプ
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 350, y: self.people[self.selectedCardCount].center.y)
                })
                likeimageView.alpha = 0
                selectedCardCount += 1
                if selectedCardCount >= people.count{
                    performSegue(withIdentifier: "PushList", sender: self)
                }
                return
            //右に大きくスワイプ
            } else if card.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 350, y: self.people[self.selectedCardCount].center.y)
                })
                likeimageView.alpha = 0
                likedName.append(name[selectedCardCount])
                selectedCardCount += 1
                if selectedCardCount >= people.count{
                    performSegue(withIdentifier: "PushList", sender: self)
                }
               
                return
            }
            
        
            //元に戻る
            UIView.animate(withDuration: 0.2, animations:{
                self.resetCard()
                self.people[self.selectedCardCount].center = self.centerOfCard
                self.people[self.selectedCardCount].transform = .identity
        })
        likeimageView.alpha = 0
        }
        
    }
}
