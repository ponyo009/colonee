//
//  ViewGradient.swift
//  gamies.com
//
//  Created by akira on 2019/07/05.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
    }
}

override var layerClass: AnyClass {
    get {
        return CAGradientLayer.self
    }
}
func updateView() {
    let layer = self.layer as! CAGradientLayer
    layer.colors = [firstColor, secondColor].map{$0.cgColor}
}

@IBInspectable var isHorizontal: Bool = true {
    didSet {
        updateView()
    }
}
func updateView() {
    let layer = self.layer as! CAGradientLayer
    layer.colors = [firstColor, secondColor].map{$0.cgColor}
    if (sef.isHorizontal) {
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint (x: 1, y: 0.5)
    } else {
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint (x: 0.5, y: 1)
    }
}

