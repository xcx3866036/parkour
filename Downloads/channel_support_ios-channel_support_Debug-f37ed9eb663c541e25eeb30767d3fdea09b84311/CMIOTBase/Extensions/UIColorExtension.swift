//
//  UIColorExtension.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/26.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(rgb:Int){
        let r = CGFloat(((rgb & 0xFF0000)>>16)) / CGFloat(255.0)
        let g = CGFloat(((rgb & 0xFF00)>>8)) / CGFloat(255.0)
        let b = CGFloat(((rgb & 0xFF))) / CGFloat(255.0)
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    class func colorWithHexString(hex:String,alpha:Float = 1) -> UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect.init(x: 0, y: 0, w: 1, h: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage.init()
        UIGraphicsEndImageContext()
        return image
    }
}
