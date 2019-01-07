//
//  UIButtonExtension.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/25.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit

//MARK: UIButton - 带图片button
extension UIButton {
    enum ZSButtonEdgeInsetsStyle {
        case ZSButtonEdgeInsetsStyleTop
        case ZSButtonEdgeInsetsStyleLeft
        case ZSButtonEdgeInsetsStyleRight
        case ZSButtonEdgeInsetsStyleBottom
    }
    
    func LayoutButtonWithEdgeInsetsStyle(style : ZSButtonEdgeInsetsStyle , imageTitleSpace : CGFloat) {
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        var labelWidth : CGFloat = 0.0
        var labelHeight : CGFloat = 0.0
        
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
        labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        
        var imageEdgeInsets : UIEdgeInsets!
        var labelEdgeInsets : UIEdgeInsets!
        switch style {
        case .ZSButtonEdgeInsetsStyleTop:
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-imageTitleSpace/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth!, -imageHeight!-imageTitleSpace/2.0, 0);
            break;
        case .ZSButtonEdgeInsetsStyleLeft:
            
            imageEdgeInsets = UIEdgeInsetsMake(0, -imageTitleSpace/2.0, 0, imageTitleSpace/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, imageTitleSpace/2.0, 0, -imageTitleSpace/2.0);
            break;
        case .ZSButtonEdgeInsetsStyleBottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-imageTitleSpace/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight!-imageTitleSpace/2.0, -imageWidth!, 0, 0);
            break;
        case .ZSButtonEdgeInsetsStyleRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+imageTitleSpace/2.0, 0, -labelWidth-imageTitleSpace/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth!-imageTitleSpace/2.0, 0, imageWidth!+imageTitleSpace/2.0);
            break;
        default:
            break;
        }
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
        
    }
    
    func addAttTitle(mainTitle: String, subTitle: String) {
        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(255, g: 255, b: 255) ]
        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(108, g: 204, b: 251)]
        
        let nextAttStr = NSMutableAttributedString.init(string: mainTitle, attributes: singleAttribute1)
        let selectAttStr = NSAttributedString.init(string: subTitle, attributes: singleAttribute2)
        nextAttStr.append(selectAttStr)
        
        self.setAttributedTitle(nextAttStr, for: .normal)
    }
}
