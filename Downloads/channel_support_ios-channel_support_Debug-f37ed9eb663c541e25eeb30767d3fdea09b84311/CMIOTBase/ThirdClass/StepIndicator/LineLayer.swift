//
//  HorizontalLineLayer.swift
//  StepIndicator
//
//  Created by Yun CHEN on 2017/9/1.
//  Copyright © 2017 Yun CHEN. All rights reserved.
//

import UIKit

class LineLayer: CAShapeLayer {
    
    private let tintLineLayer = CAShapeLayer()
    private let maskLineLayer = CAShapeLayer()
    
    // MARK: - Properties
    var step : Int = 0
    var currentStep: Int = 0
    var sumStep: Int = 0
    var tintColor:UIColor?
    var isFinished:Bool = false {
        didSet{
            self.updateStatus()
        }
    }
    
    var isHorizontal:Bool = true {
        didSet{
            self.updateStatus()
        }
    }
    
    //MARK: - Initialization
    override init() {
        super.init()
        
        self.fillColor = UIColor.clear.cgColor
        self.lineWidth = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    // MARK: - Functions
    func updateStatus() {
        maskLineLayer.removeFromSuperlayer()
        self.drawLinePath()
        if isFinished {
            self.drawTintLineAnimated()
        }
        else{
            tintLineLayer.removeFromSuperlayer()
        }
    }
    
    private func drawLinePath() {
        let linePath = UIBezierPath()
        let maskLinePath = UIBezierPath()
        
        var maskWidth = self.frame.width
        if step < currentStep {
            maskWidth = self.frame.width
        }
        else if step == currentStep {
            maskWidth = self.frame.width / 2
        }
        else{
            maskWidth = 0
        }
        
        if self.isHorizontal {
            let centerY = self.frame.height / 2.0
            linePath.move(to: CGPoint(x: 0, y: centerY))
            linePath.addLine(to: CGPoint(x: self.frame.width, y: centerY))
            maskLinePath.move(to: CGPoint(x: 0, y: centerY))
            maskLinePath.addLine(to: CGPoint(x: maskWidth, y: centerY))
        }
        else{
            let centerX = self.frame.width / 2.0
            linePath.move(to: CGPoint(x: centerX, y: 0))
            linePath.addLine(to: CGPoint(x:centerX , y: self.frame.height))
            maskLinePath.move(to: CGPoint(x: centerX, y: 0))
            maskLinePath.addLine(to: CGPoint(x:centerX , y: self.frame.height))
        }
        self.path = linePath.cgPath
        
        self.maskLineLayer.path = maskLinePath.cgPath
        self.maskLineLayer.frame = self.bounds
        self.maskLineLayer.strokeColor = UIColor.white.cgColor
        self.maskLineLayer.lineWidth = self.lineWidth
        self.addSublayer(self.maskLineLayer)
    }
    
    private func drawTintLineAnimated() {
        let tintLinePath = UIBezierPath()
        if self.isHorizontal {
            let centerY = self.frame.height / 2.0
            tintLinePath.move(to: CGPoint(x: 0, y: centerY))
            tintLinePath.addLine(to: CGPoint(x: self.frame.width, y: centerY))
        }
        else{
            let centerX = self.frame.width / 2.0
            tintLinePath.move(to: CGPoint(x: centerX, y: 0))
            tintLinePath.addLine(to: CGPoint(x: centerX, y: self.frame.height))
        }

        self.tintLineLayer.path = tintLinePath.cgPath
        self.tintLineLayer.frame = self.bounds
        self.tintLineLayer.strokeColor = self.tintColor?.cgColor
        self.tintLineLayer.lineWidth = self.lineWidth
        
        self.addSublayer(self.tintLineLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        self.tintLineLayer.add(animation, forKey: "animationDrawLine")
    }
}
