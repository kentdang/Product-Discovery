//
//  GradientView.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class GradientView: UIView {
    private weak var gradientLayer: CAGradientLayer!
    
    var gradientColors: [UIColor] = [] {
        didSet {
            guard let gradientLayer = gradientLayer else { return }
            gradientLayer.colors = gradientColors.map { $0.cgColor }
            updateGradient()
        }
    }
    
    @objc var startColor: UIColor = UIColor.white.withAlphaComponent(0) {
        didSet {
            gradientColors = [startColor, endColor]
        }
    }
    
    @objc var endColor: UIColor = UIColor.white.withAlphaComponent(0) {
        didSet {
            gradientColors = [startColor, endColor]
        }
    }
    
    @objc var startPoint: CGPoint = .init(x: 0, y: 0.5) {
        didSet {
            updateGradient()
        }
    }
    
    @objc var endPoint: CGPoint = .init(x: 1, y: 0.5) {
        didSet {
            updateGradient()
        }
    }
    
    override var frame: CGRect {
        didSet {
            if let gradientLayer = gradientLayer, frame.size != oldValue.size {
                gradientLayer.frame = bounds
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
        backgroundColor = UIColor.clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
    
    private func updateGradient() {
        guard let gradientLayer = gradientLayer else { return }
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
