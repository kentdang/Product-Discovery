//
//  PromotionView.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class PromotionView: UIView {
    private weak var shapeLayer: CAShapeLayer!
    private weak var gradientLayer: CAGradientLayer!
    
    override var frame: CGRect {
        didSet {
            if frame.size != oldValue.size {
                updateShape()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        let shapeLayer = CAShapeLayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.main.cgColor, UIColor.orangeRed.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = shapeLayer
        layer.insertSublayer(gradientLayer, at: 0)
        self.shapeLayer = shapeLayer
        self.gradientLayer = gradientLayer
        updateShape()
    }
    
    func updateShape() {
        guard let shapeLayer = shapeLayer, let gradientLayer = gradientLayer else { return }
        let rect = bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width / 8, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width / 8, y: rect.height))
        path.close()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.frame = rect
        gradientLayer.frame = rect
    }
}
