//
//  UIViewExtension.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit

// 添加渐变色
extension UIView {
    func addGradientLayerWithColors(colors:
        [CGColor] = [RGB(0, g: 234, b: 151).cgColor,
                     RGB(25, g: 81, b: 255).cgColor],bounds:CGRect) {
        
        
        //定义渐变的颜色
        let gradientColors = colors
        
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addLineLayerWithColors(colors:
        [CGColor] = [RGB(53, g: 255, b: 206).cgColor,
                     RGB(25, g: 135, b: 255).cgColor],bounds:CGRect) {
        
        //定义渐变的颜色
        let gradientColors = colors
        
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
