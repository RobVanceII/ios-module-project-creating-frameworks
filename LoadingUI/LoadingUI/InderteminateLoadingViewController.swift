//
//  InderteminateLoadingViewController.swift
//  LoadingUI
//
//  Created by Rob Vance on 10/5/20.
//

import UIKit

class InderteminateLoadingViewController: UIView, CAAnimationDelegate {

    private(set) var isAnimating = false
    
    private let shapeLayer = CAShapeLayer()
    private let duration = 1.3
    private var shouldStopAnimationOnNextCycle = false

   public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupShapeLayer()
    }
    
    public func startAnimating() {
        guard !isAnimating else { return }
        defer { isAnimating = true }
    
        startAnimation()
    }
    
    func stopAnimating() {
        guard isAnimating else { return }
        
        shouldStopAnimationOnNextCycle = true
    }
    
    // MARK: - Private -
    
    private func setupShapeLayer() {
        let thickness: CGFloat = 25.0
        
        shapeLayer.frame = layer.bounds
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = thickness
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        layer.addSublayer(shapeLayer)
        
        let radius = min(bounds.width, bounds.height) / 4.0 - thickness/2.0
        let rect = CGRect(x: bounds.midX - radius/2.0, y: bounds.midY - radius/2.0, width: radius, height: radius)
        let path = UIBezierPath(ovalIn: rect)
        
        shapeLayer.path = path.cgPath
    }
    
    public func startAnimation() {
        shouldStopAnimationOnNextCycle = false
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        startAnimation(for: "strokeEnd", timing: .easeIn)
    }
    
    private func startAnimation(for keyPath: String, timing: CAMediaTimingFunctionName) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = duration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: timing)
        shapeLayer.add(animation, forKey: keyPath)
    }
    
    // MARK: - CAAnimationDelegate -
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard !shouldStopAnimationOnNextCycle else {
            shouldStopAnimationOnNextCycle = false
            isAnimating = false
            return
        }
        
        if let anim = anim as? CABasicAnimation, anim.keyPath == "strokeEnd" {
            shapeLayer.strokeStart = 0.0
            shapeLayer.strokeEnd = 1.0
            shapeLayer.removeAllAnimations()
            startAnimation(for: "strokeStart", timing: .easeOut)
        }
        
        if let anim = anim as? CABasicAnimation, anim.keyPath == "strokeStart" {
            shapeLayer.strokeStart = 0.0
            shapeLayer.strokeEnd = 0.0
            shapeLayer.removeAllAnimations()
            startAnimation(for: "strokeEnd", timing: .easeIn)
        }
    }
}